// * Anvil gets smacked around by blacksmiths
#include "x2_am_inc"

void main()
{
    // * Simulate 'use-me' with just a random number
    if (Random(100) > 35)
    {
        SetPlotFlag(OBJECT_SELF, TRUE);
        Request(TASK_WORK_ANVIL, 9.0, 0.5, OBJECT_SELF);
    }
}
