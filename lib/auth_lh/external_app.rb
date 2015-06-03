module AuthLh
  class ExternalApp
    attr_accessor :code, :name, :description, :url, :send_notifications,
      :is_local, :notifications_url

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

