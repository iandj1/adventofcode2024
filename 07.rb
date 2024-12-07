input = File.open("inputs/7-sample.txt")
input = File.open("inputs/7.txt")

def possible_1?(target, nums)
  return nums[0] == target if nums.length == 1
  return possible_1?(target, nums[2..].unshift(nums[0] + nums[1])) ||
         possible_1?(target, nums[2..].unshift(nums[0] * nums[1]))
end

def possible_2?(target, nums)
  return nums[0] == target if nums.length == 1
  return possible_2?(target, nums[2..].unshift(nums[0] + nums[1])) ||
         possible_2?(target, nums[2..].unshift(nums[0] * nums[1])) ||
         possible_2?(target, nums[2..].unshift((nums[0].to_s + nums[1].to_s).to_i))
end

total_1 = 0
total_2 = 0
input.each do |line|
  line.strip!
  target, nums = line.split(': ')
  target = target.to_i
  nums = nums.split(' ').map(&:to_i)
  total_1 += target if possible_1?(target, nums)
  total_2 += target if possible_2?(target, nums)
end

puts total_1
puts total_2