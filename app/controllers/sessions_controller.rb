require 'date'
class SessionsController < ApplicationController
    def create
        user = User
        .find_by(email: params["user"]["email"])
        .try(:authenticate, params["user"]["password"])

        if user
            session[:user_id] = user.id
            user.hide_password
            render json: {
                status: :created,
                logged_in: true,
                user: user
            }
        else
            render json: ["Email or password is incorrect"], status: :unprocessable_entity
        end
    end

    def logged_in
        if @current_user
            @current_user.hide_password
            render json: {
                logged_in: true,
                user: @current_user.as_json(include: @current_user.role)
            }
        else
            render json: {
                logged_in: false
            }
        end
    end
    
    def logout
        reset_session
        render json: {status: 200, logged_out: true }
    end

    def home_page_user_data
        if @current_user
            @current_user.hide_password
            render json: {
                user: @current_user,
                addition_data: @current_user.addition_data_based_on_role
            }
        end
    end
end