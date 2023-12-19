class AdditionAttribiutesController < ApplicationController
  before_action :set_addition_attribiute, only: %i[ show update destroy ]

  # GET /addition_attribiutes
  # GET /addition_attribiutes.json
  def index
    @addition_attribiutes = AdditionAttribiute.all
  end

  # GET /addition_attribiutes/1
  # GET /addition_attribiutes/1.json
  def show
  end

  # POST /addition_attribiutes
  # POST /addition_attribiutes.json
  def create
    @addition_attribiute = AdditionAttribiute.new(addition_attribiute_params)

    if @addition_attribiute.save
      render :show, status: :created, location: @addition_attribiute
    else
      render json: @addition_attribiute.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /addition_attribiutes/1
  # PATCH/PUT /addition_attribiutes/1.json
  def update
    if @addition_attribiute.update(addition_attribiute_params)
      render :show, status: :ok, location: @addition_attribiute
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
      @addition_attribiute = AdditionAttribiute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def addition_attribiute_params
      params.require(:addition_attribiute).permit(:guest_id, :name, :value)
    end
end
