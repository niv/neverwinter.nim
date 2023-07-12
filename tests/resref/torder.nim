
include neverwinter/resref

let a = newResRef("Hello", 1.ResType)
let b = newResRef("hello", 1.ResType)
let c = newResRef("hello", 2.ResType)

# expect lowercase to sort first
doAssert b > a

# expect higher restypes to sort later
doAssert c > b
