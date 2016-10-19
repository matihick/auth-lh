module AuthLh
  class Shop
    attr_accessor :id, :code, :name, :enabled, :stock_description

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v) if self.respond_to?(k)
      end
    end
  end
end

