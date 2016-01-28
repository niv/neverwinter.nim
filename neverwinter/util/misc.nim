template expect*(cond: bool, msg: string = "") =
  ## Expect `cond` to be true, otherwise raise a ValueError.
  ## This works analogous to doAssert, except for the error type.

  bind instantiationInfo
  {.line: instantiationInfo().}:
    if not cond:
      raise newException(ValueError, "Expectation failed: " & astToStr(cond) & ' ' & msg)
