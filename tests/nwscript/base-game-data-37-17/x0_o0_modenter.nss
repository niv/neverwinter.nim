//:://////////////////////////////////////////////////
//:: X0_O0_MODENTER
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  Script for entering players for XP1.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/10/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    // Set the respawn location
    object oPC = GetEnteringObject();
    DelayCommand(5.0, DBG_msg("Setting respawn location to starting loc: "
        + GetTag(GetArea(oPC))));
    DelayCommand(5.0,SetRespawnLocation(oPC));

    // Restore the henchman
    DelayCommand(5.0, RetrieveCampaignHenchman(oPC));

}
