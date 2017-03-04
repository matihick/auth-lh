module AuthLh
  class ExternalAppExtended
    attr_accessor :code, :name, :description, :url, :is_local

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

