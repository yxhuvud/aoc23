require "bit_array"

def neighbours(pos, map, dir)
  case dir
  when '|'
    pos.up?(map) { |p| yield p }
    pos.down?(map) { |p| yield p }
  when '-'
    pos.right?(map) { |p| yield p }
    pos.left?(map) { |p| yield p }
  when 'F'
    pos.right?(map) { |p| yield p }
    pos.down?(map) { |p| yield p }
  when '7'
    pos.left?(map) { |p| yield p }
    pos.down?(map) { |p| yield p }
  when 'J'
    pos.left?(map) { |p| yield p }
    pos.up?(map) { |p| yield p }
  when 'L'
    pos.right?(map) { |p| yield p }
    pos.up?(map) { |p| yield p }
  when 'S'
    pos.left?(map) { |p| yield p }
    pos.right?(map) { |p| yield p }
    pos.up?(map) { |p| yield p }
    pos.down?(map) { |p| yield p }
  else raise "unreachable"
  end
end

record(Pos, x : Int32, y : Int32) do
  macro dir(name, x, y, includes)
    def {{name}}?(map)
      yield Pos.new({{x}},{{ y }}) if {{ includes }}.includes?(map[{{x}}][{{y}}])
    end
  end

  dir(left, x, y - 1, {'-', 'F', 'L'})
  dir(right, x, y + 1, {'-', 'J', '7'})
  dir(up, x - 1, y, {'|', 'F', '7'})
  dir(down, x + 1, y, {'|', 'J', 'L'})
end

input = File.read("input.day10").lines

start = Pos.new(0, 0)
input.each_with_index do |line, i|
  j = line.each_char.index('S')
  start = Pos.new(i, j) if j
end

queue = Deque{ {start, 0} }
pipe_loop = Array(BitArray).new(input.size) { BitArray.new(input[0].size) }
furthest = 0

while node = queue.shift?
  pos, steps = node
  pipe_loop[pos.x][pos.y] = true
  furthest = steps
  neighbours(pos, input, input[pos.x][pos.y]) do |n|
    queue << {n, steps + 1} unless pipe_loop[n.x][n.y]
  end
end

puts "part1: %s" % furthest

sum = input.size.times.sum do |i|
  in_loop = false
  bend = nil
  input[0].size.times.sum do |j|
    next in_loop ? 1 : 0 unless pipe_loop[i][j]

    current = input[i][j]
    # ugly input dependent hack
    current = bend ? '7' : 'F' if current == 'S'

    case current
    when '-'
    when 'F', 'L'
      bend = current
    when '7'
      in_loop = !in_loop if bend == 'L'
      bend = nil
    when 'J'
      in_loop = !in_loop if bend == 'F'
      bend = nil
    else
      in_loop = !in_loop
    end
    0
  end
end
puts "part2: %s" % sum
