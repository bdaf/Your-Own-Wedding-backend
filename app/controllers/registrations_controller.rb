class RegistrationsController < ApplicationController
    def create
        role = params['user']['role'] == "support" ? "support" : "client"
        user = User.create(
            email: params['user']['email'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation'],
            celebration_date: params['user']['celebration_date'],
            role: role
        )
        create_task_months user if user.role_client?
        if user
            session[:user_id] = user.id
            render json: {
                status: :created,
                user: user
            }
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    def create_task_months user
        iteration_month_task = TaskMonth.create!(user_id: user.id, month_number: Time.now.month , year: Time.now.year)
        while iteration_month_task.month_number != user.celebration_date.month || iteration_month_task.year != user.celebration_date.year do
            iteration_month_task = TaskMonth.create!(iteration_month_task.next_month_params)
        end
    end
end