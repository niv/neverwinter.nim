//::///////////////////////////////////////////////

//:: Name x2_hen_2comp

//:: Copyright (c) 2001 Bioware Corp.

//:://////////////////////////////////////////////

/*

    Test to see if the PC has two companions already.

    Return True if PC already has more than 1 companion



    NOTE - July 15 - multiple henchmen not implemented yet

         - testing for 1 henchman

    UPDATE - July 25th - support for multiple henchmen added

*/

//:://////////////////////////////////////////////

//:: Created By: Keith Warner

//:: Created On: July 15/03

//:://////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()

{

    object oPC = GetPCSpeaker();
    int nNumHench = X2_GetNumberOfHenchmen(oPC);
    if (nNumHench >= 2)
    {
        return TRUE;
    }
    else
    {
        return FALSE; // Less than 2 henches
    }
}

