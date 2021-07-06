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
        <div class='container'>
          <div class='row'>
            <div class='col-md-6'>
              <strong>Configuration</strong>
              <br>
              <br>
              <form action='https://microsoft-teams-ruby.herokuapp.com/' method='post'>
                <div class='form-group'>
                  <textarea class='form-control' rows='10' name='configurations'>
                    {
                      "url": "",
                      "title": "qqqqqq",
                      "text": "xx",
                      "summary": "qq",
                      "themeColor": "fcba03",
                      "sections": [
                        {
                          "text": "There is a problem with Push notifications, they don't seem to be picked up by the connector.",
                          "activityTitle": "Miguel Garcie",
                          "activitySubtitle": "9/13/2016, 11:46am",
                          "activityImage": "https://connectorsdemo.azurewebsites.net/images/MSC12_Oscar_002.jpg",
                          "facts": [
                            {
                              "name": "Repository:",
                              "value": "mgarcia\\test"
                            },
                            {
                              "name": "Issue #:",
                              "value": "176715375"
                            }
                          ]
                        }
                      ],
                      "potentialAction": [
                        {
                          "@type": "ActionCard",
                          "name": "Answer",
                          "inputs": [
                            {
                              "@type": "TextInput",
                              "id": "title",
                              "isMultiline": true,
                              "title": "Main title"
                            }
                          ],
                          "actions": [
                            {
                              "@type": "HttpPOST",
                              "name": "Send",
                              "isPrimary": true,
                              "target": 'https://jsonplaceholder.typicode.com/posts'
                            }
                          ]
                        },
                        {
                          "@type": "HttpPOST",
                          "name": "Close",
                          "target": "https://jsonplaceholder.typicode.com/posts"
                        },
                        {
                          "@type": "OpenUri",
                          "name": "Access system",
                          "targets": [
                            {
                              "os": "default",
                              "uri": "https://jsonplaceholder.typicode.com"
                            }
                          ]
                        }
                      ]
                    }
                  </textarea>
                </div>
              <form>
            </div>
            <div class='col-md-6'>
              <strong>Result</strong>
              <br>
              <br>
            </div>
          </div>
        </div>
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
