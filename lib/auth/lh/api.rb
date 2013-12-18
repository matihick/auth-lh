module Auth
  module Lh
    class Api
      include Singleton

      attr_accessor :endpoint, :return_url, :application_code

      def self.configure(args={})
        instance.endpoint = (args[:endpoint] || 'https://auth.lhconfort.com.ar')
        instance.return_url = args[:return_url]
        instance.application_code = args[:application_code]
      end

      def logged_user(session_token, remote_ip)
        result = get_request '/logged_user', {
          app_code: @application_code,
          session_token: session_token,
          remote_ip: remote_ip
        }

        SessionResponse.new(result)
      end

      def login_url
        login_attempt = create_login_attempt
        "#{@endpoint}/login?attempt=#{login_attempt.token}"
      end

      def logout_url
        "#{@endpoint}/logout?return=#{CGI::escape(@return_url)}"
      end

      protected

      def create_login_attempt
        result = post_request '/login_attempts', {
          app_code: @application_code,
          return_url: @return_url
        }

        LoginAttempt.new(result)
      end

      def get_request(action, params={})
        JSON.parse(RestClient.get("#{@endpoint}#{action}", {params: params}))
      end

      def post_request(action, params={})
        JSON.parse(RestClient.post("#{@endpoint}#{action}", params))
      end
    end
  end
end
