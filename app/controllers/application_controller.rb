class ApplicationController < ActionController::Base
    include CurrentUserConcern
    skip_before_action :verify_authenticity_token

    def get_current_user 
        User.find(session[:user_id]) if session[:user_id]
    end
end
