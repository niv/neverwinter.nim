import lists, tables, options, strutils

## This is a weighted LRU cache. It works just like a regular, plain
## LRU cache, except you can specify the weight of each item manually.
## Weight-tracking works well if you have many items much smaller than your total
## cache weight; it will not work if you have items large enough to saturate the
## cache. The code will echo warnings about this if compiled in debug mode.
## The cache is *not* threadsafe.
##
## This library uses it for the in-memory resman cache, where the weight is equivalent
## to the memory use of the res.

type
  WeightedLRU*[K,V] = ref WeightedLRUImpl[K,V]

  Weight = int

  Pair[K,V] = tuple
    key: K
    value: V
    weight: Weight
    usecount: int

  WeightedLRUImpl[K,V] = object
    minSize: int
    maxWeight: Weight
    currentWeight: Weight

    # the list tracks keys and determines evicition priority
    cachelist: DoublyLinkedList[Pair[K, V]] # 0 = most recently used

    # the map contains key -> node mappings.
    cachemap: Table[K, DoublyLinkedNode[Pair[K, V]]]

proc newWeightedLRU*[K,V](maxWeight: Weight, minSize = 1): WeightedLRU[K,V] =
  doAssert(maxWeight > 0, "maxWeight must be a positive integer")
  doAssert(minSize >= 0, "minSize must be >= 0")

  new(result)
  result.minSize = minSize
  result.maxWeight = maxWeight
  result.currentWeight = 0
  result.cachelist = initDoublyLinkedList[Pair[K, V]]()
  result.cachemap = initTable[K,DoublyLinkedNode[Pair[K, V]]]()

proc hasKey*[K,V](self: WeightedLRU[K,V], key: K): bool =
  ## Will return true if this cache has the given key stored.
  self.cacheMap.hasKey(key)

proc `[]`*[K,V](self: WeightedLRU[K,V], key: K): Option[V] =
  ## Retrieves a value from the cache. Will return none if not in cache.
  if self.cachemap.hasKey(key):
    let node = self.cachemap[key]
    result = some(node.value.value)
    node.value.usecount += 1
    # move ourselves in first position because we were touched!
    self.cachelist.remove(node)
    self.cachelist.prepend(node)

proc len*[K,V](self: WeightedLRU[K,V]): int =
  ## Returns the total item count.
  self.cachemap.len

proc weight*[K,V](self: WeightedLRU[K,V]): Weight =
  ## Returns the total weight.
  self.currentWeight

proc clear*[K,V](self: WeightedLRU[K,V]) =
  ## Clears this cache.
  self.cachemap.clear()
  self.cachelist.head = nil
  self.cachelist.tail = nil
  self.currentWeight = 0

proc del*[K,V](self: WeightedLRU[K,V], key: K) =
  ## Explicitly remove a value from the WeightedLRU cache.
  if self.cachemap.hasKey(key):
    let node = self.cachemap[key]
    self.cachelist.remove(node)
    self.cachemap.del(key)
    self.currentWeight -= node.value.weight
    assert(self.currentWeight >= 0)

proc `[]=`*[K,V](self: WeightedLRU[K,V], key: K, value: V) =
  ## Stores a key with a default weight of 1.
  self[key, 1] = value

proc `[]=`*[K,V](self: WeightedLRU[K,V], key: K, weight: Weight, value: V) =
  ## Stores a key with a specific weight.
  when not defined(release):
    if (weight.float >= (self.maxWeight.float * 0.6)):
      echo "debug warning: WeightedLRU key [" & repr(key) &
        "] has 2/3rds of max cache weight; this would saturate the cache. " &
        "Consider increasing maxWeight."

  if self.cachemap.hasKey(key):
    let oldnode = self.cachemap[key]
    self.currentWeight -= oldnode.value.weight
    oldnode.value.value = value
    oldnode.value.weight = weight
    self.currentWeight += oldnode.value.weight

  else:
    let newnode = newDoublyLinkedNode[Pair[K, V]]((
      key: key,
      value: value,
      weight: weight,
      usecount: 0))
    self.cachelist.prepend(newnode)
    self.cachemap[key] = newnode
    self.currentWeight += weight

  while self.len > self.minSize and self.currentWeight > self.maxWeight:
    # chop off tails until we have our preferred weight again, but only up to minSize.
    let node = self.cachelist.tail
    self.cachelist.remove(node)
    self.cachemap.del(node.value.key)
    self.currentWeight -= node.value.weight
    assert(self.currentWeight >= 0)

proc keys*[K,V](self: WeightedLRU[K,V]): seq[K] =
  ## Returns a seq of keys stored in this cache. Ordering is not guaranteed.
  result = newSeq[K]()
  for k in tables.keys(self.cachemap): result.add(k)

proc uses*[K,V](self: WeightedLRU[K,V], key: K): int =
  ## Returns how often the key in question was queried. Returns 0 for keys
  ## not in the cache.
  if self.cachemap.hasKey(key): result = self.cachemap[key].value.usecount

proc `$`*[K,V](self: WeightedLRU[K,V]): string =
  "<WeightedLRU weight=" & $self.weight & "/" & $self.maxWeight &
    " len=" & $self.len & ">"

when isMainModule:
  import unittest

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
