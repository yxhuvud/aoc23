require "bit_array"

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

  def neighbours(map, &block)
    case map[x][y]
    when '|'
      up?(map) { |p| yield p }
      down?(map) { |p| yield p }
    when '-'
      right?(map) { |p| yield p }
      left?(map) { |p| yield p }
    when 'F'
      right?(map) { |p| yield p }
      down?(map) { |p| yield p }
    when '7'
      left?(map) { |p| yield p }
      down?(map) { |p| yield p }
    when 'J'
      left?(map) { |p| yield p }
      up?(map) { |p| yield p }
    when 'L'
      right?(map) { |p| yield p }
      up?(map) { |p| yield p }
    when 'S'
      left?(map) { |p| yield p }
      right?(map) { |p| yield p }
      up?(map) { |p| yield p }
      down?(map) { |p| yield p }
    else raise "unreachable"
    end
  end
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
  pos.neighbours(input) do |n|
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
    when 'F', 'L' then bend = current
    when '7'      then in_loop = !in_loop if bend == 'L'
    when 'J'      then in_loop = !in_loop if bend == 'F'
    else               in_loop = !in_loop
    end
    0
  end
end
puts "part2: %s" % sum
