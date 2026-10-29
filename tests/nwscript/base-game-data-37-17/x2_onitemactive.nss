//::///////////////////////////////////////////////
//:: x2_onitemactive
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script controls all custom behavior of
    items that get activated.

    Signals user defined event #33002
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 28, 2003
//:://////////////////////////////////////////////
#include "x0_inc_portal"
#include "x2_inc_plot"

void main()
{
    int nNotInstant = GetLocalInt(GetItemActivator(), "NW_L_PORTALINSTANT");
    string szItem = GetTag(GetItemActivated());
    object oActivator = GetItemActivator();
    
    // ************************************
    // * GLOBAL SPECIFIC CUSTOM ITEM USE
    // * All these and all chapter stuff
    // * should be part of the same else
    // * chain
    // ************************************

    // * start conversation with player for DEMON STORE
    if (szItem == "allDemonBottle")
    {
        //Djinn won't come out if PC is in combat
        if (GetIsInCombat(oActivator) == FALSE)
        {

                //Create Djinn in front of player
                object oDjinn = CreateObject(OBJECT_TYPE_CREATURE, "x2_djinn", GetLocation(GetItemActivator()));
                location lDjinn = GetLocation(oDjinn);
                DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lDjinn));
                AssignCommand(oDjinn, SetFacingPoint(GetPosition(GetItemActivator())));
                DelayCommand(1.0, AssignCommand(oDjinn, ActionStartConversation(oActivator, "x2_djinn", TRUE, FALSE)));


        }
        else
        {
            object oDialog2 = CreateObject(OBJECT_TYPE_PLACEABLE, "x2djinndialog", GetLocation(GetItemActivator()));
            AssignCommand(oDialog2, SpeakOneLinerConversation());
            DestroyObject(oDialog2, 5.0);
        }
    }
    else
    // * start conversation with player BY USING MANIPULATE ITEM POWER
    if ((GetTag(GetItemActivated()) == "x2_p_reaper") && (nNotInstant == 10))
    {
            object oPC = GetItemActivator();
            // * the relic is disabled at certain points in the game
        // * to prevent bugs
        // * Places it is disabled
        // * - before the thief strikes
        if (GetLocalInt(GetModule(), "x2_g_disabled") == 10)
        {
            SendMessageToPCByStrRef(oPC, 84772);
            return;
        }
        object oArea = GetArea(oPC);
        if (GetTag(oArea) == "q2a2_house")
        {
            SendMessageToPCByStrRef(oPC, 84772);
            return;
        }
        
        //if this is chapter 2 - no portal stone after the siege is ready
        object oModule = GetModule();
        if (GetTag(oModule) == "x0_module2")
        {
            if (GetLocalInt(GetModule(), "X2_StartSeerSiegeSpeech") > 0)
            {
                SendMessageToPCByStrRef(oPC, 84772);
                return;
            }
        }
        //check to make sure PC is not in combat
 //       if (GetIsInCombat(GetItemActivator()) == FALSE)
//        {
            // * September 2003: Removed combat check because in Chapter 3
            // * the cold damage keeps you in combat state, making
            // * this item unuseable.
            AssignCommand(oPC, ClearAllActions(TRUE));
            SetLocalInt(oPC, "NW_L_PORTALINSTANT", 0);
            AssignCommand(oPC, ActionStartConversation(oPC, "x2_p_portalston", TRUE, FALSE));

//        }
//        else
//            SendMessageToPC(GetItemActivator(), "The Relic cannot be activated while you are in combat.");
    }
    // * Summon the modified Tynan
    if (szItem == "bk_top")
    {
        effect eSummon = EffectSummonCreature("x2_s_tynan0", VFX_FNF_SUMMON_MONSTER_3);
        // * default is the drider, otherwise bring in the goblin
        if (GetLocalInt(GetModule(), "x2_g_tynan") == 1)
        {
            eSummon = EffectSummonCreature("x2_s_tynan1", VFX_FNF_SUMMON_MONSTER_3);
        }
        AssignCommand(oActivator,
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oActivator,  RoundsToSeconds(8)));
    }
    else
    // ************************************
    // * CHAPTER 1 SPECIFIC CUSTOM ITEM USE
    // ************************************



    // ************************************
    // * CHAPTER 2 SPECIFIC CUSTOM ITEM USE
    // ************************************


    // ************************************
    // * CHAPTER 3 SPECIFIC CUSTOM ITEM USE
    // ************************************

    // ************************************
    // * DEFAULT BEHAVIOR
    // * Fire a script with the tag
    // * of the item as its name on
    // * the object oActivator
    // ************************************
    ExecuteScript(szItem, oActivator);

}
