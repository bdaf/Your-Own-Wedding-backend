module CurrentUserConcern
    extend ActiveSupport::Concern

    included do 
        before_action :set_current_user

        def authenticate role = "client"
            if(!@current_user || !User.roles.include?(role))
                render_unauthenticated
            elsif(@current_user.role != role)
                render_forbidden 
            end
        end
    end

    def set_current_user
        if session[:user_id]
            @current_user = User.find(session[:user_id])
        end
    end
      
    def render_unauthenticated
        render json: {
            status: 401, 
            message: "User is not logged in or his role is not in the system." 
        }, status: 401
    end

    def render_forbidden
        render json: {
            status: 403, 
            message: "User doesn't have access to that action." 
        }, status: 403
    end
end