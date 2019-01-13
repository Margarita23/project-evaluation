class CalculationService
  
  def initialize(compare)
    @compare = compare
  end
  
  def call
    set_priorities
  end
  
  def set_priorities
    sum = get_sums.clone
    
    priorities_prjs = @true_ranges.clone
    
    priorities_prjs.each_pair do |project, aspects|
      aspects.each_pair do |name, val|
        priorities_prjs[project][name] = 1.0/(priorities_prjs[project][name].to_f * sum[name].to_f)
      end
    end
    sum
  end
  
  def get_sums
    @true_ranges = set_range.clone
    sum_hash = @true_ranges.values.first.clone
    sum_hash.each_key {|k| sum_hash[k] = 0}
    aspects_val = @true_ranges.values
    count = aspects_val.count
    (0..count-1).count do |index|
      sum_hash.merge(aspects_val[index]) do |key, oldval, newval|
        sum_hash[key] += 1.0/newval.to_f
      end
    end
    sum_hash
  end
  
  def set_range
    hash_ranges = @compare.ranges.clone
    main_prj_id = @compare.main_project_id.clone
    hash = @compare.ranges.values.first.keys.clone
    main = {}
    hash.each do |el|
      main[el] = 0
    end
    hash_ranges["#{main_prj_id}"] = main
    
    hash_ranges.each do |project, aspects|
      aspects.each do |name, value|
        if value.to_i < 0
          hash_ranges[project][name] = 1.0/(-value.to_f)
        else
          hash_ranges[project][name] = value.to_f + 1
        end
      end
    end
    hash_ranges
  end
  
end