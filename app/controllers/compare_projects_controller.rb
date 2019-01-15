class CompareProjectsController < ApplicationController
  include Wicked::Wizard

  steps :assign_main, :compare_bocr, :compare_aspects,  :compare_projects, :get_global_ratings

  def show
    if params[:compare_project].present? && params[:compare_project][:project_ids].nil? && step == :assign_main
      flash[:alert] = "Выберити МИНИМУМ 2 проекта для сравнения."
      redirect_back(fallback_location: root_path) and return
    end
    
    @compare_projects = CompareProject.new(compare_projects_params)
    session[:last_step] = step
    
    case step
      when :compare_aspects
        @bocr_priorities = SetBocrPrioritiesService.new(@compare_projects).call
        @compare_projects.bocr_values.update(@bocr_priorities)
      when :compare_projects
        @aspects_priorities = SetAspectsPrioritiesService.new(params[:compare_project][:aspects_priorities]).call
        @compare_projects.aspects_priorities.update(@aspects_priorities)
      when :get_global_ratings
        @projects_priorities_and_global_result = SetProjectsPrioritiesService.new(params[:compare_project][:project_values], @compare_projects, @compare_projects.aspects_priorities, @compare_projects.bocr_values).call
    end
    if check_valid_aspects_method
      flash[:alert] = "Выберите минимум два проекта для сравнения с одинаковыми аспектами BOCR"
      redirect_back(fallback_location: root_path) and return
    end
  
    render compare_project_path(session[:last_step]), method: :get
  end

  def create
    @compare_projects =  CompareProject.new(compare_projects_params)
    if @compare_projects.save
      session[:compare_projects] = nil
      session[:last_step] = nil
      flash[:notice] = "Проанализируйте полученный результат"
      redirect_to root_path
    else
      flash[:alert] = "Сравнение не произошло"
      redirect_to root_path
    end
  end
  
  def destroy
    session[:compare_project] = nil
    session[:last_step] = nil
    flash[:alert] = "Сравнение прервано"
    redirect_to root_path
  end

  private
  
  def check_valid_aspects_method
    !@compare_projects.valid_aspects || !@compare_projects.valid_project_id
  end

  def compare_projects_params
    session[:compare_project] ||= {}
    session[:compare_project].deep_merge!(prm) if params.has_key?(:compare_project)
    session[:compare_project]
  end
  
  def prm
    params.require(:compare_project).permit(:user_id, :main_project_id, :current_step, project_ids: [], bocr_values: {}, aspects_priorities: {}, project_values: {})
  end
end