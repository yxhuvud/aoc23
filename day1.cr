MAPPING   = %w[one two three four five six seven eight nine].each.with_index.to_h { |string, index| {string, (index + 1).to_s} }
FORWARDS  = /(one|two|three|four|five|six|seven|eight|nine|\d)(?:.*)/
BACKWARDS = /(?:.*)(one|two|three|four|five|six|seven|eight|nine|\d)/

def calc(input, forwards, backwards)
  input.sum { |line| (lookup(line, forwards) + lookup(line, backwards)).to_i }
end

def lookup(line, regexp)
  MAPPING.fetch(line.match!(regexp)[1]) { |f| f }
end

input = File.read("input.day1").lines
puts "part1: %s" % calc(input, /(\d)(?:.*)/, /(?:.*)(\d)/)
puts "part2: %s" % calc(input, FORWARDS, BACKWARDS)
