input = File.read("input.day4").lines
cards = input.map &.split(':', 2)[1].split('|').map &.split
matches = cards.map { |card| (card[0] & card[1]).size }

sums = matches.sum { |card| card.zero? ? 0 : (2 ** (card - 1)) }
puts "part1: %s" % sums

counts = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
val = matches.sum do |c|
  v = counts.shift
  c.times { |i| counts[i] += v }
  counts << 1
  v
end

puts "part2: %s" % val
