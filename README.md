# MS-Teams

[![CI](https://github.com/shirts/microsoft-teams-ruby/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/shirts/microsoft-teams-ruby/actions/workflows/ci.yml)

A lightweight Ruby gem to send
[actionable message cards](https://docs.microsoft.com/en-us/outlook/actionable-messages/send-via-connectors)
to an Office 365 group (Microsoft Teams)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ms_teams"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ms_teams

## Usage

Sending a simple message with just text:

The most-barebones your message will be will include at least:
 - `url`: The Incoming Webhook connector generated via Teams
 - `text`: The text of the message you are sending

Example:
```ruby
require "ms_teams"

message = MsTeams::Message.new do |m|
    m.url = "https://outlook.office.com/...."
    m.text = "Hello World!"
end

message.send

```

You can build the message with any supported [card fields](https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference#card-fields).
This example is taken directly from [Microsoft Docs](https://docs.microsoft.com/en-us/outlook/actionable-messages/send-via-connectors)
```ruby
require "ms_teams"

message = MsTeams::Message.new do |m|
    m.url = "https://outlook.office.com/...."
    m.themeColor = "0072C6"
    m.title = "Visit the Outlook Dev Portal"
    m.text = "Click **Learn More** to learn more about Actionable Messages!"
    m.potentialAction = [
        {
            "@type": "ActionCard",
            "name": "Send Feedback",
            "inputs": [{
                "@type": "TextInput",
                "id": "feedback",
                "isMultiline": true,
                "title": "Let us know what you think about Actionable Messages"
            }],
            "actions": [{
                "@type": "HttpPOST",
                "name": "Send Feedback",
                "isPrimary": true,
                "target": "http://..."
            }]
        },
        {
            "@type": "OpenUri",
            "name": "Learn More",
            "targets": [
                { "os": "default", "uri": "https://docs.microsoft.com/outlook/actionable-messages" }
            ]
        }
    ]
end


# You can edit any field after the message has been built by modifying the `builder` object
message.builder.text = "Something new"

message.send
```

Error Handling:

A non-2xx response code will raise a `MsTeams::Message::FailedRequest` error

```ruby
# ...
begin
    message.send
rescue MsTeams::Message::FailedRequest => e
    # Do stuff
end
```


Building an invalid message object will immediately raise an error

```ruby
message = MsTeams::Message.new do |m|
    # no url set
    m.text = "Hello World"
end

> ArgumentError (`url` cannot be nil. Must be set during initialization)

```

## Execute tests/specs

To execute gem tests locally, use Docker with the commands below:

```bash
git clone https://github.com/shirts/microsoft-teams-ruby
cd microsoft-teams-ruby
docker build -t microsoft_teams_ruby_specs .

# Then, run this command how many times you want,
# after editing local files, and so on, to get
# feedback from test suite of gem.
docker run -v $(pwd):/app/ -it microsoft_teams_ruby_specs
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shirts/microsoft-teams-ruby

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
