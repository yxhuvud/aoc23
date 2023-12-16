def north(map)
  map.each_with_index do |row, x|
    row.each_index do |y|
      next unless row[y] == 'O'
      i = x
      while i > 0 && map[i &- 1][y] == '.'
        i &-= 1
      end
      map[x][y] = '.'
      map[i][y] = 'O'
    end
  end
end

def south(map)
  (map.size &- 1).to(0) do |x|
    row = map[x]
    row.each_index do |y|
      next unless row[y] == 'O'
      i = x
      while i < map.size &- 1 && map[i &+ 1][y] == '.'
        i &+= 1
      end
      map[x][y] = '.'
      map[i][y] = 'O'
    end
  end
end

def west(map)
  map.each_with_index do |row, x|
    row.each_index do |y|
      next unless row[y] == 'O'
      j = y
      while j > 0 && row[j &- 1] == '.'
        j &-= 1
      end
      row[y] = '.'
      row[j] = 'O'
    end
  end
end

def east(map)
  map.each_index do |x|
    row = map[x]
    (row.size &- 1).to(0) do |y|
      next unless row[y] == 'O'
      j = y
      while j < (row.size &- 1) && row[j &+ 1] == '.'
        j &+= 1
      end
      row[y] = '.'
      row[j] = 'O'
    end
  end
end

def count(map)
  size = map.size
  s = map.each.with_index.sum do |row, index|
    (size &- index) * row.count('O')
  end
end

def iteration(map)
  north(map)
  west(map)
  south(map)
  east(map)
  hash = map.hash
end

def find(map, seen)
  (1..).each do |i|
    hash = iteration(map)
    if v = seen.index &.first.==(hash)
      return {v + 1, i}
    end
    seen << {hash, count(map)}
  end
end

input = File.read("input.day14").lines
map = input.each.map { |row| Array.new(row.size) { |i| row[i] } }.to_a
north(map)
puts "part1: %s" % count(map)

seen = Array(Tuple(UInt64, Int32)).new
prefix, last = find(map, seen)
period = last - prefix
iterations = (1000000000 - prefix).remainder(period)

puts "part2: %s" % seen[prefix + iterations - 1].last
