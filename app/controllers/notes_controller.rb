class NotesController < ApplicationController
  include CurrentUserConcern
  # before_action :authenticate_as_admin, only: [:index]
  before_action :authenticate
  before_action :set_event_and_check_if_yours
  before_action :set_note, only: %i[ show update destroy ]

  # Don't need that for now
  # # GET /notes
  # # GET /notes.json
  # def index
  #   @notes = Event.find(params[:event_id]).notes
  # end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = @event.notes.build(note_params)

    if @note.save
      render :show, status: :created, location: event_note_url(@event, @note)
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update(note_params)
      render :show, status: :ok, location: event_note_url(@event, @note)
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = @event.notes.find(params[:id])
    end

    def set_event_and_check_if_yours
      @event = Event.find(params[:event_id])
      render_forbidden_if_not_users_object @event
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:name, :body)
    end
end
