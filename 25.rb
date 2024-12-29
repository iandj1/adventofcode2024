input = File.open("inputs/25-sample.txt")
input = File.open("inputs/25.txt")

keys = []
locks = []

input.readlines.reject{|x| x == "\n"}.each_slice(7) do |block|
  count = [0,0,0,0,0]
  (1..5).each do |row|
    (0..4).each do |col|
      count[col] += 1 if block[row][col] == '#'
    end
  end
  if block.first.strip == '#####'
    keys << count
  else
    locks << count
  end
end

total = 0
locks.each do |lock|
  keys.each do |key|
    total += 1 if (0...5).all?{|i| lock[i] + key[i] <= 5}
  end
end
puts total