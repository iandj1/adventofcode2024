input = File.open("inputs/3-sample.txt")
input = File.open("inputs/3.txt")

total = 0
enabled = true

input.each do |line|
  line.strip.scan(/don't\(\)|do\(\)|mul\(\d{1,3},\d{1,3}\)/).each do |op|
    if op == 'do()'
      enabled = true
      next
    elsif op == "don't()"
      enabled = false
      next
    elsif enabled
      n,m = op.gsub(/[^\d,]/,'').split(',').map(&:to_i)
      total += n*m
    end
  end
end

puts total