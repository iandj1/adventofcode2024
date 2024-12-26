input = File.open("inputs/22-sample.txt")
input = File.open("inputs/22.txt")

secrets = []

input.each do |line|
  secrets << line.strip.to_i
end

def evolve(secret)
  secret = ((secret * 64) ^ secret) % 16777216
  secret = ((secret / 32) ^ secret) % 16777216
  secret = ((secret * 2048) ^ secret) % 16777216
end

prices = []
deltas = []

# calculate prices, deltas, and part 1 answer
total = secrets.sum do |secret|
  prices << [secret % 10]
  deltas << []
  2000.times do
    secret = evolve(secret)
    deltas.last << (secret % 10 - prices.last.last)
    prices.last << secret % 10
  end
  secret
end
puts total # part 1

# part 2
delta_prices = Hash.new(0)
deltas.each_with_index do |price_deltas, monkey_no|
  seen_delta_chains = Set.new
  price_deltas.each_cons(4).with_index do |delta_chain, index|
    if seen_delta_chains.add? delta_chain
      delta_prices[delta_chain] += prices[monkey_no][index+4]
    end
  end
end

puts delta_prices.values.max