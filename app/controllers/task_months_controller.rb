class TaskMonthsController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate_as_organizer
  before_action :set_task_month, only: %i[ show destroy ]

  # Don't need for now
  # GET /task_months
  # GET /task_months.json
  # def index
  #   @task_months = TaskMonth.all
  # end

  # GET /task_months_my
  # GET /task_months_my.json
  def my
    @task_months = TaskMonth.all
  end

  # GET /task_months/1
  # GET /task_months/1.json
  def show
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
      render_forbidden_if_not_users_object @task_month.organizer
    end

    # Only allow a list of trusted parameters through.
    def task_month_params
      params.require(:task_month).permit(:month_number, :year)
    end
end
