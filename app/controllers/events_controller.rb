class EventsController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate_as_support, only: [:create, :update, :destroy]
  before_action :authenticate_as_admin, only: [:index]
  before_action :authenticate, only: [:my, :show]
  before_action :set_event, only: %i[ show update destroy ]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events_my
  # GET /events_my.json
  def my
    @events = @current_user.events.order(:date).includes(:notes)
    # render template: '/index.json.jbuilder'
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # POST /events
  # POST /events.json
  def create
    @event = @current_user.events.build(event_params)
    if @event.save
      render :show, status: :created, location: @event
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if @event.update(event_params)
      render :show, status: :ok, location: @event
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy!

    render json: {message: "Event has been deleted"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
      render_forbidden_if_not_users_object @event
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :date)
    end
end
