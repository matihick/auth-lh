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

      def find_current_user(session_token, remote_ip, return_url=nil)
        response = AuthLh.get_current_user(session_token, remote_ip, return_url)

        logged_user = response.user
        @login_url = response.login_url

        if logged_user
          user = find_or_create_by(login: logged_user.login)
          user.auth_user = logged_user
          user
        else
          nil
        end
      end

      def login_url(return_url=nil)
        AuthLh.login_url(return_url)
      end

      def logout_url(return_url=nil)
        AuthLh.logout_url(return_url)
      end

      def change_password_url(return_url=nil)
        AuthLh.change_password_url(return_url)
      end

      def my_apps_url
        AuthLh.my_apps_url
      end
    end
  end
end

