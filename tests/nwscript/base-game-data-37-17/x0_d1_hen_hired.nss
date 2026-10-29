//:://////////////////////////////////////////////////
//:: X0_D1_HEN_HIRED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Handles the hiring of a henchman.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    //Ensure plot/immortal flags has been turned off
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
    
    HireHenchman(GetPCSpeaker());
}
