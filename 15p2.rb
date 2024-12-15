input = File.open("inputs/15-sample.txt")
# input = File.open("inputs/15.txt")

walls = Set.new
boxes = Set.new
robot = nil

input.each_with_index do |line, row|
  line.strip!
  break if line.empty?
  line.chars.each_with_index do |char, col|
    col *= 2
    case char
    when '#'
      walls << [row, col]
      walls << [row, col+1]
    when 'O'
      boxes << [row, col]
    when '@'
      robot = [row, col]
    end
  end
end

moves = []
move_delta = { '<' => [0,-1], '>' => [0,1], '^' => [-1,0], 'v' => [1,0]}

input.each do |line|
  moves += line.strip.chars
end

def print_grid(boxes, walls, robot)
  dim = walls.to_a.last
  (0..dim[0]).each do |row|
    (0..dim[1]).each do |col|
      if walls.include? [row,col]
        print('#')
      elsif boxes.include? [row, col]
        print('[')
      elsif boxes.include? [row, col-1]
        print(']')
      elsif robot == [row,col]
        print('@')
      else
        print('.')
      end
    end
    puts ''
  end
end

def move?(delta, coord, boxes, walls, apply = false)
  # blocked by wall
  return false if walls.include? coord
  # free to move
  return true if !boxes.include?(coord) && (!boxes.include?([coord[0], coord[1]-1]))
  # push more boxes
  if boxes.include? coord # running into left side of box
    new_coord1 = [coord[0] + delta[0], coord[1] + delta[1]]
    new_coord2 = [coord[0] + delta[0], coord[1] + delta[1] + 1]
  else # running into right side of box
    new_coord1 = [coord[0] + delta[0], coord[1] + delta[1] - 1]
    new_coord2 = [coord[0] + delta[0], coord[1] + delta[1]]
  end


  if (delta[1] == 1 || move?(delta, new_coord1, boxes, walls, apply)) && # don't check left side of box if pushing right
     (delta[1] == -1 || move?(delta, new_coord2, boxes, walls, apply)) # don't check right side of box if pushing left
    if apply
      boxes.delete(coord)
      boxes.delete([coord[0], coord[1]-1])
      boxes << new_coord1
    end
    return true
  else
    return false
  end
end

moves.each do |move|
  delta = move_delta[move]
  new_coord = [robot[0] + delta[0], robot[1] + delta[1]]
  if move?(delta, new_coord, boxes, walls, false)
    move?(delta, new_coord, boxes, walls, true)
    robot = new_coord
  end
end

puts boxes.map{|row, col| row*100 + col}.inject(:+)