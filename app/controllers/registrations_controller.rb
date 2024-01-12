class RegistrationsController < ApplicationController
    def create
        # role = params['user']['role']
        # unless User::APPROVED_ROLES_DURING_REGISTRATION.include?(role)
        #     render json: { role: "is not permit to be another than #{User::APPROVED_ROLES_DURING_REGISTRATION.to_s.gsub(Regexp.union({',' => 'or'}.keys), {',' => 'or'})}" }, status: :unprocessable_entity 
        #     return;
        # end
        user = User.create(
            email: params['user']['email'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation'],
            celebration_date: params['user']['celebration_date'],
            role: params['user']['role']
        )

        if user.valid?
            create_task_months user if user.role_client?
            create_main_event_with_example_note user
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

    def create_main_event_with_example_note user
        user.events.create(date: Time.now + 1.minute, name: "Created account - space for flexible notes")
        user.events.first.notes.create(name: "Example of note", body: "You can create notes like this one.")
    end
end