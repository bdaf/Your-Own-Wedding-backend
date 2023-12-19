class TaskMonthsController < ApplicationController
  before_action :set_task_month, only: %i[ show update destroy ]

  # GET /task_months
  # GET /task_months.json
  def index
    @task_months = TaskMonth.all
  end

  # GET /task_months/1
  # GET /task_months/1.json
  def show
  end

  # POST /task_months
  # POST /task_months.json
  def create
    @task_month = TaskMonth.new(task_month_params)

    if @task_month.save
      render :show, status: :created, location: @task_month
    else
      render json: @task_month.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /task_months/1
  # PATCH/PUT /task_months/1.json
  def update
    if @task_month.update(task_month_params)
      render :show, status: :ok, location: @task_month
    else
      render json: @task_month.errors, status: :unprocessable_entity
    end
  end

  # DELETE /task_months/1
  # DELETE /task_months/1.json
  def destroy
    @task_month.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_month
      @task_month = TaskMonth.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_month_params
      params.require(:task_month).permit(:user_id, :month_number, :year)
    end
end
