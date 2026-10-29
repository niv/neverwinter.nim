//:://////////////////////////////////////////////////
//:: X0_D2_M1_UNHIRED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
This conditional determines if this henchman is currently 
not actively hired by anyone and in module 1. Should be
used in the 'Actions Appear When' section of a henchman
conversation only.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (!GetIsHired() 
        && (GetChapter() == 1)) {
        return TRUE;
    }
    return FALSE;
}
