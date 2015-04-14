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
        AuthLh.get_users
      end

      def find_external(login)
        all_external.find { |x| x.login == login.to_s }
      end

      def find_current_user(session_token, remote_ip)
        response = AuthLh.get_current_user(session_token, remote_ip)

        if response.nil?
          logged_user = nil
          login_error = nil
        else
          logged_user = response.user
          login_error = response.reason
        end

        if logged_user
          user = find_or_create_by(login: logged_user.login)
          user.auth_user = logged_user
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

      def change_password_url
        AuthLh.change_password_url
      end
    end
  end
end

