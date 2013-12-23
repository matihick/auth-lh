module AuthLh
  class LoginAttempt
    attr_accessor :token

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end
