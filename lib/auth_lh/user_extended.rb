module AuthLh
  class UserExtended
    attr_accessor :email, :jabber, :login, :password_digest, :password_expired,
      :enabled, :shop_code, :shop_id, :allow_remote_access, :session_timeout, :only_working_time,
      :allow_multiple_sessions, :working_time, :has_remote_desktop, :fingerprint_from,
      :fingerprint_to, :first_name, :last_name, :attendance_mode, :testing_user, :disable_time,
      :password_remember_enabled, :external_apps, :roles

    def initialize(attributes={})
      attributes.each do |k,v|
        if k.to_s == 'external_apps'
          self.external_apps = v.map { |x| ExternalAppExtended.new(x) }
        elsif k.to_s == 'roles'
          self.roles = v.map { |x| Role.new(x) }
        else
          self.send("#{k}=", v)
        end
      end
    end

    def name
      "#{first_name} #{last_name}"
    end

    def role_ids
      roles.map(&:id)
    end

    def app_codes
      external_apps.map(&:code)
    end

    def has_role?(role_id)
      role_ids.include?(role_id.to_i)
    end

    def has_some_role?(r_ids)
      r_ids.any? { |r_id|
        role_ids.include?(r_id.to_i)
      }
    end

    def has_all_roles?(r_ids)
      r_ids.all? { |r_id|
        role_ids.include?(r_id.to_i)
      }
    end
  end
end

