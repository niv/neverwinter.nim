// A declaration returning a value with an implementation returning nothing is
// accepted, with a warning. This is the shape the shipped game scripts use
// (x2_inc_cutscene.nss: CutCreateObjectCopy, x0_inc_skills.nss:
// skillCTRAPSetCurrentTrapView), and rejecting it broke real modules
// (issue #157).
//
// It is accepted because the canonical declaration makes every call site
// reserve a return slot; the implementation simply never fills it. The stack
// therefore stays balanced and the caller reads a stale value. The opposite
// mismatch is rejected (see neg_funcimpl_ret.nss).
//
// This file must also *run*: truntestvm executes it and a stack imbalance
// would show up as a VM failure.

object some_function();

void some_function()
{
}

void main()
{
    object oFirst = some_function();
    object oSecond = some_function();

    Assert(oFirst == oSecond, "stale return values are at least consistent");
}
