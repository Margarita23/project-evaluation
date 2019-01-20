class SetProjectsPrioritiesService
  
  def initialize(current_user, projects_values, compare, aspects_priorities, bocr_priorities)
    @current_user = current_user
    @projects_values = projects_values
    @compare = compare
    @aspects_priorities = aspects_priorities
    @bocr_priorities = bocr_priorities
  end
  
  def call
    [multi_formula, additive_formula_one, set_projects_priorities_to_grafic]
  end
  
  def multi_formula
    bocr_global = bocr_global_values
    multi_result = {}
    bocr_global.each_pair do |id, bocr_aspects|
      arr = bocr_aspects.values
      
      one = arr[0].nil? ? [1, 1] : [arr[0], @bocr_priorities["benefit"].to_f]
      two = arr[1].nil? ? [1, 1] : [arr[1], @bocr_priorities["opportunity"].to_f]
      three = arr[2].nil? ? [1, 1] : [arr[2], @bocr_priorities["cost"].to_f]
      four = arr[3].nil? ? [1, 1] : [arr[3], @bocr_priorities["risk"].to_f]
      
      numerator = (one[0]**one[1]) * (two[0]**two[1])
      denominator = (three[0]**three[1]) * (four[0]**four[1])
      multi_result[@current_user.projects.find(id).name] = numerator / denominator
    end
    
    multi_result
  end
  
  def additive_formula_one
    bocr_global = bocr_global_values
    additive_result = {}
    bocr_global.each_pair do |id, bocr_aspects|
      arr = bocr_aspects.values
      
      b = arr[0].nil? ? 1 : arr[0]*@bocr_priorities["benefit"].to_f
      
      o = arr[1].nil? ? 1 : arr[1]*@bocr_priorities["opportunity"].to_f
      
      c = arr[2].nil? ? 1 : @bocr_priorities["cost"].to_f/arr[2]
      
      r = arr[3].nil? ? 1 : @bocr_priorities["risk"].to_f/arr[3]
      additive_result[@current_user.projects.find(id).name] = b + o + c + r
    end
    additive_result
  end
  
  def set_projects_priorities_to_grafic
    hash = set_projects_priorities.clone
    
    some_hash = hash.values[0].values.reduce Hash.new, :merge
    some_hash.each_pair do |key, val|
      some_hash[key] = {}
    end
    
    hash.each_pair do |pr_id, aspects|
      cr = aspects.values.reduce Hash.new, :merge
      cr.each_pair do |name, value|
        some_hash[name][@current_user.projects.find(pr_id).name] = value
      end
    end
    some_hash
  end
  
  def bocr_global_values
    bocr_global = set_projects_priorities
    asp_priorities = @aspects_priorities
    pr_priorit_values = set_projects_priorities
    pr_priorit_values.each_pair do |pr_id, bocr_aspects|
      bocr_aspects.each_pair do |bocr_name, aspects|
        @sum = 0.0
        aspects.each_pair do |asp, val|
           @sum = @sum + (val.to_f * asp_priorities[bocr_name][asp].to_f)
        end
        bocr_global[pr_id][bocr_name] = @sum
      end
    end
    bocr_global
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
            empty[pr_id][bocr_name][asp] = 1.0/-(val.to_f - 1)
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