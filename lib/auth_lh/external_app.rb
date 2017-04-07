module AuthLh
  class ExternalApp
    attr_accessor :name, :description, :url, :is_local

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end

    def local_name(current_shop_code)
      name % { shop_code: current_shop_code }
    end

    def local_url(current_shop_code)
      url % { shop_code: current_shop_code }
    end
  end
end

