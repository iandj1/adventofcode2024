input = File.open("inputs/17-sample.txt")
input = File.open("inputs/17.txt")

reg_a = input.readline[(/\d+/)].to_i
reg_b = input.readline[(/\d+/)].to_i
reg_c = input.readline[(/\d+/)].to_i
input.readline
program = input.readline.scan(/\d+/).map(&:to_i)

pointer = 0
output = []

loop do
  opcode = program[pointer]
  break if opcode.nil?
  operand = program[pointer+1]
  combo = [0,1,2,3,reg_a,reg_b,reg_c]

  case opcode
  when 0 # adv (A division)
    reg_a = reg_a / (2**combo[operand])
  when 1 # bxl
    reg_b = reg_b ^ operand
  when 2 # bst
    reg_b = combo[operand] % 8
  when 3 # jnz
    if reg_a != 0
      pointer = operand
      next
    end
  when 4 # bxc
    reg_b = reg_b ^ reg_c
  when 5 # out
    output << combo[operand] % 8
  when 6 # bdv
    reg_b = reg_a / (2**combo[operand])
  when 7 # cdv
    reg_c = reg_a / (2**combo[operand])
  end

  pointer += 2
end

puts output.join(',')
