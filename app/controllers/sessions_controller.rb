require 'date'
class SessionsController < ApplicationController
    include CurrentUserConcern
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
            render json: { "Email or password": " incorrect" }, status: :unprocessable_entity
        end
    end

    def logged_in
        if @current_user
            if @current_user.role_organizer? 
                days_to_ceremony = (@current_user.organizer.celebration_date - Time.now).to_i / 3600 / 24
                days_to_ceremony = 0 if days_to_ceremony < 0
            end
            render json: {
                logged_in: true,
                user: @current_user.as_json(include: @current_user.role),
                days_to_ceremony: days_to_ceremony ? days_to_ceremony : 0
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
end