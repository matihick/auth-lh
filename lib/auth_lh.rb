module AuthLh
  def self.configure(args={})
    @endpoint = (args[:endpoint] || 'https://auth.lhconfort.com.ar')
    @return_url = args[:return_url]
    @application_code = args[:application_code]
    @access_token = args[:access_token]
  end

  def self.logged_user(session_token, remote_ip)
    result = get_request '/logged_user', {
      app_code: @application_code,
      session_token: session_token,
      remote_ip: remote_ip
    }

    SessionResponse.new(result)
  end

  def self.login_url
    login_attempt = create_login_attempt
    "#{@endpoint}/login?attempt=#{login_attempt.token}"
  end

  def self.logout_url
    "#{@endpoint}/logout?return=#{CGI::escape(@return_url)}"
  end

  def self.get_user(code_or_login)
    User.new(get_request("/api/users/#{code_or_login}"))
  end

  def self.get_users(filters={})
    results = get_request("/api/users", filters)
    results.map { |r| User.new(r) }
  end

  def self.get_all_users
    results = get_request("/api/users/all")
    results.map { |r| User.new(r) }
  end

  protected

  def self.create_login_attempt
    params = { app_code: @application_code }

    if @return_url
      params[:return_url] = @return_url
    end

    LoginAttempt.new(post_request('/login_attempts', params))
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
