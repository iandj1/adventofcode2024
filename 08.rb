input = File.open("inputs/8-sample.txt")
input = File.open("inputs/8.txt")

antennas = {} # frequency: array of coords
size = 0

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    next if char == '.'
    antennas[char] ||= []
    antennas[char] << [row, col]
  end
  size = row
end

# part 1
antinodes = Set.new

antennas.each do |frequency, coords|
  coords.combination(2).each do | (row1, col1), (row2, col2) |
    row_delta = row2 - row1
    col_delta = col2 - col1
    antinodes << [row1 - row_delta, col1 - col_delta]
    antinodes << [row2 + row_delta, col2 + col_delta]
  end
end

antinodes.delete_if{|row, col| row < 0 || row > size || col < 0 || col > size}
puts antinodes.size


# part 2
antinodes = Set.new

antennas.each do |frequency, coords|
  coords.combination(2).each do | (row1, col1), (row2, col2) |
    row_delta = row2 - row1
    col_delta = col2 - col1
    (-size..size).each do |n| # crude way to cover full map
      antinodes << [row1 + row_delta * n, col1 + col_delta * n]
    end
  end
end

antinodes.delete_if{|row, col| row < 0 || row > size || col < 0 || col > size}
puts antinodes.size