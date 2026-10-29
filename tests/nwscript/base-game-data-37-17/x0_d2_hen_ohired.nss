//:://////////////////////////////////////////////////
//:: X0_D2_HEN_OHIRED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Return TRUE if the henchman is hired by someone other
than the current PC speaker.

April 2003: If speaking to self, don't show this starting
condition (i.e., a popup)
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    // this checks to see if the henchman is considered currently
    if  (GetIsHired() && !GetWorkingForPlayer(GetPCSpeaker()) &&
            GetLocalInt(OBJECT_SELF, "X0_L_BUSY_SPEAKING_ONE_LINER") == 0)
    {
        SetLocalInt(OBJECT_SELF, "X0_L_BUSY_SPEAKING_ONE_LINER", 0);
        return TRUE;
    }

    return FALSE;
}
