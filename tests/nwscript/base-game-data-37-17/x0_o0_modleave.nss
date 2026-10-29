//:://////////////////////////////////////////////////
//:: X0_O0_MODLEAVE
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  Script for leaving players for XP1.
  Should be called to load the sequel module.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/10/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    // Transport all players
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC)) {
        // Store the player's henchman
        StoreCampaignHenchman(oPC);
        oPC = GetNextPC();
    }

    int nChap = GetChapter();
    if (nChap == 1) {
        // load module 2
        StartNewModule("XP1-Chapter 2");
    } else if (nChap == 2) {
        // load module 3
        StartNewModule("XP1-Chapter 3");
    } else {
        if (X0_DEBUG_SETTING) {
            // testing
            StartNewModule("TestScripts2");
        }
    }
}
