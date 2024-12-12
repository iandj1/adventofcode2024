input = File.open("inputs/12-sample.txt")
# input = File.open("inputs/12.txt")

grid = {}
size = 0

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    grid[[row, col]] = char
  end
  size = row
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
  coords = []
  region.each do |row, col|
    [[0,1], [0,-1], [1,0], [-1,0]].count do |row_delta, col_delta|
      test_coord = [row + row_delta, col + col_delta]
      if !region.include? [test_coord]
        coords << test_coord if !region.include? [row + row_delta, col + col_delta]
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


total = 0
regions.each do |region|
  border_points = bordering_coords(region).tally
  edges = 0
  while !border_points.empty?
    coord, count = border_points.first
    row, col = coord
    # expand coord horizontally
    if (border_points[[row, col-1]] || border_points[[row, col+1]])
      count -= 1
      edges += 1
      # linear_coords = []
      (col+1..col+size).each do |test_col|
        if border_points[[row, test_col]]
          # linear_coords << [row, test_col]
          border_points[[row, test_col]] -= 1
        else
          break
        end
      end
      (col-size..col-1).reverse_each do |test_col|
        if border_points[[row, test_col]]
          # linear_coords << [row, test_col]
          border_points[[row, test_col]] -= 1
        else
          break
        end
      end
    end
    # expand coord vertically
    if (border_points[[row-1, col]] || border_points[[row+1, col]]) && count > 0
      count -= 1
      edges += 1
      # linear_coords = []
      (row+1..row+size).each do |test_row|
        if border_points[[test_row, col]]
          # linear_coords << [test_row, col]
          border_points[[test_row, col]] -= 1
        else
          break
        end
      end
      (row-size..row-1).reverse_each do |test_row|
        if border_points[[test_row, col]]
          # linear_coords << [test_row, col]
          border_points[[test_row, col]] -= 1
        else
          break
        end
      end
    end
    # must be 1x1 or internal endpoint, add 1 anyway
    edges += count
    border_points[coord] = 0
    # break
    border_points.reject!{|_,val| val == 0}
  end
  pp region
  pp region.count
  pp edges
  total += edges * region.count
end

puts total
