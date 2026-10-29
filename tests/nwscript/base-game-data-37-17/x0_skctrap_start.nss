//::///////////////////////////////////////////////
//:: x0_skctrap_start
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Player sits down while 'making' the trap
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "x2_inc_craft"
int StartingConditional()
{

    ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 0.5, 12000.0);
    CISetDefaultModItemCamera(GetPCSpeaker());
    return TRUE;
}

