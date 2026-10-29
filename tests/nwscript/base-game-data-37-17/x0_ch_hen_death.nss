//:://////////////////////////////////////////////////
//:: X0_CH_HEN_DEATH
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  OnDeath handler for henchmen ONLY. Causes them to respawn at
  (in order of preference) the respawn point of their master
  or their own starting location.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/09/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Bob Minors
//:: Modified On: Jan 12th, 2008
//:: Added Support for Dying While Mounted
//:: Modified By: Deva Winblood
//:: Modified On: April 17th, 2008
//:: Fixes for henchmen mounts being lost
//:://///////////////////////////////////////////////

#include "x0_i0_henchman"
#include "x3_inc_horse"

void main()
{
    SetLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT","x0_ch_hen_death");
    if (HorseHandleDeath()) return;
    DeleteLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT");

    // Handle a bunch of stuff to keep us from running around,
    // dying again, etc.
    PreRespawnSetup();

    // Call for healing
    DelayCommand(0.5, VoiceHealMe(TRUE));

    // Get our last master
    object oPC = GetLastMaster();
    object oSelf = OBJECT_SELF;


    // Clear dialogue events
    ClearAllDialogue(oPC, OBJECT_SELF);
    ClearAllActions();

    string sAreaTag = GetTag(GetArea(OBJECT_SELF));
    // * in final battle area henchmen death is now permanent
    if (sAreaTag == "Winds_04")
    {

        SetPlotFlag(OBJECT_SELF,FALSE);
        SetImmortal(OBJECT_SELF, FALSE);
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF, 0.2);
        return;
    }

    if ((GetTag(GetModule()) == "x0_module2" || GetTag(GetModule()) == "x0_module3") && GetIsObjectValid(oPC) == FALSE)
    {
   // SpawnScriptDebugger();
        // * if you kill a henchmen who has never had a master
        // * then permanently kill them to prevent
        // * faction issues.
        SetPlotFlag(OBJECT_SELF,FALSE);
        SetImmortal(OBJECT_SELF, FALSE);
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF, 0.2);
        return;
    }

    // If we don't have a master OR he has died, respawn immediately
    // April 2003, in some areas the henchmen has to respawn immediately
    // back for pathfinding reasons (i.e., if they die in front of the dragon
    // the dragon will act stupid
    if (!GetIsObjectValid(oPC) || GetIsDead(oPC) == TRUE && GetTag(GetModule()) == "x0_module1"
         || sAreaTag =="Q5_DragonCaves" || sAreaTag == "Q3C_AncientTemple")
    {
        DelayCommand(1.0, RespawnHenchman());
        DelayCommand(1.5, PostRespawnCleanup());
    }
    else
    {
        // BK Feb 2003: Make the henchman rejoin you so that you can use potions on them
        DelayCommand(0.1, AddHenchman(oPC, oSelf));

        // Start the respawn checking
        RaiseForRespawn(oPC);
        // * henchmen will always stay where they die unless you leave them
       // RespawnCheck(oPC);
    }
}
