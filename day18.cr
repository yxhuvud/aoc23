record(Pos, x : Int32, y : Int32) do
  def up(n = 1)
    Pos.new(x &- n, y)
  end

  def down(n = 1)
    Pos.new(x &+ n, y)
  end

  def left(n = 1)
    Pos.new(x, y &- n)
  end

  def right(n = 1)
    Pos.new(x, y &+ n)
  end
end

def area(corners)
  corners = corners << corners.first
  inside_area = corners.each_cons_pair
    .sum(0i64) { |(a, b)| a.x.to_i64 * b.y - a.y.to_i64 * b.x }
    .abs // 2
  sides = corners.each_cons(2).sum { |(p, p1)| (p.x - p1.x).abs + ((p.y - p1.y).abs) }
  inside_area + sides // 2 + 1
end

def corners(input)
  pos = Pos.new(0, 0)
  input.lines.map do |row|
    dir, steps = yield(row.split)
    pos =
      case dir
      when '0', "R" then pos.right(steps)
      when '1', "D" then pos.down(steps)
      when '2', "L" then pos.left(steps)
      when '3', "U" then pos.up(steps)
      else               raise "whuh"
      end
  end
end

input = File.read("input.day18")
puts "part1: %s" % area(corners(input) { |(dir, steps, color)| {dir, steps.to_i} })
puts "part2: %s" % area(corners(input) { |(_, _, hex)| {hex[7], hex[2..6].to_i(16)} })
