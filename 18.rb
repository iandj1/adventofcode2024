input = File.open("inputs/18-sample.txt")
input = File.open("inputs/18.txt")

falling = []

input.each do |line|
  line.strip!
  falling << line.split(',').map(&:to_i)
end

size = 70
start = [0,0]
finish = [size,size]

def calc_distances(size, start, walls)
  distances = {start => 0}
  newly_visited = [start]
  while !newly_visited.empty?
    x, y = newly_visited.shift
    [[1,0],[-1,0],[0,1],[0,-1]].each do |delta_x, delta_y|
      new_x = x + delta_x
      new_y = y + delta_y
      next if new_x < 0 || new_x > size || new_y < 0 || new_y > size # don't go out of bounds
      next if distances[[new_x, new_y]] # already been here. Can't have a better score
      next if walls.include? [new_x, new_y] # new position is corrupt
      distances[[new_x, new_y]] = distances[[x,y]] + 1
      newly_visited << [new_x, new_y]
    end
  end
  distances
end

puts calc_distances(size, start, falling[0,1024].to_set)[finish]

index = (0...falling.count).bsearch do |i|
  !calc_distances(size, start, falling[0,i+1].to_set)[finish]
end

puts falling[index].join(',')