input = File.open("inputs/19-sample.txt")
input = File.open("inputs/19.txt")

towels = input.readline.scan(/[a-z]+/)
input.readline
designs = input.map(&:strip)

def possible_count(towels, design, memo)
  return 1 if design == ''
  memo[design] ||= towels.sum do |towel|
    next 0 unless design.start_with? towel
    possible_count(towels, design.delete_prefix(towel), memo)
  end
end

puts designs.sum{|design| possible_count(towels, design, {})}
