module AuthLh
  module AuthManagement
    def set_current_user
      session_response = @auth_api.get_current_user(cookies[:session_token], request.remote_ip, request.original_url)

      if session_response.user
        @current_user = ::User.find_or_create_by(login: session_response.user.login)
        @current_user.auth_user = session_response.user
      end

      if session_response.destination_url.present?
        redirect_to session_response.destination_url
      end
    end

    def current_user
      @current_user
    end

    def set_current_shop
      @current_shop = @auth_api.get_current_shop(request.remote_ip)
    end

    def current_shop
      @current_shop
    end

    def check_access_grants
      if current_user
        if !current_user.can_access?(params[:controller], params[:action])
          if request.xhr?
            render status: :forbidden
          else
            render file: 'public/403.html', layout: false
          end
        end
      end
    end

    def logout_url
      @auth_api.logout_url(request.protocol + request.host_with_port)
    end

    def change_password_url
      @auth_api.change_password_url(request.original_url)
    end
  end
end
