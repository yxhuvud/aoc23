input = File.read("input.day4").lines
card_numbers = input.map &.partition(':')[2].split('|').map &.split
matches = card_numbers.map { |numbers| (numbers[0] & numbers[1]).size }

puts "part1: %s" % matches.sum { |count| 1 << (count - 1) }

counts = Array.new(matches.size, 1)
val = matches.sum do |c|
  v = counts.shift
  c.times { |i| counts[i] += v }
  v
end

puts "part2: %s" % val
