class RegistrationsController < ApplicationController
    def create
        role = "user" unless params['user']['support']

        user = User.create!(
            email: params['user']['email'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation'],
            role: role
        )

        if user
            session[:user_id] = user.id
            render json: {
                status: :created,
                user: user
            }
        else
            render json: { status: 500 }
        end
    end
end