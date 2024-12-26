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

delta_prices = Hash.new(0)

total = secrets.sum do |secret|
  last3, last2, last1, prev = nil
  seen_chains = Set.new
  2000.times do
    secret = evolve(secret)
    price = secret % 10
    delta = price - prev unless prev.nil?
    chain = [last3, last2, last1, delta]
    if !chain.include?(nil) && seen_chains.add?(chain)
      delta_prices[chain] += price
    end
    last3, last2, last1 = last2, last1, delta
    prev = price
  end
  secret
end
puts total # part 1
puts delta_prices.values.max # part 2