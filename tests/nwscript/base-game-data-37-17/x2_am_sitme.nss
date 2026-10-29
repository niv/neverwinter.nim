// * Bookshelf gets 'read'
#include "x2_am_inc"

void main()
{
    object oSitter = GetSittingCreature(OBJECT_SELF);
    if (GetIsObjectValid(oSitter ) == TRUE) {
    
        IncrementLeisure(5, oSitter);
        if (GetIsPC(oSitter) == FALSE && GetLeisure(oSitter) >= LEISURE_THRESHHOLD)
        {
            AssignCommand(oSitter, ClearAllActions()); // stop sitting
            object oSelf = OBJECT_SELF;
            AssignCommand(oSitter, ActionMoveAwayFromObject(oSelf, FALSE, 10.0));
        }
        return;
        }
    // * Simulate 'use-me' with just a random number
    if (Random(100) >= 25)
    {
        Request(TASK_LEISURE_SIT, DISTANCE_OBJECT_TALK, 0.5, OBJECT_SELF);
    }
}
