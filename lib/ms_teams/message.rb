require "net/http"
require "json"

module MsTeams
  class Message
    class FailedRequest < StandardError; end

    # Necessary fields to successfully send a message
    REQUIRED_FIELDS = %w(text url).freeze

    attr_accessor :builder

    # Initializes Team::Messages and builds an OpenStruct object
    #   from a required block containing arbitrary values
    #   and validates that the required fields are present
    # @param block [Proc]
    def initialize( &block )
      @builder = OpenStruct.new
      yield @builder
      validate
    end


    # POSTs a message to the url.
    #   If the response is not successful it raises
    #   a MsTeams::Message::FailedRequest error
    # @return response [Net:HTTPResponse]
    def send
      uri = URI.parse( @builder.url )
      http = Net::HTTP.new( uri.host, uri.port )
      http.use_ssl = true
      response = http.post( uri.path, @builder.to_h.to_json, "Content-Type": "application/json" )
      unless successful_response?( response )
        raise FailedRequest, "Unable to send message successfully. Response code `#{response.code}`"
      end
      response
    end


    # Ensures that the required fields are present
    #   Raises an ArgumentError if the required fields are not present.
    def validate
      REQUIRED_FIELDS.each do |field|
        error( field ) if @builder[field].nil? || @builder[field].empty?
      end

      true
    end


    private


    def error( field )
      raise ArgumentError, "`#{field}` cannot be nil. Must be set during initialization"
    end


    def successful_response?( http_response )
      code = http_response&.code&.to_i
      if code < 200 || code >= 300
        return false
      end

      true
    end

  end
end
