module AuthLh
  class User
    attr_accessor :code, :email, :jabber, :name, :login, :password_digest,
      :password_expired, :enabled, :is_admin, :shop_code, :allow_remote_access,
      :last_activity, :app_codes

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

