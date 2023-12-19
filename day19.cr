def match?(item, flows, current : String)
  return true if current == "A"
  return false if current == "R"

  rules, fallback = flows[current]
  rules.each do |rule|
    if (rule.op == '>' && item[rule.key] > rule.value) || (rule.op == '<' && item[rule.key] < rule.value)
      return match?(item, flows, rule.dest)
    end
  end
  match?(item, flows, fallback)
end

def match(flows, x, m, a, s, current)
  return {x, m, a, s}.product &.size.to_i64 if current == "A"
  return 0 if current == "R"

  rules, fallback = flows[current]
  rules.sum(0i64) do |rule|
    if rule.op == '>'
      case rule.key
      when 'x' then match(flows, (rule.value + 1)..x.end, m, a, s, rule.dest).tap { x = x.begin..(rule.value) }
      when 'm' then match(flows, x, (rule.value + 1)..m.end, a, s, rule.dest).tap { m = m.begin..(rule.value) }
      when 'a' then match(flows, x, m, (rule.value + 1)..a.end, s, rule.dest).tap { a = a.begin..(rule.value) }
      when 's' then match(flows, x, m, a, (rule.value + 1)..s.end, rule.dest).tap { s = s.begin..(rule.value) }
      else          raise "wtf"
      end
    else
      case rule.key
      when 'x' then match(flows, x.begin..(rule.value - 1), m, a, s, rule.dest).tap { x = rule.value..x.end }
      when 'm' then match(flows, x, m.begin..(rule.value - 1), a, s, rule.dest).tap { m = rule.value..m.end }
      when 'a' then match(flows, x, m, a.begin..(rule.value - 1), s, rule.dest).tap { a = rule.value..a.end }
      when 's' then match(flows, x, m, a, s.begin..(rule.value - 1), rule.dest).tap { s = rule.value..s.end }
      else          raise "wtf"
      end
    end
  end + match(flows, x, m, a, s, fallback)
end

record(Flow, key : Char, op : Char, value : Int32, dest : String)

lines = File.read("input.day19").lines

flows = Hash(String, Tuple(Array(Flow), String)).new
while (line = lines.shift?) && !line.empty?
  name, *list = line.split(/[{,:}]/, remove_empty: true)
  fallback = list.pop
  items = list.each_slice(2, reuse: true).map do |(condition, target)|
    Flow.new(condition[0], condition[1], condition[2..].to_i, target)
  end
  flows[name] = {items.to_a, fallback}
end

items = lines.map do |line|
  line.split(/[{,=}]/, remove_empty: true).each_slice(2, reuse: true).to_h do |(k, v)|
    {k[0], v.to_i}.as(Tuple(Char, Int32))
  end
end

puts "part1: %s" % items.sum { |item| match?(item, flows, "in") ? item.values.sum(0) : 0 }
puts "part2: %s" % match(flows, 1..4000, 1..4000, 1..4000, 1..4000, "in")
