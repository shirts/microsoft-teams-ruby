# frozen_string_literal: true

require "ms_teams"

def generate_html_with(env)
  post_data = Rack::Request.new(env).params
  response = ''
  configurations_is_filled = !post_data.empty? && !post_data['configurations'].nil? && !post_data['configurations'].empty?

  if configurations_is_filled
    configurations = {}

    begin
      configurations = JSON.parse(post_data['configurations'].strip)

      message = MsTeams::Message.new do |m|
        configurations.entries do |k, v|
          m[k] = v
        end
      end

      begin
        message.send
        response = 'Message sent!'
      rescue MsTeams::Message::FailedRequest => e
        response = "Message not sent, check the error: #{e.message}"
      end
    rescue StandardError => e
      response = "Message not sent, check the error: JSON invalid - #{e.message}"
    end
  end

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
                          "text": "There is a problem with Push notifications, they dont seem to be picked up by the connector.",
                          "activityTitle": "Miguel Garcie",
                          "activitySubtitle": "9/13/2016, 11:46am",
                          "activityImage": "https://connectorsdemo.azurewebsites.net/images/MSC12_Oscar_002.jpg",
                          "facts": [
                            {
                              "name": "Repository:",
                              "value": "mgarciatest"
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
                              "target": "https://jsonplaceholder.typicode.com/posts"
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
                <div class='d-grid gap-2'>
                  <button type='submit' class='btn btn-lg btn-primary'>Send</button>
                </div>
              <form>
            </div>
            <div class='col-md-6'>
              <strong>Result</strong>
              <br>
              <br>
              <p>#{response}</p>
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
