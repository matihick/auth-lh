module AuthLh
  class User
    attr_accessor :code, :email, :jabber, :name, :login, :shop_code,
      :shop_id, :shop_name, :enabled, :role_codes, :password_expired,
      :dni, :has_attendance_control, :external_apps

    def initialize(attributes={})
      attributes.each do |k,v|
        if k.to_s == 'external_apps'
          self.external_apps = v.map { |x| ExternalApp.new(x) }
        else
          self.send("#{k}=", v)
        end
      end
    end

    def password_expired?
      password_expired == true
    end

    def has_role?(role_code)
      role_codes.include?(role_code.to_s)
    end
  end
end

