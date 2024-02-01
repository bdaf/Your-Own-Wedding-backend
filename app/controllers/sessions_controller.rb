require 'date'
class SessionsController < ApplicationController
    before_action :authenticate, only: [:home_page_user_data]
    def create
        user = User
        .find_by(email: params["user"]["email"])
        .try(:authenticate, params["user"]["password"])

        if user
            session[:user_id] = user.id
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
        render json: {
            user: @current_user,
            addition_data: @current_user.addition_data_based_on_role
        }
    end
end