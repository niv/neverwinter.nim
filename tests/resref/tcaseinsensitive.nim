include neverwinter/resref

let a = newResRef("Hello", 1.ResType)
let b = newResRef("hello", 1.ResType)

doAssert a == b
