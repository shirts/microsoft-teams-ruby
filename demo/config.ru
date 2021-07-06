# frozen_string_literal: true

require "ms_teams"

def generate_html_with(env)
  post_data = Rack::Request.new(env).params
  response = ''
  configurations = {}
  configurations_is_filled = !post_data.empty? && !post_data['configurations'].nil? && !post_data['configurations'].empty?
  
  example_configurations = {
    "url": "INSERT_HERE_YOUR_MICROSOFT_TEAMS_INCOMING_WEBHOOK_URL",
    "title": "My first message!",
    "text": "Hey, that is my first message!",
    "summary": "Check it, please!",
    "themeColor": "00ff44",
    "sections": [
      {
        "text": "Hey, thanks for using this demo! That's your first message with incoming webhooks of Microsoft Teams. Enjoy!",
        "activityTitle": "Pedro Furtado",
        "activitySubtitle": "01/01/1990, 7:30AM",
        "activityImage": "https://github.com/pedrofurtado.png",
        "facts": [
          {
            "name": "Origin:",
            "value": "Demo"
          },
          {
            "name": "Awesome:",
            "value": "Yes!"
          }
        ]
      }
    ],
    "potentialAction": [
      {
        "@type": "ActionCard",
        "name": "Quiz",
        "inputs": [
          {
            "@type": "TextInput",
            "id": "description",
            "isMultiline": true,
            "title": "Description"
          }
        ],
        "actions": [
          {
            "@type": "HttpPOST",
            "name": "Send answer",
            "isPrimary": true,
            "target": "https://some-external-site.com/myaction/do-it"
          }
        ]
      },
      {
        "@type": "HttpPOST",
        "name": "Decline",
        "target": "https://some-external-site.com/myaction/do-it-again"
      },
      {
        "@type": "OpenUri",
        "name": "Open a link",
        "targets": [
          {
            "os": "default",
            "uri": "https://github.com/shirts/microsoft-teams-ruby"
          }
        ]
      }
    ]
  }

  if configurations_is_filled
    begin
      configurations = JSON.parse(post_data['configurations'])

      message = MsTeams::Message.new do |m|
        configurations.entries.each do |k, v|
          m[k] = v
        end
      end

      begin
        message.send
        response = "✅ Message sent! 🚀"
      rescue MsTeams::Message::FailedRequest => e
        response = "❌ Message not sent, check the error: Failed request - #{e.message}"
      end
    rescue JSON::ParserError => e
      response = "⚠️ Message with error: JSON invalid - #{e.message}"
    rescue StandardError => e
      response = "❌ Message with error: Generic error - #{e.message}"
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
                  <textarea class='form-control' rows='10' name='configurations'>#{JSON.pretty_generate(configurations.empty? ? example_configurations : configurations)}</textarea>
                </div>
                <br>
                <div class='d-grid gap-2'>
                  <button type='submit' class='btn btn-lg btn-primary'>Send message</button>
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
