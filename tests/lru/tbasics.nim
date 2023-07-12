include neverwinter/lru

var lru: WeightedLRU[string, int]

proc setup() =
  lru = newWeightedLRU[string, int](6)
  lru["key0", 1] = 0
  lru["key1", 2] = 1
  lru["key2", 3] = 2

block: # old items are bumped off
  setup()
  lru["key3"] = 3
  doAssert lru.len == 3
  doAssert not lru["key0"].isSome

block: # touching items properly reorders
  setup()
  discard lru["key1"]
  lru["key3"] = 3
  doAssert lru.keys[0] == "key3"
  doAssert lru.keys[1] == "key1"
  doAssert lru.keys[2] == "key2"

block: # del() removes properly"
  setup()
  lru.del("key1")
  doAssert lru.len == 2
  doAssert lru.weight == 4

block: # clear() clears the cache
  setup()
  lru.clear()
  doAssert lru.len == 0
  doAssert lru.keys.len == 0
  doAssert lru.weight == 0

block: # usecount is tracked properly
  setup()
  doAssert lru.uses("key0") == 0
  discard lru["key0"]
  discard lru["key0"]
  discard lru["key0"]
  doAssert lru.uses("key0") == 3

block: # heavyweight will chop from tail
  setup()
  lru["key3", 5] = 3
  # This chops from the tail, which has weights 1, 2, 3. To reach 5,
  # we need to lose them all.
  doAssert lru.weight == 5

block: # medium weight will chop until fits
  setup()
  lru["key3", 3] = 3
  # This will fit 3 + 3; 2 and 1 will be chopped off.
  doAssert lru.weight == 6
