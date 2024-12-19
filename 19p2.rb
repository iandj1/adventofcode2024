input = File.open("inputs/19-sample.txt")
input = File.open("inputs/19.txt")

towels = input.readline.scan(/[a-z]+/)
input.readline

designs = []
input.each do |line|
  designs << line.strip
end

def possible_count(towels, design, memo)
  if !memo[design]
    if design == ''
      memo[design] = 1
    else
      memo[design] = towels.sum do |towel|
        if design.start_with? towel
          possible_count(towels, design.delete_prefix(towel), memo)
        else
          0
        end
      end
    end
  end
  memo[design]
end

puts designs.sum{|design| possible_count(towels, design, {})}
