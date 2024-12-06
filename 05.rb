input = File.open("inputs/5-sample.txt")
input = File.open("inputs/5.txt")

rules = Set.new

input.each do |line|
  line.strip!
  break if line.empty?
  rules << line.split('|').map(&:to_i)
end

def rule_met?(page_order, rule)
  return true if page_order.intersection(rule).length != 2 # rule doesn't matter if both pages aren't in print
  page_order.find_index(rule[0]) < page_order.find_index(rule[1])
end

total_1 = 0
total_2 = 0

input.each do |line|
  page_order = line.strip.split(',').map(&:to_i)

  if rules.all? { |rule| rule_met?(page_order, rule) }
    total_1 += page_order[page_order.length/2]
    next
  end

  page_order.sort! do |a,b|
    if rules.include?([a,b])
      -1
    elsif rules.include?([b,a])
      1
    else
      0
    end
  end
  total_2 += page_order[page_order.length/2]
end

puts total_1
puts total_2