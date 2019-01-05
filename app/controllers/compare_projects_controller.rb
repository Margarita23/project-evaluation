class CompareProjectsController < ApplicationController
  include Wicked::Wizard

  # assign_main -> получение 'главного' проекта
  # compare_projects -> сравнить проекты относительно главного проекта
  # set_criteria_priorities -> расчет приоритетов критериев
  # get_global_ratings -> получить глобальные оценки

  steps :assign_main, :compare_projects, :set_criteria_priorities, :get_global_ratings

  def show
    @compare_projects = CompareProject.new(compare_projects_params)
    session[:last_step] = step if can_go_to_next_step
    if check_valid_aspects
      flash[:alert] = "Выберите минимум два проекта для сравнения с одинаковыми аспектами BOCR"
      redirect_back(fallback_location: root_path) and return
    else
      render compare_project_path(session[:last_step]), method: :get and return
    end
  end

  def create
    @compare_projects = CompareProject.new(compare_projects_params)
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

  private

  def can_go_to_next_step
    #future_step?(session[:last_step]) || @compare_projects.valid?
    true
  end

  def check_valid_aspects
    return !@compare_projects.valid_aspects || @compare_projects.project_ids.size <= 1
  end

  def compare_projects_params
    session[:compare_project] ||= {}
    session[:compare_project].deep_merge!(prm) if params.has_key?(:compare_project)
    session[:compare_project]
  end
  
  def prm
    params.require(:compare_project).permit(:user_id, :main_project_id, :current_step, project_ids: [])
  end
end