include neverwinter.lru

suite "WeightedLRU":
  var lru: WeightedLRU[string, int]

  setup:
    lru = newWeightedLRU[string, int](6)
    lru["key0", 1] = 0
    lru["key1", 2] = 1
    lru["key2", 3] = 2

  test "old items are bumped off":
    lru["key3"] = 3
    check(lru.len == 3)
    check(not lru["key0"].isSome)

  test "touching items properly reorders":
    discard lru["key1"]
    lru["key3"] = 3
    check(lru.keys[0] == "key3")
    check(lru.keys[1] == "key2")

  test "del() removes properly":
    lru.del("key1")
    check(lru.len == 2)
    check(lru.weight == 4)

  test "clear() clears the cache":
    lru.clear()
    check(lru.len == 0)
    check(lru.keys.len == 0)
    check(lru.weight == 0)

  test "usecount is tracked properly":
    check(lru.uses("key0") == 0)
    discard lru["key0"]
    discard lru["key0"]
    discard lru["key0"]
    check(lru.uses("key0") == 3)

  test "heavyweight will chop from tail":
    lru["key3", 5] = 3
    # This chops from the tail, which has weights 1, 2, 3. To reach 5,
    # we need to lose them all.
    check(lru.weight == 5)

  test "medium weight will chop until fits":
    lru["key3", 3] = 3
    # This will fit 3 + 3; 2 and 1 will be chopped off.
    check(lru.weight == 6)
