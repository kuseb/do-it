class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :require_permission, except: [ :create]

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if List.is_user_can_modify? @task.list, current_user
        if @task.save
        broadcast(@task.list, 'create')
        format.json { render :json => {}, status: :created }
        else
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      else
        format.json { render :json => {}, status: :unauthorized }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        broadcast(@task.list, 'update')
        format.json { render :json => {}, status: :ok }
      else
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    broadcast(@task.list, 'delete')
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:list_id, :content, :importance, :is_done, :deadline);
  end

  def broadcast(list, method)
    ListChannel.broadcast_to(list, task: @task, method: method)
  end

  def require_permission
     if current_user.id != @task.list.user_id
       redirect_to new_user_registration_url, notice: "Log in to edit task"
     end
  end
end
