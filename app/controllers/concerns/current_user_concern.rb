module CurrentUserConcern
    extend ActiveSupport::Concern

    included do 
        before_action :set_current_user
    end

    set_current_user do
        if session[:user_id]
            @current_user = User.find(session[:user_id])
        end
    end
end