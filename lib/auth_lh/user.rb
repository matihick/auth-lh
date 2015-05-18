module AuthLh
  class User
    attr_accessor :code, :email, :jabber, :name, :login, :shop_code,
      :shop_id, :enabled, :role_codes, :password_expired, :birthdate, :dni,
      :has_attendance_control

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
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

