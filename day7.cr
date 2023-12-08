record(Card, hand : Tuple(Int8, Int8, Int8, Int8, Int8), rank : Int8, bid : Int32) do
  include Comparable(Card)

  def <=>(other)
    v = rank <=> other.rank
    v == 0 ? hand <=> other.hand : v
  end
end

def rank(hand)
  counts = hand.tally
  if counts[0]? && counts[0] != 5
    joker_count = counts.delete(0).as(Int32)

    joker_improve = counts.max_by(&.last)
    counts[joker_improve[0]] += joker_count
  end

  case counts.values.sort
  when [5]             then 7i8
  when [1, 4]          then 6i8
  when [2, 3]          then 5i8
  when [1, 1, 3]       then 4i8
  when [1, 2, 2]       then 3i8
  when [1, 1, 1, 2]    then 2i8
  when [1, 1, 1, 1, 1] then 1i8
  else                      raise "unreachable"
  end
end

def value(card, joker)
  case card
  when 'T'      then 10i8
  when 'J'      then joker ? 0i8 : 11i8
  when 'Q'      then 12i8
  when 'K'      then 14i8
  when 'A'      then 15i8
  when '2'..'9' then card.to_i8
  else               raise "unrecogized"
  end
end

def read_hands(input, joker)
  input.map do |(grip, bid)|
    hand = {grip[0], grip[1], grip[2], grip[3], grip[4]}
      .map { |c| value(c, joker) }
    Card.new(hand, rank(hand), bid.to_i)
  end
end

def calculate(input, joker)
  ranks = read_hands(input, joker).sort
  ranks.each.with_index.sum { |h, i| h.bid * (i + 1) }
end

input = File.read_lines("input.day7").map &.split
puts "part1: %s" % calculate(input, false)
puts "part1: %s" % calculate(input, true)
