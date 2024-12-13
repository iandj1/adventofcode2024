input = File.open("inputs/13-sample.txt")
input = File.open("inputs/13.txt")

machines = []

loop do
  begin
    machine = {}
    machine[:A] = input.readline.scan(/\d+/).map(&:to_i)
    machine[:B] = input.readline.scan(/\d+/).map(&:to_i)
    machine[:prize] = input.readline.scan(/\d+/).map(&:to_i)
    machines << machine
    input.readline
  rescue EOFError
    break
  end
end

total = 0
machines.each do |machine|
  cheapest = nil
  (0..100).each do |a_count|
    (0..100).each do |b_count|
      if a_count * machine[:A][0] + b_count * machine[:B][0] == machine[:prize][0] &&
         a_count * machine[:A][1] + b_count * machine[:B][1] == machine[:prize][1]

         cost = 3*a_count + b_count
         cheapest ||= cost
         cheapest = [cheapest, cost].min
      end
    end
  end
  total += cheapest if cheapest
end
puts total
