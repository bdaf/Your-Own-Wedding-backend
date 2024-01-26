class EventsController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate, only: [:create, :update, :destroy]
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
    @events.each do |event|
      check_and_mark_notes_as_overdue(event)
    end
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
      check_and_mark_notes_as_overdue(@event)
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
    
    def check_and_mark_notes_as_overdue event
      if event.date < Time.now
        event.notes.each do |note|
          if !note.status_done?
            note.update!(status: "overdue")
          end
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :date)
    end
end
