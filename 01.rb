input = File.open("inputs/1-sample.txt")
input = File.open("inputs/1.txt")

col1 = []
col2 = []

input.each do |line|
  n1, n2 = line.strip.split(' ')
  col1 << n1.to_i
  col2 << n2.to_i
end

col1.sort!
col2.sort!

total_1 = 0
total_2 = 0

col2_counts = col2.tally

while !col1.empty?
  n1 = col1.pop
  n2 = col2.pop

  total_1 += (n1 - n2).abs
  total_2 += (col2_counts[n1] || 0) * n1
end

puts total_1
puts total_2