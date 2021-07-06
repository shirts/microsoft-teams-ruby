# frozen_string_literal: true

require "ms_teams"

def generate_html_with(env)
  StringIO.new <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' rel='stylesheet'>
        <title>MS-Teams - Demo App</title>
      </head>
      <body>
        demo page for gem ms_teams 2
      </body>
    </html>
  HTML
end

run lambda { |env|
  [
    200,
    {
      "Content-Type" => "text/html"
    },
    generate_html_with(env)
  ]
}
