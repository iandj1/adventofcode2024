input = File.open("inputs/14-sample.txt")
input = File.open("inputs/14.txt")

robots = []

input.each do |line|
  line.strip!
  robots << line.gsub(/[pv=]/,'').split(' ').map{|x| x.split(',').map(&:to_i)}
end

width = 101
height = 103
time = 100


quads = [[0,0],[0,0]]

robots.each do |(x,y), (vx, vy)|
  x = (x + time * vx) % width
  y = (y + time * vy) % height

  next if x == width/2
  next if y == height/2

  x_quad = x < width/2 ? 0 : 1
  y_quad = y < height/2 ? 0 : 1

  quads[x_quad][y_quad] += 1
end

puts quads.flatten.inject(:*)