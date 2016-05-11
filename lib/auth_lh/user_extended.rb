module AuthLh
  class UserExtended
    attr_accessor :email, :jabber, :name, :login, :password_digest,
      :password_expired, :enabled, :shop_code, :allow_remote_access,
      :session_timeout, :only_working_time, :dni, :allow_multiple_sessions,
      :working_time, :has_attendance_control, :has_remote_desktop,
      :fingerprint_from, :fingerprint_to

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end

