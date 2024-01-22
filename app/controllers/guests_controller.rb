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
      render :show, status: :created, location: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    if @guest.update(guest_params)
      render :show, status: :ok, location: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
      render_forbidden_if_not_users_object @guest.organizer
    end

    # Only allow a list of trusted parameters through.
    def guest_params
      params.require(:guest).permit(:name, :surname, :phone_number)
    end
end
