module AuthLh
  class Shop
    attr_accessor :id, :code, :name, :stock_description

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

