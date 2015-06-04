module AuthLh
  class ExternalApp
    attr_accessor :name, :description, :url, :is_local

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

