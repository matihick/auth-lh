module AuthLh
  class Role
    attr_accessor :code, :name, :required_level, :position, :unique_by_shop, :required_shop_code

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end
