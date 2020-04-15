RSpec.describe MsTeams::Message do

	context '#initialize' do

		it 'constructs an OpenStruct object from the given block' do
			message = MsTeams::Message.new do |m|
				m.url = "https://example.com"
				m.title = "Hello World"
				m.text = "1 2 3"
				m.arbitrary_field = "An arbitrary field"
			end

			expect( message ).to_not be_nil
			expect( message.builder ).to_not be_nil
			expect( message.builder.url ).to eq( "https://example.com" )
			expect( message.builder.title ).to eq( "Hello World" )
			expect( message.builder.text ).to eq( "1 2 3" )
			expect( message.builder.arbitrary_field ).to eq( "An arbitrary field" )
		end

		it 'requires a block to be initialized' do
			expect{ MsTeams::Message.new }.to raise_error( LocalJumpError )
		end

		it 'raises an ArgumentError when the `builder` object is initialized without a url property' do
			expect do
				MsTeams::Message.new do |m|
					m.url = nil
					m.text = "1 2 3"
				end
			end.to raise_error( ArgumentError, "`url` cannot be nil. Must be set during initialization" )

			expect do
				MsTeams::Message.new do |m|
					m.url = ""
					m.text = "1 2 3"
				end
			end.to raise_error( ArgumentError, "`url` cannot be nil. Must be set during initialization" )
		end

		it 'raises an ArgumentError when the `builder` object is initialized without a text property' do
			expect do
				MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = nil
				end
			end.to raise_error( ArgumentError, "`text` cannot be nil. Must be set during initialization" )

			expect do
				MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = ""
				end
			end.to raise_error( ArgumentError, "`text` cannot be nil. Must be set during initialization" )
		end
	end

	context '#send' do

		context 'with a valid `builder` object' do

			it "returns Net::HTTPOK" do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com/example"
					m.text = "1 2 3"
				end

				stub_request(:post, "https://example.com/example").
						with(
								headers: { 'Accept': '*/*',
								           'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
								           'Content-Type': 'application/json',
								           'User-Agent': 'Ruby' },
								body: {
										"url": "https://example.com/example",
										"text": "1 2 3"
								}).
						to_return(status: 200, body: "", headers: {})

				expect( message.send.response.code.to_i ).to eq( 200 )
			end
		end

		context 'with an invalid `builder` object' do

			it 'does raise an error without a set url property' do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message.builder.delete_field( :url )

				expect{ message.send }.to raise_error( URI::InvalidURIError )

				message_2 = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message_2.builder.url = ""

				expect{ message_2.send }.to raise_error( ArgumentError )
			end

			it "returns Net::HTTPBadRequest without a set text property" do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com/example"
					m.text = "1 2 3"
				end

				message.builder.delete_field( :text )

				stub_request(:post, "https://example.com/example").
						with(
								headers: { 'Accept': '*/*',
								           'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
								           'Content-Type': 'application/json',
								           'User-Agent': 'Ruby' },
								body: {
										"url": "https://example.com/example"
								}).
						to_return(status: 400, body: "", headers: {})

				expect{ message.send }.to raise_error( MsTeams::Message::FailedRequest )

				message_2 = MsTeams::Message.new do |m|
					m.url = "https://example.com/example"
					m.text = "1 2 3"
				end

				message_2.builder.text = ""

				stub_request(:post, "https://example.com/example").
						with(
							headers: { 'Accept': '*/*',
							           'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
							           'Content-Type': 'application/json',
							           'User-Agent': 'Ruby' },
							body: {
						     "url": "https://example.com/example",
						     "text": ""
							}).
						to_return(status: 400, body: "", headers: {})

				expect{ message_2.send }.to raise_error( MsTeams::Message::FailedRequest )
			end
		end

	end

	context '#validate' do

		context 'with a valid `builder` object' do
			it 'does not raise an error' do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				expect( message.validate ).to be( true )
			end
		end

		context 'with an invalid `builder` object' do
			it 'does raise an error without a set url property' do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message.builder.delete_field( :url )

				expect{ message.validate }.to raise_error(
					ArgumentError, "`url` cannot be nil. Must be set during initialization"
				)

				message_2 = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message_2.builder.url = ""

				expect{ message_2.validate }.to raise_error(
					ArgumentError, "`url` cannot be nil. Must be set during initialization"
				)
			end

			it 'does raise an error without a set text property' do
				message = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message.builder.delete_field( :text )

				expect{ message.validate }.to raise_error(
					ArgumentError, "`text` cannot be nil. Must be set during initialization"
				)

				message_2 = MsTeams::Message.new do |m|
					m.url = "https://example.com"
					m.text = "1 2 3"
				end

				message_2.builder.text = ""

				expect{ message_2.validate }.to raise_error(
					ArgumentError, "`text` cannot be nil. Must be set during initialization"
				)
			end
		end

	end

end
