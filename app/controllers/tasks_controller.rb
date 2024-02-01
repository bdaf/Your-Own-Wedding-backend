class TasksController < ApplicationController
  before_action :authenticate_as_organizer
  before_action :set_task_month_and_check_if_yours
  before_action :set_task, only: %i[ show update destroy ]

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @task_month.tasks.build(task_params)

    if @task.save
      render :show, status: :created, location: task_month_task_url(@task_month, @task)
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      render :show, status: :ok, location: task_month_task_url(@task_month, @task)
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    
    @task.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = @task_month.tasks.find(params[:id])
    end

    def set_task_month_and_check_if_yours
      @task_month = TaskMonth.find(params[:task_month_id])
      render_forbidden_if_not_users_object @task_month.organizer
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:task_month_id, :name, :description)
    end
end
