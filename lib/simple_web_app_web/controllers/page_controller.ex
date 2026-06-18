defmodule SimpleWebAppWeb.PageController do
  use SimpleWebAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def download_pdf(conn, _params) do
    html = SimpleWebAppWeb.ReportHTML.render_to_string()

    case HtmlToPdf.generate_pdf(html) do
      {:ok, pdf_binary} ->
        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"report.pdf\"")
        |> send_resp(200, pdf_binary)

      {:error, reason} ->
        conn
        |> put_flash(:error, "PDF generation failed: #{inspect(reason)}")
        |> redirect(to: ~p"/")
    end
  end
end
