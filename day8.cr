def find(node, lrs, mapping)
  1 + lrs.cycle.index! do |lr|
    current = node.entries[lr]
    node = mapping[current]
    node.z
  end
end

record(Node, entries : Tuple(Int32, Int32), a : Bool, z : Bool)

input = File.read_lines("input.day8")
lrs = input.shift.each_char.map { |c| c == 'L' ? 0 : 1 }.to_a
input.shift

triples = input.map { |line| {line[0..2], line[7..9], line[12..14]} }.sort
lookup = triples.each.with_index.to_h { |v, i| {v.first, i} }
mapping = triples.map do |(key, left, right)|
  Node.new({lookup[left], lookup[right]}, key[2] == 'A', key[2] == 'Z')
end
steps = mapping.compact_map { |entry| entry.a ? find(entry, lrs, mapping) : nil }

puts "part1: %s" % steps.first
puts "part2: %s" % steps.reduce(1i64) { |agg, steps| agg.lcm(steps) }
