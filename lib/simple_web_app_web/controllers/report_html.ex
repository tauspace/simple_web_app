defmodule SimpleWebAppWeb.ReportHTML do
  # A 32x32 orange (#F97316) square PNG encoded as base64, used to verify image support in PDFs.
  @logo_base64 "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAKklEQVR42mP4WSxGU8QwasGoBaMW" <>
               "jFowasGoBaMWjFowasGoBaMWDBULADzqCFvAf1PqAAAAAElFTkSuQmCC"

  @sample_data [
    %{id: 1, name: "Alice Johnson", department: "Engineering", salary: "$95,000", status: "Active"},
    %{id: 2, name: "Bob Martinez", department: "Marketing", salary: "$72,000", status: "Active"},
    %{id: 3, name: "Carol Lee", department: "Engineering", salary: "$102,000", status: "Active"},
    %{id: 4, name: "David Kim", department: "Sales", salary: "$68,000", status: "Inactive"},
    %{id: 5, name: "Eva Nguyen", department: "HR", salary: "$61,000", status: "Active"},
    %{id: 6, name: "Frank Wilson", department: "Engineering", salary: "$88,000", status: "Active"},
    %{id: 7, name: "Grace Chen", department: "Finance", salary: "$79,000", status: "Active"},
    %{id: 8, name: "Henry Brown", department: "Sales", salary: "$74,000", status: "Inactive"}
  ]

  def sample_data, do: @sample_data
  def logo_base64, do: @logo_base64

  def render_to_string do
    rows =
      Enum.map_join(@sample_data, "\n", fn row ->
        status_color = if row.status == "Active", do: "color:#166534", else: "color:#991b1b"

        """
        <tr>
          <td style="padding:10px 14px;border-bottom:1px solid #e5e7eb;">#{row.id}</td>
          <td style="padding:10px 14px;border-bottom:1px solid #e5e7eb;">#{row.name}</td>
          <td style="padding:10px 14px;border-bottom:1px solid #e5e7eb;">#{row.department}</td>
          <td style="padding:10px 14px;border-bottom:1px solid #e5e7eb;">#{row.salary}</td>
          <td style="padding:10px 14px;border-bottom:1px solid #e5e7eb;#{status_color}">#{row.status}</td>
        </tr>
        """
      end)

    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <style>
        body { font-family: Arial, sans-serif; margin: 40px; color: #111827; }
        h1 { font-size: 24px; margin-bottom: 4px; }
        .subtitle { color: #6b7280; font-size: 13px; margin-bottom: 24px; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        thead tr { background: #1e40af; color: white; }
        thead th { padding: 12px 14px; text-align: left; }
        tbody tr:nth-child(even) { background: #f9fafb; }
        .logo { width: 64px; height: 64px; margin-bottom: 16px; }
      </style>
    </head>
    <body>
      <img class="logo" src="data:image/png;base64,#{@logo_base64}" alt="Company Logo" />
      <h1>Employee Report</h1>
      <p class="subtitle">Generated #{Date.utc_today()}</p>
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Name</th>
            <th>Department</th>
            <th>Salary</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
    #{rows}
        </tbody>
      </table>
    </body>
    </html>
    """
  end
end
