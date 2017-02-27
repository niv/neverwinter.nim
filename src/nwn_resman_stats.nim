import shared, math

let Args = DOC """
This utility gives you a detailed view into what your resman stack looks like.

It prints:
 * The size/contents of each indiced container.
 * Total/accumulative stats.
 * How much shadowing is happening.

Shadowing lists files in a particular container that are hidden by files in
later containers (i.e. updates to files or duplicates).  Duplicates are not
advertised separately at this point.

Usage:
  $0 [options]

Options:
  -d                          More details
  -D                          Moaaaaaar details
  $OPTRESMAN
"""

let rm = newBasicResMan()

let detailLevel = if Args["-d"]: 1 elif Args["-D"]: 2 else: 0

type StatsForContainer = tuple
  container: ResContainer
  resTypes: CountTableRef[ResType]
  resSizes: TableRef[ResType, int64]
  # resRefs: seq[ResRef]
  resCount: int64
  resTotalSize: int64

  resShadowedTypes: CountTableRef[ResType]
  resShadowedSizes: TableRef[ResType, int64]
  resShadowedByContIdx: CountTableRef[int]
  resShadowedCount: int64 # num resrefs shadowed by later containers
  resShadowedTotalSize: int64  # bytes shadowed by later containers

proc newStatsForContainer(): StatsForContainer =
  result.resTypes = newCountTable[ResType]()
  result.resSizes = newTable[ResType, int64]()
  result.resShadowedTypes = newCountTable[ResType]()
  result.resShadowedSizes = newTable[ResType, int64]()
  result.resShadowedByContIdx = newCountTable[int]()

proc `+`(a, b: StatsForContainer): StatsForContainer =
  result = newStatsForContainer()

  if a.resTypes != nil: result.resTypes.merge(a.resTypes)
  if b.resTypes != nil: result.resTypes.merge(b.resTypes)
  if a.resShadowedTypes != nil: result.resShadowedTypes.merge(a.resShadowedTypes)
  if b.resShadowedTypes != nil: result.resShadowedTypes.merge(b.resShadowedTypes)

  if a.resShadowedSizes != nil:
    for k, v in a.resShadowedSizes:
      result.resShadowedSizes[k] = result.resShadowedSizes.getOrDefault(k) +
        a.resShadowedSizes.getOrDefault(k)

  if b.resShadowedSizes != nil:
    for k, v in b.resShadowedSizes:
      result.resShadowedSizes[k] = result.resShadowedSizes.getOrDefault(k) +
        b.resShadowedSizes.getOrDefault(k)

  if a.resSizes != nil:
    for k, v in a.resSizes:
      if not result.resSizes.hasKey(k): result.resSizes[k] = 0
      result.resSizes[k] += v

  if b.resSizes != nil:
    for k, v in b.resSizes:
      if not result.resSizes.hasKey(k): result.resSizes[k] = 0
      result.resSizes[k] += v

  doAssert(result.resTypes.len == result.resSizes.len)

  result.resCount = a.resCount + b.resCount
  result.resShadowedCount = a.resShadowedCount + b.resShadowedCount
  result.resTotalSize = a.resTotalSize + b.resTotalSize
  result.resShadowedTotalSize = a.resShadowedTotalSize + b.resShadowedTotalSize
  result.resTypes.sort

proc makeStatsForContainer(cont: ResContainer): StatsForContainer =
  let cntIdx = rm.containers.find(cont) ; doAssert(cntIdx != -1)

  result = newStatsForContainer()
  result.container        = cont

  # echo "mkShSt, ouridx=", cntIdx, " high=", rm.containers.high
  for o in cont.contents.withProgressBar($cont & " shadows: "):
    for theirIdx in 0..cntIdx-1:
      let theirCnt = rm.containers[theirIdx]
      doAssert(theirCnt != cont); doAssert(theirIdx != cntIdx)
      if theirCnt.contains(o):
        result.resShadowedByContIdx.inc(theirIdx)
        result.resShadowedTypes.inc(o.resType)
        result.resShadowedCount += 1
        result.resShadowedTotalSize += cont.demand(o).len
        result.resShadowedSizes[o.resType] =
          result.resShadowedSizes.getOrDefault(o.resType) + cont.demand(o).len

  for o in cont.contents.withProgressBar($cont & " contents: "):
    let res = cont.demand(o)
    # result.resRefs.add(o)
    result.resTotalSize += res.len
    result.resTypes.inc(o.resType)
    if not result.resSizes.hasKey(o.resType): result.resSizes[o.resType] = 0
    result.resSizes[o.resType] += res.len

  sort(result.resTypes)
  sort(result.resShadowedTypes)
  sort(result.resShadowedByContIdx)

let stats = rm.containers.reversed.mapIt(it.makeStatsForContainer)

proc printStats(entry: StatsForContainer) =
  const spacings = [10, 10, 15, 10, 15]

  if entry.container != nil:
    echo entry.container
    echo repeat("=", ($entry.container).len)

    if entry.resShadowedTotalSize > 0:
      let shadowPercentage = ((entry.resShadowedTotalSize.float32 /
        entry.resTotalSize.float32) * 100).int

      echo "  ", shadowPercentage, "% of this container is shadowed in:"
      for k, v in entry.resShadowedByContIdx:
        let cntShadowPercentage = ((v.float32 / entry.resShadowedCount.float32) * 100).int
        echo "    ",
             align($cntShadowPercentage, 4), "% ",
             rm.containers[k]

  if detailLevel > 0:
    echo ""
    echo "  ",
         align("restype", spacings[0]), "  ",
         align("count", spacings[1]), "  ",
         align("size", spacings[2]), "  ",
         align("shdcount", spacings[3]), "  ",
         align("shdsize", spacings[4]), "  "

    echo "  ", repeat("-", spacings.sum + spacings.len*2)

  if detailLevel > 1:
    for k, v in entry.resTypes:
      echo "  ",
           align($k, spacings[0]), "  ",
           align($v, spacings[1]), "  ",
           align(entry.resSizes.getOrDefault(k).formatSize, spacings[2]), "  ",
           align($entry.resShadowedTypes.getOrDefault(k), spacings[3]), "  ",
           align(entry.resShadowedSizes.getOrDefault(k).formatSize, spacings[4])
    echo "  ", repeat("-", spacings.sum + spacings.len*2)

  if detailLevel > 0:
    echo "  ",
         align($entry.resTypes.len, spacings[0]), "  ",
         align($entry.resCount, spacings[1]), "  ",
         align(entry.resTotalSize.formatSize, spacings[2]), "  ",
         align($entry.resShadowedCount, spacings[3]), "  ",
         align(entry.resShadowedTotalSize.formatSize, spacings[4])

  if detailLevel > 0:
    echo ""

for entry in stats:
  printStats(entry)

if detailLevel > 1:
  echo "Totals:"
  let st = stats.sum
  printStats(st)
