module AuthLh
  class ExternalApp
    attr_accessor :code, :name, :description, :url, :notify_user_changed, :is_local

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

