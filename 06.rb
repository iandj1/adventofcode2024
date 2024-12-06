input = File.open("inputs/6-sample.txt")
input = File.open("inputs/6.txt")

objects = Set.new
orig_pos = nil
direction = [-1,0]
size = nil
path_coords = Set.new

def rotate(direction)
  if direction[0] != 0
    direction[1] =  -direction[0]
    direction[0] = 0
  else
    direction[0] =  direction[1]
    direction[1] = 0
  end
end

input.each_with_index do |line, row|
  size = row
  line = line.strip.split('')
  if line.include? '^'
    orig_pos = [row, line.index('^')]
  end
  while line.include? '#'
    col = line.rindex('#')
    objects.add([row, col])
    line.delete_at(col)
  end
end

current_pos = orig_pos.dup
# part 1
loop do # walk until off map
  path_coords.add(current_pos)
  next_pos = [current_pos[0] + direction[0], current_pos[1] + direction[1]]
  if objects.include? next_pos # is next step blocked?
    rotate(direction)
  else
    current_pos = next_pos
  end
  break if current_pos[0] < 0 || current_pos[0] > size || current_pos[1] < 0 || current_pos[1] > size
end

puts path_coords.size

# part 2 - repeated code but oh well
def loop?(current_pos, direction, size, states, objects)
  loop do # walk until off map
    return true if !states.add?([current_pos, direction].flatten)
    next_pos = [current_pos[0] + direction[0], current_pos[1] + direction[1]]
    if objects.include? next_pos # is next step blocked?
      rotate(direction)
    else
      current_pos = next_pos
    end
    return false if current_pos[0] < 0 || current_pos[0] > size || current_pos[1] < 0 || current_pos[1] > size
  end
end


loop_count = 0

path_coords.each do |coord|
  next if orig_pos == coord
  new_objects = objects.dup
  new_objects.add(coord)
  loop_count += 1 if loop?(orig_pos.dup, direction.dup, size, Set.new, new_objects)
end

puts loop_count