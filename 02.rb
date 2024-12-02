input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

rows = []

input.each do |line|
  rows << line.strip.split(' ').map(&:to_i)
end

safe_count = 0

rows.each do |row|
  increasing = row[1] > row[0]
  safe_count += 1 if row.each_cons(2).all? do |a, b|
    next false if a == b
    next false if (a < b) != increasing
    (a-b).abs <= 3
  end
end

puts safe_count
