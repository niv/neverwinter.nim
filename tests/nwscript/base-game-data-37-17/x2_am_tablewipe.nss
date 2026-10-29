// * Table looks for a barmaid near it to request a cleaning
#include "x2_am_inc"

void main()
{
    // * Simulate 'dirtiness' with just a random number
    if (Random(100) > 65)
    {
        Request(TASK_WORK_CLEANING, DISTANCE_OBJECT_TALK, 0.01, OBJECT_SELF);
    }
}
