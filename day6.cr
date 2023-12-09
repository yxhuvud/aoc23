def count(time, distance)
  parabola_start = (0..(time//2)).bsearch { |i| (time - i)*i > distance }.not_nil!
  (time - 2*parabola_start) + 1
end

input = File.read("input.day6").lines
times = input.shift.split[1..].map &.to_i
distances = input.shift.split[1..].map &.to_i

time = times.map(&.to_s).join.to_i64
distance = distances.map(&.to_s).join.to_i64

puts "part1: %s" % times.zip(distances).product { |time, distance| count(time, distance) }
puts "part2: %s" % count(time, distance)
