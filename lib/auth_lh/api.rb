module AuthLh
  class Api
    def initialize(args={})
      @endpoint = (args[:endpoint] || 'https://usuarios.lhconfort.com.ar')
      @application_code = args[:application_code]
      @access_token = args[:access_token]
    end

    def get_user(login)
      User.new(get_request("/api/users/#{CGI::escape(login)}"))
    end

    def update_user(login, attrs={})
      User.new(put_request("/api/users/#{CGI::escape(login)}", attrs))
    end

    def get_users(filters={})
      results = get_request('/api/users', filters)
      results.map { |r| User.new(r) }
    end

    def get_users_extended(filters={})
      results = get_request('/api/users/extended', filters)
      results.map { |r| UserExtended.new(r) }
    end

    def get_external_apps
      results = get_request('/api/external_apps')
      results.map { |r| ExternalAppExtended.new(r) }
    end

    def get_roles
      results = get_request('/api/roles')
      results.map { |r| Role.new(r) }
    end

    def get_role(role_id)
      Role.new(get_request("/api/roles/#{role_id}"))
    end

    def get_current_user(session_token, remote_ip, return_url=nil)
      result = get_request '/api/current_user', {
        app_code: @application_code,
        session_token: session_token,
        remote_ip: remote_ip,
        return_url: return_url
      }

      SessionResponse.new(result)
    end

    def get_current_shop(ip_address=nil)
      attrs = { ip: ip_address }
      response = get_request('/api/current_shop', attrs)
      response.nil? ? nil : Shop.new(response)
    end

    def login_url(return_url=nil)
      if return_url.present?
        "#{@endpoint}/login?return_url=#{CGI::escape(return_url)}"
      else
        "#{@endpoint}/login"
      end
    end

    def logout_url(return_url=nil)
      if return_url.present?
        "#{@endpoint}/logout?return_url=#{CGI::escape(return_url)}"
      else
        "#{@endpoint}/logout"
      end
    end

    def change_password_url(return_url=nil)
      if return_url.present?
        "#{@endpoint}/current_user/password/edit?return_url=#{CGI::escape(return_url)}"
      else
        "#{@endpoint}/current_user/password/edit"
      end
    end

    protected

    def get_request(action, params={})
      response = RestClient.get("#{@endpoint}#{action}", {params: params}.merge(auth_headers))

      if response.body == 'null'
        nil
      else
        JSON.parse(response.body)
      end
    end

    def put_request(action, params={})
      response = RestClient.put("#{@endpoint}#{action}", params, auth_headers)

      if response.body == 'null'
        nil
      else
        JSON.parse(response.body)
      end
    end

    def auth_headers
      { authorization: "Token token=\"#{@access_token}\"" }
    end
  end
end
