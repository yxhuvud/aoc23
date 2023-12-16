def hash(str : String)
  current_value = 0u8
  str.each_char do |c|
    current_value &+= c.ord
    current_value &*= 17u8
  end
  current_value
end

input = File.read("input.day15").strip.split(',')
puts "part1: %s" % input.sum(0i32) { |s| hash(s) }

boxes = Array.new(256) { Array(Tuple(String, UInt8)).new }

input.each do |s|
  label, operation, value = s.partition(/[-=]/)
  box = boxes[hash(label)]
  index = box.index &.first.==(label)
  if operation == "="
    if index
      box[index] = {label, value.to_u8}
    else
      box << {label, value.to_u8}
    end
  else
    box.delete_at(index) if index
  end
end
power = boxes.each_with_index.sum { |box, j|
  box.each_with_index.sum { |(_, v2), i| (j + 1)*(i + 1) * v2 }
}
puts "part2: %s" % power
