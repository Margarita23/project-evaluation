class CompareProject < ApplicationRecord
  attr_accessor(
    :project_ids,
    :main_project_id,
    :user_id,
    :current_step,
    :bocr_values,
    :aspects_priorities,
    :project_values
    )
  
  validates_presence_of :main_project_id, message: "Выберите главный проект", if: :on_assign_main
  validates_presence_of :bocr_values, message: "Поставьте оценки главным аспектам", if: :on_compare_bocr
  
  def on_assign_main
    current_step == 'assign_main'
  end
  
  def on_compare_bocr
    current_step == 'compare_bocr'
  end
  
  def save
    return false unless valid?
    true
  end

  def current_user
    User.find_by(id: user_id.to_i)
  end
  
  def projects
    projects = current_user.projects.find(project_ids)
  end
  
  def minor_prj
    projects.select{ |el| el.id.to_i != main_project_id.to_i }
  end
  
  def main_prj
    current_user.projects.find(main_project_id.to_i)
  end
  
  def aspects
    benefits = current_user.projects.find(main_project_id.to_i).benefits
    opportunities = current_user.projects.find(main_project_id.to_i).opportunities
    costs = current_user.projects.find(main_project_id.to_i).costs
    risks = current_user.projects.find(main_project_id.to_i).risks
    Hash[benefit: benefits, opportunity: opportunities, cost: costs, risk: risks]
  end
  
  def valid_aspects
    b_valid_count? && o_valid_count? && c_valid_count? && r_valid_count?
  end
  
  def valid_project_id
    project_ids.present? && project_ids.count > 1
  end
  
  private
  
  def b_valid_count?
    hash = Hash[projects.collect {|p| [p.name, p.benefits.collect{|b| b.name}]}]
    hash.values.uniq.size == 1 
  end
  
  def o_valid_count?
    hash = Hash[projects.collect {|p| [p.name, p.opportunities.collect{|b| b.name}]}]
    hash.values.uniq.size == 1 
  end
  
  def c_valid_count?
    hash = Hash[projects.collect {|p| [p.name, p.costs.collect{|b| b.name}]}]
    hash.values.uniq.size == 1 
  end
  
  def r_valid_count?
    hash = Hash[projects.collect {|p| [p.name, p.risks.collect{|b| b.name}]}]
    hash.values.uniq.size == 1 
  end
  
end
