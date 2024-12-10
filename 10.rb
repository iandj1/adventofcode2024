input = File.open("inputs/10-sample.txt")
input = File.open("inputs/10.txt")

grid = {}

input.each.with_index do |line, row|
  line.strip.chars.each.with_index do |char, col|
    grid[[row, col]] = char.to_i
  end
end


def reachable_peaks(coord, height, grid)
  return [[coord]] if height == 9
  peaks = []
  [ [-1,0], [1,0], [0,-1], [0,1] ].each do |delta|
    next_coord = [coord[0] + delta[0], coord[1] + delta[1]]
    if grid[next_coord] == height + 1
      peaks.concat(reachable_peaks(next_coord, height + 1, grid))
    end
  end
  return peaks
end

total_1 = 0
total_2 = 0
grid.each do |coord, height|
  next unless height == 0
  peaks = reachable_peaks(coord, height, grid)
  total_1 += peaks.uniq.length
  total_2 += peaks.length
end

puts total_1
puts total_2
