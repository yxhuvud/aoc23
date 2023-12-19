require "bit_array"

class HorizonQueue(T)
  def initialize(horizon_width : Int32, current : Int32)
    @current = current
    @size = 0
    @horizon = Deque(Deque(T)).new(horizon_width) { Deque(T).new }
    @bucket_count = horizon_width
  end

  def pull : Tuple(T, Int32)?
    return nil if @size == 0

    @size &-= 1
    until !@horizon[0].empty?
      @current &+= 1
      @horizon.rotate! 1
    end

    {@horizon[0].shift, @current}
  end

  def insert(value : T, prio : Int32)
    @size &+= 1
    offset = prio &- @current
    @horizon[offset].push value
  end
end

enum Direction
  Up
  Down
  Left
  Right
  Start

  def opposite?(other)
    case self
    in Up    then other == Down
    in Down  then other == Up
    in Left  then other == Right
    in Right then other == Left
    in Start then false
    end
  end
end

record(Pos, x : Int32, y : Int32) do
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

  def neighbours
    yield up, Direction::Up
    yield down, Direction::Down
    yield left, Direction::Left
    yield right, Direction::Right
  end

  def key(dir : Direction, count : Int32)
    dir.value &+ 4 &* count &+ 4 &* 1024 &* x &+ 4 &* 1024 &* 256 &* y
  end
end

def solve(input, target)
  cost = 0
  maxx = input.size
  maxy = input[0].size
  start = {Pos.new(0, 0), 0, Direction::Start, 0}
  queue = HorizonQueue(typeof(start)).new(11, 0)
  queue.insert(start, 0)

  seen = BitArray.new(4 * 1024 * 256 * 256) { false }

  while pair = queue.pull
    v, prio = pair
    pos, cost, dir, count = v
    break if pos == target
    pos.neighbours do |p, dir2|
      count2 = dir == dir2 ? count &+ 1 : 1

      next if dir.opposite?(dir2)
      next if yield(count, count2, dir, dir2)
      next unless 0 <= p.x < maxx && 0 <= p.y < maxy

      key = p.key(dir2, count2)
      next if seen[key]

      seen[key] = true

      new_cost = cost &+ input[p.x][p.y]
      queue.insert({p, new_cost, dir2, count2}, new_cost)
    end
  end
  cost
end

input = File.read("input.day17").lines.map &.chars.map(&.to_i)
target = Pos.new(input.size - 1, input[0].size - 1)
puts "part1: %s" % solve(input, target) { |_, count2, _, _| count2 > 3 }
puts "part2: %s" % solve(input, target) { |count, count2, dir, dir2| !(count > 3 || dir == dir2 || dir == Direction::Start) || count2 > 10 }
