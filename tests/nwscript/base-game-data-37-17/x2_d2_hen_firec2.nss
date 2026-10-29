//::///////////////////////////////////////////////
//:: x2_d2_hen_firec2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Returns TRUE if the player has previously used this
henchman but had fired him/her.

In Chapter 2.
*/
//:://////////////////////////////////////////////
//:: Created By:    Brent
//:: Created On:    August 2003
//:://////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (!GetIsHired() && GetPlayerHasHired(GetPCSpeaker()) && GetChapter() == 2
     && GetLocalInt(OBJECT_SELF, "X2_FIRE_C2") == 0)
       {
        SetLocalInt(OBJECT_SELF, "X2_FIRE_C2", 1); // * Already said this fire line
        return TRUE; \
       }
    return FALSE;
}


