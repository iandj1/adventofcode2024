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
puts total

delta_chains = Set.new
delta_chain_per_monkey = []

# build lookup of delta chains to speed up processing
deltas.each do |price_deltas|
  delta_hash = {}
  price_deltas.each_cons(4).with_index do |delta_chain, index|
    delta_chains << delta_chain
    delta_hash[delta_chain] ||= index
  end
  delta_chain_per_monkey << delta_hash
end

best = 0

# find delta chain to purchase banans
delta_chains.each do |delta_chain|
  sum = 0
  delta_chain_per_monkey.each_with_index do |delta_hash, monkey_no|
    earliest_index = delta_hash[delta_chain]
    next if earliest_index.nil?
    sum += prices[monkey_no][earliest_index+4] # offset by 4 to get price at end of delta
  end
  best = [best, sum].max
end
puts best