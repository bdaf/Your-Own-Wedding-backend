class EventsController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate_as_support, only: [:create, :update, :destroy]
  before_action :authenticate_as_admin, only: [:index]
  before_action :authenticate, only: [:my_events, :show]
  before_action :set_event, only: %i[ show update destroy ]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/my
  # GET /events/my.json
  def my_events
    @events = @current_user.events.includes(:notes)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if @current_user.id != @event.user_id
      render json: { message: "It's not your event!", status: 403 }, status: 403
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = @current_user.events.create(event_params)

    if @event.save
      render :show, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if @current_user.id != @event.user_id
      render json: { message: "It's not your event!", status: 403 }, status: 403
    end
    if @event.update(event_params)
      render :show, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
      if @current_user.id != @event.user_id
        render json: { message: "It's not your event!", status: 403 }, status: 403
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:user_id, :name, :date)
    end
end
