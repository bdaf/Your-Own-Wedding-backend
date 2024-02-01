class AdditionAttribiutesController < ApplicationController
  before_action :authenticate_as_organizer
  before_action :set_guest_and_check_if_yours
  before_action :set_addition_attribiute, only: %i[ show destroy ]

  # GET /addition_attribiutes/1
  # GET /addition_attribiutes/1.json
  def show
  end

  # POST /addition_attribiutes
  # POST /addition_attribiutes.json
  def create
    @addition_attribiute = @guest.addition_attribiutes.build(addition_attribiute_params)

    if @addition_attribiute.save
      render :show, status: :created, location: guest_addition_attribiute_url(@guest, @addition_attribiute)
    else
      render json: @addition_attribiute.errors, status: :unprocessable_entity
    end
  end

  # DELETE /addition_attribiutes/1
  # DELETE /addition_attribiutes/1.json
  def destroy
    @addition_attribiute.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_addition_attribiute
      @addition_attribiute = @guest.addition_attribiutes.find(params[:id])
    end

    def set_guest_and_check_if_yours
      @guest = Guest.find(params[:guest_id])
      render_forbidden_if_not_users_object @guest.organizer
    end

    # Only allow a list of trusted parameters through.
    def addition_attribiute_params
      params.require(:addition_attribiute).permit(:value, :addition_attribiute_name_id)
    end
end
