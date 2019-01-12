class CompareProjectsController < ApplicationController
  include Wicked::Wizard

  # assign_main -> получение 'главного' проекта
  # compare_projects -> сравнить проекты относительно главного проекта
  # set_criteria_priorities -> расчет приоритетов критериев
  # get_global_ratings -> получить глобальные оценки

  steps :assign_main, :compare_bocr, :compare_aspects,  :compare_projects, :get_global_ratings

  def show
      @compare_projects = CompareProject.new(compare_projects_params)
      session[:last_step] = step
    
      case step
        when :compare_aspects
          @bocr_priorities = SetBocrPrioritiesService.new(@compare_projects).call
        when :compare_projects
          @aspects_priorities = SetAspectsPrioritiesService.new(params[:compare_project][:aspects_priorities]).call
          @compare_projects.aspects_priorities.update(@aspects_priorities)
        when :get_global_ratings
          @projects_priorities_and_global_result = SetProjectsPrioritiesService.new(params[:compare_project][:project_values], @compare_projects, @compare_projects.aspects_priorities).call
      end
    if check_valid_aspects
      flash[:alert] = "Выберите минимум два проекта для сравнения с одинаковыми аспектами BOCR"
      redirect_back(fallback_location: root_path) and return
    else
      render compare_project_path(session[:last_step]), method: :get and return
    end
    
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

  def check_valid_aspects
    return !@compare_projects.valid_aspects || @compare_projects.project_ids.size <= 1
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