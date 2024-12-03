input = File.open("inputs/3-sample.txt")
input = File.open("inputs/3.txt")

total = 0

input.each do |line|
  line.strip.scan(/mul\(\d{1,3},\d{1,3}\)/).each do |mul|
    n,m = mul.gsub(/[^\d,]/,'').split(',').map(&:to_i)
    total += n*m
  end
end

puts total