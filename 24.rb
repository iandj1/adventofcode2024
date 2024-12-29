input = File.open("inputs/24-sample.txt")
input = File.open("inputs/24.txt")

wires = {}
all_gates = []

# parse wires
input.each do |line|
  line.strip!
  break if line.empty?
  name, val = line.split(': ')
  wires[name] = val == '1'
end

class Gate
  attr_accessor :in1, :in2, :op, :out

  def initialize(in1, in2, op, out)
    @in1 = in1
    @in2 = in2
    @op = op.to_sym
    @out = out
  end

  def process(in1, in2)
    case op
    when :AND
      in1 && in2
    when :OR
      in1 || in2
    when :XOR
      in1 ^ in2
    end
  end

  def to_s
    "#{@in1} #{@op} #{@in2} -> #{@out}"
  end
end

# parse gates
input.each do |line|
  line = line.strip.split(' ')
  all_gates << Gate.new(line[0], line[2], line[1], line[4])
end


unprocessed_gates = all_gates.dup
until unprocessed_gates.empty?
  unprocessed_gates.each do |gate|
    if wires.key?(gate.in1) && wires.key?(gate.in2)
      result = gate.process(wires[gate.in1], wires[gate.in2])
      wires[gate.out] = result
      unprocessed_gates.delete(gate)
    end
  end
end

puts wires.select{|x| x.start_with? 'z'}.to_a.sort.reverse.map{|x| x[1] ? 1 : 0}.join().to_i(2)