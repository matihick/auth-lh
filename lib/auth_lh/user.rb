module AuthLh
  class User
    attr_accessor :code, :email, :jabber, :name, :login, :shop_code,
      :is_admin, :allow_remote_access, :last_activity

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end
