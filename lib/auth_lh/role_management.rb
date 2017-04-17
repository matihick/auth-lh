module AuthLh
  module RoleManagement
    def self.included(base)
      base.extend(ClassMethods)
    end

    def auth_role
      if @auth_role.nil?
        @auth_role = self.class.find_external(id)
      end

      @auth_role
    end

    def auth_role=(val)
      @auth_role = val
    end

    module ClassMethods
      def all_external
        @cached_roles ||= auth_api.get_roles
      end

      def find_external(id)
        all_external.find { |x| x.id == id.to_i }
      end

      def clear_cache!
        @cached_roles = nil
      end
    end
  end
end

