require "bit_array"

enum Direction
  Up
  Down
  Left
  Right
end

record(Pos, x : Int32, y : Int32) do
  def go(dir : Direction)
    case dir
    in Direction::Up    then up
    in Direction::Down  then down
    in Direction::Left  then left
    in Direction::Right then right
    end
  end

  def up
    Pos.new(x &- 1, y)
  end

  def down
    Pos.new(x &+ 1, y)
  end

  def left
    Pos.new(x, y &- 1)
  end

  def right
    Pos.new(x, y &+ 1)
  end

  def idx(input)
    input.size &* x &+ y
  end
end

def line(input, visited, pos, dir : Direction)
  return unless 0 <= pos.x < input.size && 0 <= pos.y < input[0].size

  idx = pos.idx(input)
  return if visited[dir.value][idx]
  visited[dir.value][idx] = true

  case c = input[pos.x][pos.y]
  when '.'
    line(input, visited, pos.go(dir), dir)
  when '|'
    if dir.left? || dir.right?
      line(input, visited, pos.up, :up)
      line(input, visited, pos.down, :down)
    else
      line(input, visited, pos.go(dir), dir)
    end
  when '-'
    if dir.left? || dir.right?
      line(input, visited, pos.go(dir), dir)
    else
      line(input, visited, pos.left, :left)
      line(input, visited, pos.right, :right)
    end
  when '\\'
    case dir
    in .down?  then line(input, visited, pos.right, :right)
    in .up?    then line(input, visited, pos.left, :left)
    in .right? then line(input, visited, pos.down, :down)
    in .left?  then line(input, visited, pos.up, :up)
    end
  when '/'
    case dir
    in .down?  then line(input, visited, pos.left, :left)
    in .up?    then line(input, visited, pos.right, :right)
    in .right? then line(input, visited, pos.up, :up)
    in .left?  then line(input, visited, pos.down, :down)
    end
  else
    raise "no: #{c}"
  end
end

def solve(input, x, y, dir : Direction)
  visited = Array(BitArray).new
  Direction.each do
    visited << BitArray.new(size: input.size * input[0].size, initial: false)
  end

  line(input, visited, Pos.new(x, y), dir)
  visited.reduce { |agg, b| agg.map_with_index! { |v, i| v | b[i] } }
    .count(true)
end

input = File.read("input.day16").lines.map &.chars

puts "part1: %s" % solve(input, 0, 0, :right)
puts "part2: %s" % {
  0.to(input.size - 1).max_of { |i| solve(input, i, 0, :right) },
  0.to(input.size - 1).max_of { |i| solve(input, i, input[0].size - 1, :left) },
  0.to(input[0].size - 1).max_of { |i| solve(input, 0, i, :down) },
  0.to(input[0].size - 1).max_of { |i| solve(input, input.size - 1, i, :up) },
}.max
