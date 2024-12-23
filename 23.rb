input = File.open("inputs/23-sample.txt")
input = File.open("inputs/23.txt")

connections = {}

input.each do |line|
  pc1, pc2 = line.strip.split('-')
  connections[pc1] ||= Set.new
  connections[pc2] ||= Set.new
  connections[pc1] << pc2
  connections[pc2] << pc1
end

# part 1
cycles = Set.new
connections.each do |first, seconds|
  seconds.each do |second|
    connections[second].each do |third|
      if connections[third].include? first
        cycles << [first, second, third].sort
      end
    end
  end
end
puts cycles.count{|cycle| cycle.any?{|pc| pc.start_with? 't'}}

# part 2
catch (:found) do
  connections.each_key do |node1|
    connections[node1].each do |missing_node| # try excluding one node from connected nodes
      mesh_nodes = (connections[node1] - [missing_node] + [node1])
      if mesh_nodes.all?{|node| (connections[node] + [node]).superset? mesh_nodes} # check for full mesh
        puts mesh_nodes.sort.join(',')
        throw :found
      end
    end
  end
end