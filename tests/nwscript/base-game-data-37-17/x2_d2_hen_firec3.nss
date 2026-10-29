//::///////////////////////////////////////////////
//:: x2_d2_hen_firec3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Returns TRUE if the player has previously used this
henchman but had fired him/her.

In Chapter 3.
*/
//:://////////////////////////////////////////////
//:: Created By:    Brent
//:: Created On:    August 2003
//:://////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (!GetIsHired() && GetPlayerHasHired(GetPCSpeaker()) && GetChapter() == 3
       && GetLocalInt(OBJECT_SELF, "X2_FIRE_C3") == 0)
       {
        SetLocalInt(OBJECT_SELF, "X2_FIRE_C3", 1);
        return TRUE;
       }
    return FALSE;
}



