class SetBocrPrioritiesService
  
  def initialize(compare_projects)
    @compare_projects = compare_projects
  end
  
  def call
    set_bocr_priorities
  end
  
  def set_bocr_priorities
    bocr_priorities = {}
    true_values = set_true_values.clone
    sum = true_values.values.inject(0) {|s, x| s + 1/x.to_f }
    true_values.each_pair do |key, val|
      bocr_priorities[key] = 1.0 / (val.to_f * sum.to_f)
    end
    bocr_priorities
  end
  
  private
  
  def set_true_values
    bocr_val = {"benefit" => "0"}.merge(@compare_projects.bocr_values.clone)
    bocr_val.each_pair do |key, val|
      if val.to_i >= 0
        bocr_val[key] = val.to_i + 1
      else val.to_i < 0
        bocr_val[key] = 1.0/-(val.to_f - 1)
      end
    end
    bocr_val
  end

end