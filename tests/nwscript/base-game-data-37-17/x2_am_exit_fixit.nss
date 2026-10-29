//::///////////////////////////////////////////////
//:: x2_exit_fixitall
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Any ambient creature (has a job) that tries
    to leave this trigger is forced back into it.


    DRAWING TIPS:
    - if any characters need to use an area transition to
    get to their nightime place overlap the trigger with
    - Characters need to 'spawn' into this particular
    FixItAll trigger for it to affect them (this defines the 'zone').

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void main()
{
    object oExit = GetExitingObject();
    if (GetIsObjectValid(oExit) == TRUE)
    {
        object oSelf = OBJECT_SELF;
        if (GetJob(oExit) > 0)
        if (GetArea(oSelf) == GetArea(oExit))
        if (GetLocalObject(oExit, "NW_L_MYZONE") == oSelf)
        {
            AssignCommand(oExit, ClearAllActions());
            AssignCommand(oExit, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD));
            object oCenter = GetNearestObject(OBJECT_TYPE_WAYPOINT);
            if (GetIsObjectValid(oCenter) == TRUE)
            {
                AssignCommand(oExit, ActionMoveToObject(oCenter));
            }

        }
    }
}
