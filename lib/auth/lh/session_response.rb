module Auth
  module Lh
    class SessionResponse
      attr_accessor :user, :success, :reason, :login_url

      def initialize(attributes={})
        attributes.each do |k,v|
          if k.to_s == 'user'
            self.user = Auth::User.new(v) if v.present?
          else
            self.send("#{k}=", v)
          end
        end
      end
    end
  end
end
