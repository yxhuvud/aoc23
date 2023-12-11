def expansion(values, empty)
  empty.sum do |v|
    i = values.bsearch_index(&.>(v)).not_nil!
    i*(values.size - i)
  end
end

xs = Array(Int32).new
ys = Array(Int32).new
empty_rows = Array(Int32).new

input = File.read_lines("input.day11").map &.chars
input.each_with_index do |line, i|
  stars = false
  line.each_with_index do |c, j|
    if '#' == c
      xs << i
      ys << j
      stars = true
    end
  end
  empty_rows << i unless stars
end
ys.sort!
empty_cols = input[0].size.times.select { |j| !input.find &.[j].==('#') }

dx = xs.each_with_index.sum { |x, i| x * (2 * i - (xs.size - 1)) }
dy = ys.each_with_index.sum { |y, i| y * (2 * i - (ys.size - 1)) }
exp_x = expansion(xs, empty_rows)
exp_y = expansion(ys, empty_cols)

puts "part1: %s" % (dx + dy + exp_x + exp_y)
puts "part2: %s" % (dx.to_i64 + dy + (exp_x.to_i64 + exp_y) * 999999)
