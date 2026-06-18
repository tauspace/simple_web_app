ARG ELIXIR_VERSION=1.18.3
ARG OTP_VERSION=27.3.4
ARG ALPINE_VERSION=3.21.3

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"

# ── Stage 1: build ────────────────────────────────────────────────────────────
FROM ${BUILDER_IMAGE} AS builder

RUN apk add --no-cache build-base git

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

COPY config config/
COPY priv priv/
COPY assets assets/

# Download esbuild and tailwind binaries (cached layer; re-runs only when config/assets change)
RUN mix tailwind.install --if-missing && \
    mix esbuild.install --if-missing

COPY lib lib/

# Compile application — the phoenix_live_view compiler writes
# _build/prod/phoenix-colocated/simple_web_app/colocated.css here,
# which app.css imports and Tailwind must resolve before assets.deploy.
RUN mix compile

RUN mix assets.deploy
RUN mix release

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
FROM ${RUNNER_IMAGE} AS runner

# Runtime deps: OpenSSL (crypto), ncurses (Erlang shell), libstdc++ (NIFs)
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/prod/rel/simple_web_app ./

USER nobody

# Phoenix / release variables
# PHX_SERVER=true   — start the HTTP server inside the release
# SECRET_KEY_BASE   — required; generate with: mix phx.gen.secret
# PHX_HOST          — public hostname (default: example.com)
# PORT              — HTTP port (default: 4000)
#
# html_to_pdf variables
# GOTENBERG_URL     — required; base URL of your Gotenberg instance, e.g. http://gotenberg:3000
# GOTENBERG_TIMEOUT — optional; request timeout in ms (default: 30000)
ENV PHX_SERVER=true

EXPOSE 4000

CMD ["bin/simple_web_app", "start"]
