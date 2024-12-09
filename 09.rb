input = File.open("inputs/9-sample.txt")
input = File.open("inputs/9.txt")

disk = []

input.readline.chars.each_slice(2).with_index do |(data, space), index|
  data.to_i.times do
    disk << index
  end
  space.to_i.times do
    disk << nil
  end
end

last_index = 0
loop do
  while disk[-1].nil?
    disk.pop
  end
  nil_index = nil
  (last_index...disk.length).each do |index|
    if disk[index].nil?
      nil_index = index
      break
    end
  end
  break if nil_index.nil?
  last_index = nil_index
  disk[nil_index] = disk.pop
end

total = 0
disk.each_with_index do |n, index|
  total += n*index
end

puts total
