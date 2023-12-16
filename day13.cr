def horizontal(group, index, range)
  range.times.sum do |row_i|
    g1 = group[index + row_i]
    g2 = group[index - row_i - 1]
    cs = group[0].size.times.count { |col| g1[col] != g2[col] }
    cs > 1 ? return(cs) : cs # shortcut
  end
end

def vertical(group, index, range)
  range.times.sum do |col_i|
    cs = group.count { |row| row[index + col_i] != row[index - col_i - 1] }
    cs > 1 ? return(cs) : cs # shortcut
  end
end

def eval(size, smudges)
  (1..(size - 1)).find(if_none: 0) do |c|
    yield(c, {size - c, c}.min) == smudges
  end
end

def find_best(groups, smudges)
  groups.sum do |group|
    100 * eval(group.size, smudges) { |c, range| horizontal(group, c, range) } +
      eval(group[0].size, smudges) { |c, range| vertical(group, c, range) }
  end
end

input = File.read("input.day13").lines
group = Array(String).new
groups = Array{group}

while line = input.shift?
  if line.empty?
    group = Array(String).new
    groups << group
  else
    group << line
  end
end

puts "part1: %s" % find_best(groups, 0)
puts "part2: %s" % find_best(groups, 1)
