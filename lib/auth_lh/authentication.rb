module AuthLh
  module Authentication
    def self.included(base)
        base.extend(ClassMethods)
    end

    def auth_user
      if @auth_user.nil?
        @auth_user = self.class.find_external(login)
      end

      @auth_user
    end

    def auth_user=(val)
      @auth_user = val
    end

    module ClassMethods
      def all_external
        unless @cache_auth_users
          @cache_auth_users = AuthLh.get_users
        end

        @cache_auth_users
      end

      def find_external(login)
        all_external.find { |x| x.login == login.to_s }
      end

      def find_current_user(session_token, remote_ip)
        if (session_token.present? && (@session_token != session_token))
          response = AuthLh.get_current_user(session_token, remote_ip)

          if response.nil?
            @cached_logged_user = nil
            @session_token = nil
            @login_error = nil
          else
            @cached_logged_user = response.user
            @session_token = session_token
            @login_error = response.reason
          end
        end

        if @cached_logged_user
          user = find_or_create_by(login: @cached_logged_user.login)
          user.auth_user = @cached_logged_user
          user
        else
          nil
        end
      end

      def login_url
        if @login_error
          "#{AuthLh.login_url}&reason=#{@login_error}"
        else
          AuthLh.login_url
        end
      end

      def logout_url
        AuthLh.logout_url
      end
    end
  end
end

