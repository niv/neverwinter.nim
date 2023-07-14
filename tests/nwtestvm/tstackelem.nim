import neverwinter/nwscript/nwtestvm

doAssert StackElem(kind: skInt, intVal: 1) == StackElem(kind: skInt, intVal: 1)
doAssert StackElem(kind: skInt, intVal: 1) != StackElem(kind: skInt, intVal: 2)
doAssert StackElem(kind: skString, stringVal: "1") != StackElem(kind: skInt, intVal: 2)
