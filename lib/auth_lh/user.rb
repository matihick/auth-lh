module AuthLh
  class User
    attr_accessor :code, :email, :jabber, :name, :login,
      :shop_code, :enabled, :role_codes

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

