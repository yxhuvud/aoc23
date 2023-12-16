def solve(springs, cache)
  springs.sum do |groups, nums|
    cache.clear
    left = groups.sum &.size
    solve(groups, nums, cache, 0, 0, 0, left, nums.sum)
  end
end

def solve(groups, nums, cache, gi1, gi2, ni, left, numsum)
  cache.put_if_absent({gi1, gi2, ni}) do
    return 1i64 if gi1 == groups.size && nums.size == ni
    return 0i64 if left < numsum
    return 0i64 if gi1 == groups.size
    return hashleft(groups, gi1, gi2) if nums.size == ni

    solve_consume(groups, nums, cache, gi1, gi2, ni, left, numsum) &+
      solve_skip(groups, nums, cache, gi1, gi2, ni, left, numsum)
  end
end

def hashleft(groups, gi1, gi2)
  gi1.to(groups.size - 1).each do |i1|
    s = i1 == gi1 ? gi2 : 0
    s.to(groups[i1].size &- 1).each do |i2|
      return 0i64 if groups[i1][i2] == '#'
    end
  end

  return 1i64
end

def solve_consume(groups, nums, cache, gi1, gi2, ni, left, numsum)
  count = nums[ni]
  ni = ni &+ 1
  gi2 = gi2 &+ count
  return 0i64 if groups[gi1][gi2]? == '#' || groups[gi1].size &- gi2 < 0

  if groups[gi1][gi2 &+ 1]?
    left &-= count &+ 1
    gi2 &+= 1
  else
    left &-= count
    gi1 = gi1 &+ 1
    gi2 = 0
  end
  solve(groups, nums, cache, gi1, gi2, ni, left, numsum &- count)
end

def solve_skip(groups, nums, cache, gi1, gi2, ni, left, numsum)
  return 0i64 if groups[gi1][gi2]? == '#'

  if groups[gi1][gi2 &+ 1]?
    gi2 &+= 1
  else
    gi1 &+= 1
    gi2 = 0
  end
  solve(groups, nums, cache, gi1, gi2, ni, left &- 1, numsum)
end

input = File.read("input.day12").lines.map &.split

springs = input.map do |(row, nums)|
  {row.split('.', remove_empty: true), nums.split(',').map(&.to_i)}
end

springs2 = input.map do |(row, nums)|
  {([row]*5).join('?').split('.', remove_empty: true),
   nums.split(',').map(&.to_i)*5}
end

cache = Hash(Tuple(Int32, Int32, Int32), Int64).new
puts "part1: %s" % solve(springs, cache)
puts "part2: %s" % solve(springs2, cache)
