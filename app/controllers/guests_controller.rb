class GuestsController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate_as_organizer, only: [:my, :show, :create, :update, :destroy]
  before_action :authenticate_as_admin, only: [:index]
  before_action :set_guest, only: %i[ show update destroy ]
  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all
  end

  # GET /guests_my
  # GET /guests_my.json
  def my
    @guests = @current_user.organizer.guests.includes(:addition_attribiutes)
    # render template: '/index.json.jbuilder'
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = @current_user.organizer.guests.build(guest_params)

    if @guest.save
      addition_attribiutes = params.dig(:guest, :addition_attribiutes)
      names = @current_user.organizer.addition_attribiute_names
      if names
        names.each do |name|
          attr = addition_attribiutes.find {|a| a[:addition_attribiute_name_id] == name.id}
          @guest.addition_attribiutes.create(addition_attribiute_name_id: name.id, value: attr[:value]) if attr
        end
      end
      render :show, status: :created, location: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    if @guest.update(guest_params)
      addition_attribiutes = params.dig(:guest, :addition_attribiutes)
      names = @current_user.organizer.addition_attribiute_names
      if names
        debugger
        names.each do |name|
          attr = addition_attribiutes.find {|a| a[:addition_attribiute_name_id] == name.id}
          attr_in_guest = @guest.addition_attribiutes.find(attr[:id]) if attr
          attr_in_guest.update(value: attr[:value]) if attr_in_guest
        end
      end
      render :show, status: :ok, location: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy!
    render json: {message: "Guest has been deleted"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
      render_forbidden_if_not_users_object @guest.organizer
    end

    # Only allow a list of trusted parameters through.
    def guest_params
      params.require(:guest).permit(:name, :surname, :phone_number, addition_attribiutes: [])
    end
end
