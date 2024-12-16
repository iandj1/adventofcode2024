input = File.open("inputs/16-sample.txt")
input = File.open("inputs/16.txt")

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

visited = Hash.new(Float::INFINITY) # [row, col, rowdir, coldir] => min score

newly_visited = [start + [0, 1, 0, false]] # [row, col, rowdir, coldir, score, turned?]

best_score = Float::INFINITY

while !newly_visited.empty?
  row, col, rowdir, coldir, score, turned = newly_visited.shift # take from start
  best_score = [best_score, score].min if [row, col] == finish
  next if score > best_score # not worth continuing path
  next if !spaces.include?([row, col]) # ignore walls
  key = [row, col, rowdir, coldir]
  if visited[key] > score
    visited[key] = score
    newly_visited.prepend([row+rowdir, col+coldir, rowdir, coldir, score+1, false]) # prefer to not turn, so prepend
    if !turned # don't check 180
      newly_visited << [row, col, coldir, rowdir, score+1000, true] # turn one way
      newly_visited << [row, col, -coldir, -rowdir, score+1000, true] # turn other way
    end
  end
end

best_score = [visited[finish + [-1,0]], visited[finish + [0,1]]].min
puts best_score

visited_scores = visited.to_set{|val| val.flatten}

newly_visited = []
newly_visited << finish + [-1,0, best_score] if visited[finish + [-1,0]] == best_score
newly_visited << finish + [0,1, best_score] if visited[finish + [0,1]] == best_score
path_tiles = Set.new

while !newly_visited.empty?
  row, col, rowdir, coldir, score = newly_visited.pop
  path_tiles << [row, col]
  key = [row-rowdir, col-coldir, rowdir, coldir, score-1]
  newly_visited << key if visited_scores.include?(key)
  [[coldir,rowdir],[-coldir,-rowdir]].each do |new_rowdir, new_coldir|
    key = [row, col, new_rowdir, new_coldir, score-1000]
    newly_visited << key if visited_scores.include? key
  end
end

puts path_tiles.size
