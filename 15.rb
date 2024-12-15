input = File.open("inputs/15-sample.txt")
input = File.open("inputs/15.txt")

walls = Set.new
boxes = Set.new
robot = nil

input.each_with_index do |line, row|
  line.strip!
  break if line.empty?
  line.chars.each_with_index do |char, col|
    case char
    when '#'
      walls << [row, col]
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

def move?(delta, coord, boxes, walls)
  # blocked by wall
  return false if walls.include? coord
  # free to move
  return true if !boxes.include? coord
  # push more boxes
  new_coord = [coord[0] + delta[0], coord[1] + delta[1]]
  if move?(delta, new_coord, boxes, walls)
    boxes.delete(coord)
    boxes << new_coord
    return true
  else
    return false
  end
end

moves.each do |move|
  delta = move_delta[move]
  new_coord = [robot[0] + delta[0], robot[1] + delta[1]]
  if move?(delta, new_coord, boxes, walls)
    robot = new_coord
  end
end

puts boxes.map{|row, col| row*100 + col}.inject(:+)