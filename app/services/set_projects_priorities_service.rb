class SetProjectsPrioritiesService
  
  def initialize(projects_values, compare, aspects_priorities)
    @projects_values = projects_values
    @compare = compare
    @aspects_priorities = aspects_priorities
  end
  
  def call
    [set_projects_priorities, @aspects_priorities]
  end
  
  def set_projects_priorities
    special_sum_hash = get_special_sum
    empty_hash = empty_projects_range
    true_values = true_project_values
    empty_hash.each_pair do |id, bocr_asp|
      bocr_asp.each_pair do |bocr_name, aspects|
        aspects.each_pair do |key, val|
          empty_hash[id][bocr_name][key] = 1.0/(true_values[id][bocr_name][key].to_f * special_sum_hash[bocr_name][key].to_f)
        end
      end
    end
    empty_hash
  end
  
  private
    
  def get_special_sum
    special_sum = set_main_prj_values.values.first
    pr_values = true_project_values
    pr_values.each_pair do |pr_id, bocr_aspects|
      bocr_aspects.each_pair do |bocr_name, aspects|
        aspects.each_pair do |asp, val|
          special_sum[bocr_name][asp] = special_sum[bocr_name][asp].to_f + (1.0/val.to_f)
        end
      end
    end
    special_sum
  end
  
  def true_project_values
    empty = set_main_prj_values.merge(@projects_values.permit!.to_h)
    empty.each_pair do |pr_id, bocr_aspects|
      
      bocr_aspects.each_pair do |bocr_name, aspects|
        aspects.each_pair do |asp, val|
          if val.to_f >=0
            empty[pr_id][bocr_name][asp] = val.to_f + 1
          else
            empty[pr_id][bocr_name][asp] = 1.0/(-val.to_f)
          end
        end
      end
    end
    empty
  end
  
  def empty_projects_range
    empty_projects_hash = set_main_prj_values.merge(@projects_values.permit!.to_h)
    empty_projects_hash.each_pair do |pr_id, bocr_aspects|
      
      bocr_aspects.each_pair do |bocr_name, aspects|
        aspects.each_pair do |asp, val|
          empty_projects_hash[pr_id][bocr_name][asp] = 0
        end
      end
    end
    empty_projects_hash
  end

  def set_main_prj_values
    main_prj_val =  {@compare.main_project_id => @projects_values.permit!.to_h.values.first}
    main_prj_val.each_pair do |pr_id, bocr_asp|
      bocr_asp.each_pair do |bocr_name, aspects|
        aspects.each_pair do |asp, val|
          main_prj_val[pr_id][bocr_name][asp] = 0
        end
      end
    end
  end
  
end