class NamesController < ApplicationController
  before_action :authenticate_as_organizer
  before_action :set_name, only: %i[ destroy ]

  def index
    @names = @current_user.organizer.addition_attribiute_names
  end

  def create
    @name = @current_user.organizer.addition_attribiute_names.build(addition_attribiute_name_params)
    if @name.save
      render :show, status: :created, location: name_url(@name)
    else
      render json: @name.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @name.destroy!
    render json: {message: "Addition Attribiute name has been deleted"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_name
      @name = @current_user.organizer.addition_attribiute_names.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def addition_attribiute_name_params
      params.require(:addition_attribiute_name).permit(:name, :default_value)
    end
end
