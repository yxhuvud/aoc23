def calculate(input)
  array_cache = Array(Array(Int32)).new(20) { Array(Int32).new }
  rows = Array(Array(Int32)).new
  input.sum do |line|
    rows << line
    while !line.all?(&.zero?)
      next_row = array_cache.pop
      line.each_cons_pair { |l, r| next_row << (r - l) }
      line = next_row
      rows << line
    end
    yield(rows).tap do
      rows.shift # first line is part of input
      rows.each { |row| array_cache << row.clear }
      rows.clear
    end
  end
end

input = File.read("input.day9").lines.map &.split.map &.to_i
puts "part1: %s" % calculate(input.dup, &.sum(&.last))
puts "part2: %s" % calculate(input, &.reverse_each.reduce(0) { |acc, v| v.first - acc })
