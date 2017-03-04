module AuthLh
  class User
    attr_accessor :email, :jabber, :first_name, :last_name, :login,
    :shop_code, :shop_id, :shop_name, :enabled, :password_expired,
    :has_remote_desktop, :attendance_mode, :fingerprint_from,
    :fingerprint_to, :attendance_mode, :external_apps, :roles

    def initialize(attributes={})
      attributes.each do |k,v|
        if k.to_s == 'external_apps'
          self.external_apps = v.map { |x| ExternalApp.new(x) }
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

