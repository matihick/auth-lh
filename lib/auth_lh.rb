module AuthLh
  def self.configure(args={})
    @endpoint = (args[:endpoint] || 'https://auth.lhconfort.com.ar')
    @return_url = args[:return_url]
    @application_code = args[:application_code]
    @access_token = args[:access_token]
  end

  def self.get_user(code_or_login)
    User.new(get_request("/api/users/#{code_or_login}"))
  end

  def self.get_users(filters={})
    results = get_request('/api/users', filters)
    results.map { |r| User.new(r) }
  end

  def self.get_users_extended
    results = get_request('/api/users/extended')
    results.map { |r| UserExtended.new(r) }
  end

  def self.get_current_user(session_token, remote_ip)
    result = get_request '/api/current_user', {
      app_code: @application_code,
      session_token: session_token,
      remote_ip: remote_ip
    }

    SessionResponse.new(result)
  end

  def self.get_external_apps
    results = get_request('/api/external_apps')
    results.map { |r| ExternalApp.new(r) }
  end

  def self.get_roles
    results = get_request('/api/roles')
    results.map { |r| Role.new(r) }
  end

  def self.get_role(code)
    Role.new(get_request("/api/roles/#{code}"))
  end

  def self.login_url
    login_attempt = create_login_attempt
    "#{@endpoint}/login?attempt=#{login_attempt.token}"
  end

  def self.logout_url
    "#{@endpoint}/logout?return_url=#{CGI::escape(@return_url)}"
  end

  def self.change_password_url
    "#{@endpoint}/change_password?return_url=#{CGI::escape(@return_url)}"
  end

  def self.whatsmyshop(ip_address=nil)
    attrs = { ip: ip_address }
    get_request('/api/whatsmyshop', attrs)['shop_codes']
  end

  protected

  def self.create_login_attempt
    LoginAttempt.new(post_request('/api/login_attempts', {
      return_url: @return_url
    }))
  end

  def self.get_request(action, params={})
    response = RestClient.get("#{@endpoint}#{action}", {params: params}.merge(auth_headers))
    JSON.parse(response.body)
  end

  def self.post_request(action, params={})
    JSON.parse(RestClient.post("#{@endpoint}#{action}", params, auth_headers))
  end

  def self.auth_headers
    { authorization: "Token token=\"#{@access_token}\"" }
  end
end
