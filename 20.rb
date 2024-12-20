input = File.open("inputs/20-sample.txt")
input = File.open("inputs/20.txt")

spaces = Set.new
start = nil
finish = nil

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    case char
    when '#'
      next
    when 'S'
      start = [row, col]
    when 'E'
      finish = [row, col]
    end
    spaces << [row, col]
  end
end

def calc_distances(start, finish, spaces)
  distances = {start => 0}
  newly_visited = [start]
  while !newly_visited.empty?
    x, y = newly_visited.shift
    [[1,0],[-1,0],[0,1],[0,-1]].each do |delta_x, delta_y|
      new_x = x + delta_x
      new_y = y + delta_y
      next if distances[[new_x, new_y]] # already been here. Can't have a better score
      next if !spaces.include? [new_x, new_y] # new position is a wall
      distances[[new_x, new_y]] = distances[[x,y]] + 1
      newly_visited << [new_x, new_y]
    end
  end
  distances
end

distances = calc_distances(start, finish, spaces)

def offsets(time_limit)
  offsets = []
  (-time_limit..time_limit).each do |row|
    (-(time_limit-row.abs)..(time_limit-row.abs)).each do |col|
      offsets << [row, col] unless row.abs + col.abs <= 1 # skip directions shorter than 1 wall
    end
  end
  offsets
end

def count_cheats(distances, offsets, threshold)
  distances.sum do |(x,y), distance|
    offsets.count do |delta_x, delta_y|
      old_distance = distances[[x+delta_x, y+delta_y]]
      new_distance = distance + delta_x.abs + delta_y.abs
      old_distance && old_distance - new_distance >= threshold
    end
  end
end

# part 1
puts count_cheats(distances, offsets(2), 100)

# part 2
puts count_cheats(distances, offsets(20), 100)