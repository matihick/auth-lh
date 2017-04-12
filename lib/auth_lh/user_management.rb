module AuthLh
  module UserManagement
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

    def allowed_local_shop_codes(current_shop_code=nil)
      (@auth_user.local_app_shop_codes + [current_shop_code]).compact.uniq
    end

    module ClassMethods
      def all_external
        @cached_users ||= auth_api.get_users({ pagination: 'false' })
      end

      def all_external_with_role(role_id)
        all_external.find_all { |x| x.has_role?(role_id) }
      end

      def all_external_with_some_role(role_ids)
        all_external.find_all { |x|
          role_ids.any? { |role_id| x.has_some_role?(role_id) }
        }
      end

      def all_external_with_all_roles(role_ids)
        all_external.find_all { |x|
          role_ids.any? { |role_id| x.has_all_roles?(role_id) }
        }
      end

      def find_external(login)
        all_external.find { |x| x.login == login.to_s }
      end

      def find_external_with_role(role_id)
        all_external_with_role(role_id).first
      end

      def find_external_with_some_role(role_ids)
        all_external_with_some_role(role_ids).first
      end

      def find_external_with_all_roles(role_ids)
        all_external_with_all_roles(role_ids).first
      end

      def with_role(role_id)
        all.to_a.find_all { |x| x.has_role?(role_id) }
      end

      def with_some_role(role_ids)
        all.to_a.find_all { |x| x.has_some_role?(role_ids) }
      end

      def with_all_roles(role_ids)
        all.to_a.find_all { |x| x.has_all_roles?(role_ids) }
      end

      def clear_cache!
        @cached_users = nil
      end
    end
  end
end

