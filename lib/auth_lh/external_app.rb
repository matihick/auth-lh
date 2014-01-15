module AuthLh
  class ExternalApp
    attr_accessor :code, :name, :description, :url

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

