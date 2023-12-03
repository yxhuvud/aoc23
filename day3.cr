def check(pos, v, symbols, connectors)
  if symbols.includes?(pos)
    connectors[pos] ||= [] of Int32
    connectors[pos] << v
    true
  end
end

def row_check(x, y, size, v, symbols, connectors)
  ((y - 1)..(y + size)).each do |y|
    if check({x - 1, y}, v, symbols, connectors) || check({x + 1, y}, v, symbols, connectors)
      return true
    end
  end
end

def read_number(seen, pos, char, numbers)
  x, y = pos
  v = char.to_i
  size = 1
  while c = numbers[{x, y + 1}]?
    size += 1
    y += 1
    v *= 10
    v += c.to_i
    seen << {x, y}
  end
  {v, size}
end

numbers = Hash(Tuple(Int32, Int32), Char).new
symbols = Set(Tuple(Int32, Int32)).new
File.read("input.day3").each_line.with_index do |line, i|
  line.each_char.with_index do |c, j|
    if c == '.'
    elsif c.number?
      numbers[{i, j}] = c
    else
      symbols << {i, j}
    end
  end
end

connectors = Hash(Tuple(Int32, Int32), Array(Int32)).new
seen = Set(Tuple(Int32, Int32)).new

numbers.each do |pos, char|
  next if seen.includes?(pos)

  v, size = read_number(seen, pos, char, numbers)
  x, y = pos
  row_check(x, y, size, v, symbols, connectors) ||
    check({x, y - 1}, v, symbols, connectors) ||
    check({x, y + size}, v, symbols, connectors)
end

puts "part1: %s" % connectors.sum &.last.sum
puts "part2: %s" % connectors.sum { |_, v| v.size == 2 ? v.product : 0 }
