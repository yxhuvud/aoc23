def solve(groups, gi1, gi2, nums, ni, cache, left, numsum)
  if v = cache[{gi1, gi2, ni}]?
    return v
  end
  return 1i64 if gi1 == groups.size && nums.size == ni
  return 0i64 if left < numsum
  return 0i64 if gi1 == groups.size

  if nums.size == ni
    any = false
    gi1.to(groups.size - 1).each do |i1|
      s = i1 == gi1 ? gi2 : 0
      s.to(groups[i1].size &- 1).each do |i2|
        any = true if groups[i1][i2] == '#'
        break if any
      end
      break if any
    end
    return any ? 0i64 : 1i64
  end

  count = nums[ni]
  n2 = ni &+ 1
  success = groups[gi1].size &- gi2 >= count
  gi2_consume = gi2 &+ count
  consumed =
    if groups[gi1][gi2_consume]? == '#' || !success
      0i64
    else
      if groups[gi1][gi2_consume &+ 1]?
        left_consume = left &- (count &+ 1)
        gi1_consume = gi1
        gi2_consume &+= 1
      else
        left_consume = left &- count
        gi1_consume = gi1 &+ 1
        gi2_consume = 0
      end
      cache.put_if_absent({gi1_consume, gi2_consume, n2}) {
        solve(groups, gi1_consume, gi2_consume, nums, n2, cache, left_consume, numsum &- count)
      }
    end

  skipped =
    if groups[gi1][gi2]? == '#'
      0i64
    else
      if groups[gi1][gi2 &+ 1]?
        gi2 &+= 1
      else
        gi1 &+= 1
        gi2 = 0
      end

      cache.put_if_absent({gi1, gi2, ni}) {
        solve(groups, gi1, gi2, nums, ni, cache, left &- 1, numsum)
      }
    end

  consumed &+ skipped
end

def solve(springs, cache)
  springs.sum do |groups, nums|
    cache.clear
    left = groups.sum &.size
    solve(groups, 0, 0, nums, 0, cache, left, nums.sum)
  end
end

puts Time.measure {
  input = File.read("input.day12").lines.map &.split

  springs = input.map do |(row, nums)|
    {row.split('.', remove_empty: true), nums.split(',').map(&.to_i)}
  end

  springs2 = input.map do |(row, nums)|
    {([row]*5).join('?').split('.', remove_empty: true),
     nums.split(',').map(&.to_i)*5}
  end

  cache = Hash(Tuple(Int32, Int32, Int32), Int64).new
  puts Time.measure {
    #    p solve(springs, cache)
    p solve(springs2, cache)
  }
}
