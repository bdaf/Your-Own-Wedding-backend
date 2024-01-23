class RegistrationsController < ApplicationController
    include CurrentUserConcern
    before_action :authenticate, only: [:profile]

    def create
        user = User.create(
            email: params['user']['email'],
            name: params['user']['name'],
            surname: params['user']['surname'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation'],
            role: params['user']['role'],
        )
        role_model = create_role_model user, params
        user.set_role_model(role_model)
        if user.valid? && role_model.valid?
            user.save!
            create_task_months user if user.role_organizer?
            create_main_event_with_example_note user
            session[:user_id] = user.id
            render json: {
                status: :created,
                user: user
            }
        else
            render json: user.errors.full_messages + role_model.errors.full_messages, status: :unprocessable_entity
        end
    end

    def profile
        user = @current_user
        user.name = params['user']['name']
        user.surname = params['user']['surname']
        role_model = update_role_model(user, params)
        if user.valid? && role_model.valid?
            user.save!
            role_model.save!
            render json: {
                status: :updated,
                user: user
            }
        else
            render json: user.errors.full_messages + role_model.errors.full_messages, status: :unprocessable_entity
        end
    end

    def update_role_model user, params
        if user.role_organizer? 
            user.organizer.celebration_date = params.dig('user','organizer','celebration_date') if user.role_organizer? && params.dig('user','organizer','celebration_date')
            user.organizer
        elsif user.role_provider?
            user.provider.address = params.dig('user','provider','address') if user.role_provider? && params.dig('user','provider','address')
            user.provider.phone_number = params.dig('user','provider','phone_number') if user.role_provider? && params.dig('user','provider','phone_number')
            user.provider
        end
    end

    def create_role_model user, params
        if user.role_organizer? 
            organizer = Organizer.new(celebration_date: params['user']['celebration_date'])
        elsif user.role_provider?
            provider = Provider.new(address: params['user']['address'], phone_number: params['user']['phone_number'])
        end
    end

    def create_task_months user
        iteration_month_task = TaskMonth.create!(organizer_id: user.organizer.id, month_number: Time.now.month , year: Time.now.year)
        while iteration_month_task.month_number != user.organizer.celebration_date.month || iteration_month_task.year != user.organizer.celebration_date.year do
            iteration_month_task = TaskMonth.create!(iteration_month_task.next_month_params)
        end
    end

    def create_main_event_with_example_note user
        user.events.create(date: Time.now + 1.minute, name: "Created account - space for flexible notes")
        user.events.first.notes.create(name: "Example of note", body: "You can create notes like this one.")
    end
end