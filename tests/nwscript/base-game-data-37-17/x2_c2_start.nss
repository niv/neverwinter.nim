//::///////////////////////////////////////////////
//:: x2_c2_start
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    At the start of Chapter 2 load the
    henchmen from Chapter 1 in.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_globals"

void main()
{
     // * Only run once
   if (GetLocalInt(GetModule(), "C2_Loaded") == 1)
    return;
    SetLocalInt(GetModule(), "C2_Loaded", 1);

    // * Set the "I'm an XP2 module" variable
    SetLocalInt(GetModule(), "X2_L_XP2", 1);

    object oPC = OBJECT_SELF;


    object oPool = RestorePoolOfLostSouls(oPC);
    // * recover genie store
    object oGenieStore = RetrieveCampaignObject(DB_NAME, "Genie_Store", GetLocation(oPC), oPC, OBJECT_SELF);
    object oStore = CreateObject(OBJECT_TYPE_STORE, "x2_genie", GetLocation(oPC));

    // * Remove inventory from the current Genie store (so there is no item dupe.)
    RemoveInventory(oStore);

    CopyInventory(oGenieStore, oStore);
    DestroyObject(oGenieStore, 1.0);

    //* Setup Pool of Lost souls, max buy price and sell price et ceterea
    SetStoreMaxBuyPrice(oPool, 500);



    // * retrieve variables
    RestoreInt("bDaelanMetHalaster");
    RestoreInt("bTomiMetHalaster");
    RestoreInt("bLinuMetHalaster");
    RestoreInt("bSharwynMetHalaster");

    RestoreInt("x2_hen_deekdisc");
    RestoreInt("x2_hen_deekstory");
    RestoreInt("x2_deekin_final_story");

    //retrieve Reaper variable
    RestoreInt("X2_L_DEATHINFOREVEALED");

    RestoreInt("iDeekinFriendship");

    // * store Genie variables
    RestoreIntFromObject("DJINNITHREAT", oPC);


    RestoreIntFromObject("FIRSTDJINNITALK", oPC);

    RestoreWeaponVars(oPC);

    // * Georg: Intelligent weapon storage
    RestoreInt("X2_L_INTWEAPON_NUMTALKS");
    RestoreInt("X2_L_IW_ASKED_1");
    RestoreInt("X2_L_IW_ASKED_2");
    RestoreInt("X2_L_IW_ASKED_3");
    RestoreInt("X2_L_IW_ASKED_4");
    RestoreInt("X2_L_IW_ASKED_5");
    RestoreInt("X2_L_IW_ASKED_6");


    // * must be last thing done
    //Start Deekin in the side room so he doesn't show up in the cutscene
    location lDeekSpawn = GetLocation(GetWaypointByTag("wp_q2a1deekinstart"));
    RestoreAllHenchmen(lDeekSpawn, oPC);
    
    // * removed autosave because it has the potential of causing problems
   // DoSinglePlayerAutoSave();
    // *
    // * Delete Previous databases and perform an AutoSave.
    // *
    // * Already done by the RestoreAllHenchmen command

}
