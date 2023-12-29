class RegistrationsController < ApplicationController
    def create
        role = "support" if params['user']['support']

        user = User.create!(
            email: params['user']['email'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation'],
            role: params['user']['support']
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