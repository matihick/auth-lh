module AuthLh
  def self.configure(args={})
    @endpoint = (args[:endpoint] || 'https://usuarios.lhconfort.com.ar')
    @application_code = args[:application_code]
    @access_token = args[:access_token]
  end

  def self.get_user(code_or_login)
    User.new(get_request("/api/users/#{code_or_login}"))
  end

  def self.update_user(code_or_login, attrs={})
    User.new(put_request("/api/users/#{code_or_login}", attrs))
  end

  def self.get_users(filters={})
    results = get_request('/api/users', filters)
    results.map { |r| User.new(r) }
  end

  def self.get_users_extended(filters={})
    results = get_request('/api/users/extended', filters)
    results.map { |r| UserExtended.new(r) }
  end

  def self.get_external_apps
    results = get_request('/api/external_apps')
    results.map { |r| ExternalAppExtended.new(r) }
  end

  def self.get_roles
    results = get_request('/api/roles')
    results.map { |r| Role.new(r) }
  end

  def self.get_role(code)
    Role.new(get_request("/api/roles/#{code}"))
  end

  def self.get_current_user(session_token, remote_ip, return_url=nil)
    result = get_request '/api/current_user', {
      app_code: @application_code,
      session_token: session_token,
      remote_ip: remote_ip,
      return_url: return_url
    }

    SessionResponse.new(result)
  end

  def self.get_current_shop(ip_address=nil)
    attrs = { ip: ip_address }
    response = get_request('/api/current_shop', attrs)
    response.nil? ? nil : Shop.new(response)
  end

  def self.login_url(return_url=nil)
    if return_url.present?
      "#{@endpoint}/login?return_url=#{CGI::escape(return_url)}"
    else
      "#{@endpoint}/login"
    end
  end

  def self.logout_url(return_url=nil)
    if return_url.present?
      "#{@endpoint}/logout?return_url=#{CGI::escape(return_url)}"
    else
      "#{@endpoint}/logout"
    end
  end

  def self.change_password_url(return_url=nil)
    if return_url.present?
      "#{@endpoint}/change_password?return_url=#{CGI::escape(return_url)}"
    else
      "#{@endpoint}/change_password"
    end
  end

  def self.my_apps_url
    "#{@endpoint}"
  end

  protected

  def self.get_request(action, params={})
    response = RestClient.get("#{@endpoint}#{action}", {params: params}.merge(auth_headers))

    if response.body == 'null'
      nil
    else
      JSON.parse(response.body)
    end
  end

  def put_request(action, params={}, headers={})
    response = RestClient.put("#{@endpoint_url}#{action}", params, headers.merge(auth_headers))

    if response.body == 'null'
      nil
    else
      JSON.parse(response.body)
    end
  end

  def self.auth_headers
    { authorization: "Token token=\"#{@access_token}\"" }
  end
end
