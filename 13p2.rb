input = File.open("inputs/13-sample.txt")
input = File.open("inputs/13.txt")

machines = []

loop do
  begin
    machine = {}
    machine[:A] = input.readline.scan(/\d+/).map(&:to_i)
    machine[:B] = input.readline.scan(/\d+/).map(&:to_i)
    machine[:prize] = input.readline.scan(/\d+/).map{|x| x.to_i + 10000000000000}
    machines << machine
    input.readline
  rescue EOFError
    break
  end
end

total = 0
machines.each_with_index do |machine|
  ax = machine[:A][0]
  ay = machine[:A][1]
  bx = machine[:B][0]
  by = machine[:B][1]
  px = machine[:prize][0]
  py = machine[:prize][1]

  b = (ax*py - ay*px).to_f / (ax*by - ay*bx)
  a = (px - b*bx) / ax

  if a == a.to_i && b == b.to_i
    total += a.to_i*3 + b.to_i
  end
end
puts total
