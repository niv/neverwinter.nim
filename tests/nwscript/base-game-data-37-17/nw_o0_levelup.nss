//::///////////////////////////////////////////////
//:: nw_O0_LevelUp.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 This script fires whenever a player levels up.
 If the henchmen is capable of going up a level, they do.
*/
//:://////////////////////////////////////////////
//:: Created By:     Brent
//:: Created On:     2002
//:://////////////////////////////////////////////
#include "nw_i0_henchman"
#include "nw_i0_generic"
void main()
{
    object oPC = GetPCLevellingUp();
    if (GetIsObjectValid(oPC) == TRUE)
    {
        object oHench = GetHenchman(oPC);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            if (GetCanLevelUp(oPC, oHench) == TRUE)
            {
                object oNew = DoLevelUp(oPC, oHench);
                if (GetIsObjectValid(oNew) == TRUE)
                {
                    DelayCommand(1.0,AssignCommand(oNew, EquipAppropriateWeapons(oPC)));
                }

            }
        }
    }
}
