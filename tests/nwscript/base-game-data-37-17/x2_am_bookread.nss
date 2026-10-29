// * Bookshelf gets 'read'
#include "x2_am_inc"

void main()
{
    // * Simulate 'use-me' with just a random number
    if (Random(100) > 35)
    {
        Request(TASK_LEISURE_READBOOK, DISTANCE_OBJECT_TALK, 0.5, OBJECT_SELF);
    }
}
