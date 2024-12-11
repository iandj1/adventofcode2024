input = File.open("inputs/11-sample.txt")
input = File.open("inputs/11.txt")

stones = input.readline.strip.split(' ').map(&:to_i)

25.times do
  new_stones = []
  stones.each do |stone|
    stone_str = stone.to_s
    if stone == 0
      new_stones << 1
    elsif stone_str.length % 2 == 0
      new_stones << stone_str[0...stone_str.length/2].to_i
      new_stones << stone_str[stone_str.length/2..-1].to_i
    else
      new_stones << stone * 2024
    end
  end
  stones = new_stones
end

pp stones.length