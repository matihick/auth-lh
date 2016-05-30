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

    def has_role?(r_code)
      role_codes.include?(r_code.to_s)
    end

    def has_some_role?(r_codes)
      r_codes.any? { |r_code|
        role_codes.include?(r_code.to_s)
      }
    end

    def has_all_roles?(r_codes)
      r_codes.all? { |r_code|
        role_codes.include?(r_code.to_s)
      }
    end

    module ClassMethods
      def all_external
        @cached_users ||= AuthLh.get_users({ pagination: 'false' })
      end

      def all_external_with_role(role_code)
        all_external.find_all { |x| x.has_role?(role_code) }
      end

      def all_external_with_some_role(role_codes)
        all_external.find_all { |x|
          role_codes.any? { |role_code| x.has_role?(role_code) }
        }
      end

      def find_external(login)
        all_external.find { |x| x.login == login.to_s }
      end

      def clear_cache!
        @cached_users = nil
      end

      def find_current_user(session_token, remote_ip, return_url=nil)
        response = AuthLh::Api.get_current_user(session_token, remote_ip, return_url)

        logged_user = response.user
        @destination_url = response.destination_url

        if logged_user
          user = find_or_create_by(login: logged_user.login)
          user.auth_user = logged_user
          user
        else
          nil
        end
      end

      def login_url(return_url=nil)
        if @destination_url.present?
          @destination_url
        else
          AuthLh::Api.login_url(return_url)
        end
      end

      def logout_url(return_url=nil)
        AuthLh::Api.logout_url(return_url)
      end

      def change_password_url(return_url=nil)
        AuthLh::Api.change_password_url(return_url)
      end

      def my_apps_url
        AuthLh::Api.my_apps_url
      end
    end
  end
end

