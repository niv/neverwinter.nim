//:://////////////////////////////////////////////////
//:: X0_D2_HEN_MASTER
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Returns TRUE if the speaker is the henchman's current 
master.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    int bWorking = FALSE;
    if (GetWorkingForPlayer(GetPCSpeaker()) == TRUE)
        bWorking = TRUE;
        
    int bReturn = TRUE;
    
    if (bWorking == FALSE || GetLocalInt(OBJECT_SELF, "X2_PLEASE_NO_TALKING") == 100)
    {
        bReturn = FALSE;
    }




    return bReturn;
}
