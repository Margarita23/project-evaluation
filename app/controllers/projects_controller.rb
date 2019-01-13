class ProjectsController < ApplicationController
  load_and_authorize_resource

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    @projects = Project.all
  end

  def create
    @project = Project.new(name: "Новый проект", user_id: current_user.id)
    if @project.save
      flash[:notice] = "Новый проект успешно создан."
    else
      flash[:alert] = "Проект не создан. Имя должно быть уникальным. Исправьте проект с именем 'Новый проект'"
    end
    redirect_to projects_path, method: :get
  end

  def update
    if @project.update(update_params)
     flash[:notice] = "Имя проекта успешно изменено."
    else
      flash[:alert] = "Имя проекта не изменено. Имя должно быть уникальным." 
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Проект успешно удален." }
      format.json { head :no_content }
    end
  end
  
  def handle_record_not_found
    render :not_found_project
  end

  private 

  def set_project
    @project = Project.find(params[:id])
  end

  def update_params
    params.require(:project).permit(:name, :user_id)
  end
end
