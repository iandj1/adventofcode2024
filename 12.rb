input = File.open("inputs/12-sample.txt")
input = File.open("inputs/12.txt")

grid = {}

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    grid[[row, col]] = char
  end
end

regions = []
while grid.any?
  coord, plant = grid.first
  grid.delete(coord)
  plots = Set.new
  new_plots = [coord]
  while !new_plots.empty? do
    row, col = new_plots.pop
    plots << [row, col]
    [[0,1], [0,-1], [1,0], [-1,0]].each do |row_delta, col_delta|
      test_coord = [row + row_delta, col + col_delta]
      if grid[test_coord] == plant
        new_plots << test_coord
        grid.delete(test_coord)
      end
    end
  end
  regions << plots
end

def bordering_coords(region)
  coords = Set.new
  region.each do |row, col|
    [[0,1,:right], [0,-1,:left], [1,0,:down], [-1,0,:up]].count do |row_delta, col_delta, direction|
      test_coord = [row + row_delta, col + col_delta]
      if !region.include? [test_coord]
        coords << (test_coord << direction) if !region.include? [row + row_delta, col + col_delta]
      end
    end
  end
  return coords
end

# part 1
total = regions.sum do |region|
  area = region.count
  perimeter = bordering_coords(region).count
  area * perimeter
end
puts total


# part 2
total = 0
regions.each do |region|
  border_points = bordering_coords(region)
  edges = 0
  while !border_points.empty?
    row, col, direction = border_points.first
    # expand coord horizontally
    if (border_points.include?([row, col-1, direction]) || border_points.include?([row, col+1, direction])) && [:up, :down].include?(direction)
      (col+1..).each do |test_col|
        break unless border_points.delete?([row, test_col, direction])
      end
      (..col-1).reverse_each do |test_col|
        break unless border_points.delete?([row, test_col, direction])
      end
    # expand coord vertically
    elsif (border_points.include?([row-1, col, direction]) || border_points.include?([row+1, col, direction])) && [:left, :right].include?(direction)
      (row+1..).each do |test_row|
        break unless border_points.delete?([test_row, col, direction])
      end
      (..row-1).reverse_each do |test_row|
        break unless border_points.delete?([test_row, col, direction])
      end
    end
    edges += 1
    border_points.delete([row, col, direction])
  end
  total += edges * region.count
end

puts total
