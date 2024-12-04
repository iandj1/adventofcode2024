input = File.open("inputs/4-sample.txt")
input = File.open("inputs/4.txt")

grid = {}

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    grid[[row, col]] = char
  end
end

directions = [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]]

xmas_count = 0

grid.each do |(row, col), char|
  if char == 'X'
    directions.each do |(dir_row, dir_col)|
      if grid[[row + dir_row, col + dir_col]] == 'M' &&
         grid[[row + dir_row*2, col + dir_col*2]] == 'A' &&
         grid[[row + dir_row*3, col + dir_col*3]] == 'S'

        xmas_count += 1
      end
    end
  end
end


puts xmas_count
