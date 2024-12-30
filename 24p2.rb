input = File.open("inputs/24.txt")

# skip wires
input.each do |line|
  break if line.strip.empty?
end

gates =  {}
# parse gates
input.each do |line|
  line = line.strip.split(' ')
  gates[line[4]] = [line[0], line[1], line[2]] # in1, op, in2
end

def logic_str(gates, wire, swaps={}, visited_wires=[]) # generate logic string for node recursively to exclude intermediate nodes
  wire = swaps[wire] || wire # perform any swaps specified
  visited_wires << wire
  return wire if ['x','y'].include? wire[0] # input wire. return wire name
  in1, op, in2 = gates[wire]
  str1 = logic_str(gates, in1, swaps, visited_wires)
  str2 = logic_str(gates, in2, swaps, visited_wires)
  str1, str2 = [str1, str2].sort
  return "(#{str1} #{op} #{str2})"
end

def build_adder(gates, n) # construct n-bit adder circuit for comparison
  n_str = '%02d' % n
  n_str_sub = '%02d' % (n-1)
  if n == 0 # half adder
    gates["z#{n_str}"] = ["x#{n_str}", "XOR", "y#{n_str}"]
    gates["carry#{n_str}"] = ["x#{n_str}", "AND", "y#{n_str}"]
  else # full adder
    gates["exor_xy#{n_str}"] = ["x#{n_str}", "XOR", "y#{n_str}"]
    gates["z#{n_str}"] = ["exor_xy#{n_str}", "XOR", "carry#{n_str_sub}"]
    gates["and_carry1#{n_str}"] = ["carry#{n_str_sub}", "AND", "exor_xy#{n_str}"]
    gates["and_carry2#{n_str}"] = ["x#{n_str}", "AND", "y#{n_str}"]
    gates["carry#{n_str}"] = ["and_carry1#{n_str}", "OR", "and_carry2#{n_str}"]
    build_adder(gates, n-1)
  end
end

correct_gates = {}
build_adder(correct_gates, 44) # build working 44 bit adder for comparison

known_swaps = []

gates_to_permute = gates.keys.to_set

(0..44).each do |n|
  gate = 'z%02d' % n
  swaps = (known_swaps + known_swaps.map(&:reverse)).to_h
  tested_gates = []
  correct_str = logic_str(correct_gates, gate)
  if logic_str(gates, gate, swaps, tested_gates) != correct_str # logic error found
    gates_to_permute.to_a.permutation(2).each do |gate1, gate2|
      new_swaps = known_swaps + [[gate1, gate2]]
      swaps = (new_swaps + new_swaps.map(&:reverse)).to_h
      tested_gates = []
      begin
        if logic_str(gates, gate, swaps, tested_gates) == correct_str # error fixed
          known_swaps << [gate1, gate2]
          break
        end
      rescue SystemStackError # stuck in a loop. Move on.
      end
    end
  end
  gates_to_permute.subtract(tested_gates)
end

puts known_swaps.flatten.sort.join(',')