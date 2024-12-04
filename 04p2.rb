input = File.open("inputs/4-sample.txt")
input = File.open("inputs/4.txt")

grid = {}

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    grid[[row, col]] = char
  end
end

xmas_count = 0

grid.each do |(row, col), char|
  if char == 'A'
    if [['S','M'],['M','S']].include?([grid[[row-1, col-1]], grid[[row+1, col+1]]]) &&
       [['S','M'],['M','S']].include?([grid[[row-1, col+1]], grid[[row+1, col-1]]])

       xmas_count += 1
    end
  end
end

puts xmas_count
