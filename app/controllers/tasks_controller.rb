class TasksController < ApplicationController
	before_action :set_task, only: [:show, :edit, :update, :destroy]
	before_action :require_user_logged_in, only: [:new, :create]
	
	def index
		if logged_in?
			@tasks = current_user.tasks.page(params[:page]).per(3)
		end
	end

	def show 
		set_task
	end
	def new
		@task = Task.new
	end
	def create
		@task = current_user.tasks.build(task_params)
		if @task.save
			flash[:success] = 'タスクが正常に追加されました'
			redirect_to @task
		else
			flash.now[:danger] = 'タスクが追加されませんでした'
			render :new
		end
	end
	def edit
		set_task
	end
	def update
		set_task
		if @task.update(task_params)
			flash[:success] = 'タスクが更新されました'
			redirect_to @task
		else
			flash.now[:danger] = 'タスクが更新されませんでした'
			render :edit
		end
	end
	def destroy
		set_task
		@task.destroy
		flash[:success] = 'タスクが削除されました'
		redirect_to tasks_url
	end

	private
	
	def set_task
		@task = Task.find(params[:id])
		redirect_to root_url if @task.user != current_user
	end

	def task_params
		params.require(:task).permit(:content, :status)
	end
end