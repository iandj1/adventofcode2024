input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

rows = []

input.each do |line|
  rows << line.strip.split(' ').map(&:to_i)
end

safe_count = 0

def row_safe?(row)
  increasing = row[1] > row[0]
  row.each_cons(2).each do |a,b|
    return false if a == b || (a < b) != increasing || (a-b).abs > 3
  end
  true
end

rows.each do |row|
  if row_safe?(row)
    safe_count += 1
  else
    (0...row.length).each do |i|
      copy = row.dup
      copy.delete_at(i)
      if row_safe?(copy)
        safe_count += 1
        break
      end
    end
  end
end

puts safe_count
