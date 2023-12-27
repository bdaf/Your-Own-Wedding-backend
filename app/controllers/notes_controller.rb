class NotesController < ApplicationController
  before_action :set_note, only: %i[ show update destroy ]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # POST /notes
  # POST /notes.json
  def create
    @event = Event.find(params[:event_id])
    @note = @event.notes.create(note_params)

    if @note.valid?
      render :show, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update(note_params)
      render :show, status: :ok, location: @note
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
      @event = Event.find(params[:event_id])
      @note = @event.notes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:event_id, :name, :body)
    end
end
