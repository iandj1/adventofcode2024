input = File.open("inputs/14-sample.txt")
input = File.open("inputs/14.txt")

robots = []

input.each do |line|
  line.strip!
  robots << line.gsub(/[pv=]/,'').split(' ').map{|x| x.split(',').map(&:to_i)}
end

width = 101
height = 103

seen_layouts = Set.new

loop.with_index do |_, time|
  time += 1
  robots.each do |coord, (vx, vy)|
    coord[0]  = (coord[0] + vx) % width
    coord[1]  = (coord[1] + vy) % height
  end
  coords = robots.map(&:first)
  break if !seen_layouts.add? coords # stop if we've been here before

  # lucky guess of property of tree
  if coords.tally.values.max == 1
    coords = coords.to_set
    puts time
    (0...height).each do |y|
      (0...width).each do |x|
        if coords.include? [x,y]
          print('#')
        else
          print(' ')
        end
      end
        puts ''
    end
  end
end