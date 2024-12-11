input = File.open("inputs/11-sample.txt")
input = File.open("inputs/11.txt")

stones = input.readline.strip.split(' ').map(&:to_i)

times = 75

def stone_count(stone, times, memo)
  key = [stone, times]
  if !memo[key]
    if times == 0
      memo[key] = 1
    elsif stone == 0
      memo[key] = stone_count(1, times-1, memo)
    elsif stone.to_s.length % 2 == 0
      memo[key] = stone_count(stone.to_s[0...stone.to_s.length/2].to_i, times-1, memo) +
                  stone_count(stone.to_s[stone.to_s.length/2..-1].to_i, times-1, memo)
    else
      memo[key] = stone_count(stone * 2024, times-1, memo)
    end
  end
  return memo[key]
end

total = 0
memo = {}
stones.each do |stone|
  total += stone_count(stone, times, memo)
end
puts total