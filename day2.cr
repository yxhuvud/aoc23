input =
  File
    .read("input.day2")
    .lines
    .map &.split(':')[1]
      .split(';')
      .map &.split(',')
        .map(&.split)
        .to_h { |(counts, color)| {color, counts.to_i} }

matches = input.each.with_index.sum do |row, index|
  matching = row.all? do |hsh|
    ((hsh["red"]? || 0) <= 12) &&
      ((hsh["green"]? || 0) <= 13) &&
      ((hsh["blue"]? || 0) <= 14)
  end
  matching ? index + 1 : 0
end

powers = input.sum do |row|
  row.reduce { |acc, val| acc.merge!(val) { |_, v1, v2| {v1, v2}.max } }
    .product &.last
end

puts "part1: %s" % matches
puts "part2: %s" % powers
