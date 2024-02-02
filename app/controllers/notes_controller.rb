class NotesController < ApplicationController
  before_action :authenticate
  before_action :set_event_and_check_if_yours
  before_action :set_note, only: %i[ show update destroy ]

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = @event.notes.build(note_params)
    @note.check_and_mark_note_as_overdue

    if @note.save
      render :show, status: :created, location: event_note_url(@event, @note)
    else
      render json: @note.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update(note_params)
      @note.check_and_mark_note_as_overdue
      render :show, status: :ok, location: event_note_url(@event, @note)
    else
      render json: @note.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy!

    render json: {message: "Note has been deleted"}
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
      params.require(:note).permit(:name, :body, :status)
    end
end
