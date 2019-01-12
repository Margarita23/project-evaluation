class SetAspectsPrioritiesService
  def initialize(aspects_priorities)
    @aspects_priorities = aspects_priorities.permit!.to_h
  end
  
  def call
    priorities
  end
  
  def priorities
    true_criterias = set_true_value_criteria(@aspects_priorities)
    prio(true_criterias)
  end

  
  def set_true_value_criteria(cr)
    cr.each_pair do |bocr_name, aspects|
      aspects.each_pair do |k, val|
        if(val.to_f >= 0)
          cr[bocr_name][k] = val.to_f + 1
        else
          cr[bocr_name][k] = 1.0/(-val.to_f)
        end
      end
    end
    cr
  end
  
  def prio(true_criterias)
    prio = true_criterias.clone
    true_criterias.each_pair do |bocr_name, aspects|
      if aspects.length > 1
          s = sum(aspects.values.to_a)
        
        aspects.each_pair do |k, val|
          prio[bocr_name][k] = 1/(aspects[k].to_f * s)
        end
      elsif aspects.length == 1
        aspects.each_pair do |k, val|
          prio[bocr_name][k] = 1
        end
      end
    end
    prio
  end
  
  def sum(v_arr)
    s = 0
    v_arr.each do |el|
      s += 1.0/el
    end
    s
  end
  
end