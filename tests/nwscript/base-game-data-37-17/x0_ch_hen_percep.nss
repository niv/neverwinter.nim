//:://////////////////////////////////////////////////
//:: X0_CH_HEN_PERCEP
/*

  OnPerception event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "X0_INC_HENAI"

void main()
{
    // * if henchman is dying and Player disappears
    // * then force a respawn of the henchman
    if (GetIsHenchmanDying(OBJECT_SELF) == TRUE)
    {   //SpawnScriptDebugger();
        // * the henchman must be removed otherwise their corpse will follow
        // * the player
        object oOldMaster = GetMaster();
        object oPC = GetLastPerceived();
        int bVanish = GetLastPerceptionVanished();
        if (GetIsObjectValid(oPC) && bVanish == TRUE)
        {
            if (oPC == oOldMaster)
            {
                RemoveHenchman(oPC, OBJECT_SELF);
                // * only in chapter 1
                if (GetTag(GetModule()) == "x0_module1")
                {
                    SetCommandable(TRUE);
                    DoRespawn(oPC,  OBJECT_SELF); // * should teleport henchman back
                }
            }
        }
    }

	ExecuteScript("nw_ch_ac2", OBJECT_SELF);
}

