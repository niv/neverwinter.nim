//:://////////////////////////////////////////////////
//:: X0_D1_HEN_QUITS
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
The henchman's been pissed off so badly s/he's going
to quit working for this player and go back to his/her
waypoint.

// * Overridden Sep 30 2003 -- in XP
// * make them go back to Yawning Portal
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    QuitHenchman(GetPCSpeaker());
         // * Set the "I'm an XP2 module" variable

    if (GetLocalInt(GetModule(), "X2_L_XP2") == 1)
    {
        object oHome = GetObjectByTag("x2_l_henchstart");
        if (GetIsObjectValid(oHome) == TRUE)
        {
//            ClearAllActions();
            DelayCommand(0.3, JumpToObject(oHome));
            JumpToObject(oHome);
            JumpToObject(oHome);
            JumpToObject(oHome);
        }
    }
}
