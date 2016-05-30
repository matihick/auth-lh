module AuthLh
  class User
    attr_accessor :email, :jabber, :name, :login, :shop_code,
    :shop_id, :shop_name, :enabled, :role_codes, :password_expired,
    :has_attendance_control, :has_remote_desktop, :fingerprint_from,
    :fingerprint_to, :external_apps

    def initialize(attributes={})
      attributes.each do |k,v|
        if k.to_s == 'external_apps'
          self.external_apps = v.map { |x| ExternalApp.new(x) }
        else
          self.send("#{k}=", v)
        end
      end
    end

    def has_role?(role_code)
      role_codes.include?(role_code.to_s)
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
  end
end

