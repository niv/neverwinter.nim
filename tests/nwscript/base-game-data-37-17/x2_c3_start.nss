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
#include "x2_inc_banter"

void SetupValenAndNathyrra(object oValen, object oNathyrra);
// * Valen and Nathyrra needs custom scripting to get their interjections to work correctly
void SetupValenAndNathyrra_1(object oValen, object oNathyrra);

void main()
{
    SetMaxHenchmen(4);
    // * Set the "I'm an XP2 module" variable
    SetLocalInt(GetModule(), "X2_L_XP2", 1);

    // * Assumption: This script is fired on the Realm of the Reaper Area Enter
    // * this is used to clear the combat state of the PC so they can talk

    object oPC = GetEnteringObject();
   if (GetIsPC(oPC) == TRUE)
   {
        AssignCommand(oPC, ClearAllActions(TRUE));
   }
   else
   {
    return;
   }
   // * Only run once
   if (GetLocalInt(GetModule(), "C3_Loaded") == 1)
    return;
    SetLocalInt(GetModule(), "C3_Loaded", 1);


    object oPool = RestorePoolOfLostSouls(oPC);
        //* Setup Pool of Lost souls, max buy price and sell price et ceterea
    SetStoreMaxBuyPrice(oPool, 500);
    // * OLDER STUFF ----------------------------
    // * recover genie store
    object oGenieStore = RetrieveCampaignObject(DB_NAME, "Genie_Store", GetLocation(oPC), oPC, OBJECT_SELF);
    object oStore = CreateObject(OBJECT_TYPE_STORE, "x2_genie", GetLocation(oPC));

    // * Remove inventory from the current Genie store (so there is no item dupe.)
    RemoveInventory(oStore);

    CopyInventory(oGenieStore, oStore);
    DestroyObject(oGenieStore, 1.0);


      RestoreWeaponVars(oPC);

    // * setup djinni to say correct thing
    SetLocalInt(oPC,"FIRSTDJINNITALK", 10);


    // * ---------------------- Chapter 2 to Chapter 3 stuff ------------------------------------------------

    // * Henchmen explicitly copied over. They
    // * have to be "called" from the reaper however
    // * for now they appear in the "null" area
    location lLoc = GetLocation(GetObjectByTag("Null_Area_WP"));
    //SpawnScriptDebugger();
    // * recover deekin, valen, and nathyrra
    object oDeekin = RetrieveCampaignObject(DB_NAME, "c2_deekin", lLoc, OBJECT_INVALID, oPC);
    object oNathyrra = RetrieveCampaignObject(DB_NAME, "c2_nathyrra", lLoc, OBJECT_INVALID, oPC);
    object oValen = RetrieveCampaignObject(DB_NAME, "c2_valen", lLoc, OBJECT_INVALID, oPC);


    // * Nov 8 - BK. To hide "Call my companions" option, I set number of henchmen called
    int nNumHench = 0;
    if (GetIsObjectValid(oDeekin) == TRUE)
        nNumHench++;
    if (GetIsObjectValid(oNathyrra) == TRUE)
        nNumHench++;
    if (GetIsObjectValid(oValen) == TRUE)
        nNumHench++;

    SetLocalInt(GetModule(), "X2_L_NUM_HENCHES_COME", nNumHench);

    // * restore the henchmen variables to these objects
    RestoreHenchmenVariables(oDeekin);

    RestoreHenchmenVariables(oNathyrra);
    RestoreHenchmenVariables(oValen);

    //DelayCommand(3.5, SetupValenAndNathyrra_1(oValen, oNathyrra));
    //DelayCommand(1.5, SetupValenAndNathyrra(oValen, oNathyrra));


    // * used for end game
    RestoreInt("bDaelanMetHalaster");
    RestoreInt("bTomiMetHalaster");
    RestoreInt("bLinuMetHalaster");
    RestoreInt("bSharwynMetHalaster");

    RestoreInt("X2_Q2DOvermind");



    // ********************************
    // * Nathyra Variables *
    // ********************************
    RestoreInt("iNathyrraRomance");
    RestoreInt("iNathyrraRomLevel");
    RestoreInt("iNathyrraStage");
    RestoreInt("iNathyrraStage1");
    RestoreInt("iNathyrraStage2");
    RestoreInt("iNathyrraStage3");
    RestoreInt("iNathyrraStage4");
    RestoreInt("iNathyrraStage5");
    RestoreInt("iNathyrraStage6");

    // * Set henchmen plot variable to four
    SetLocalInt(GetModule(), "iNathyrraStage", 4);

    // ********************************

    // ********************************
    // * Valen Variables *
    // ********************************
    RestoreInt("iValenRomance");
    RestoreInt("iValenRomLevel");

    RestoreInt("iValenStage");
    RestoreInt("iValenStage1");
    RestoreInt("iValenStage2");
    RestoreInt("iValenStage3");
    RestoreInt("iValenStage4");
    RestoreInt("iValenStage5");
    RestoreInt("iValenStage6");

    // * Set henchmen plot variable to four
    SetLocalInt(GetModule(), "iValenStage", 4);
    // ********************************

    // ********************************
    // * Deekin Variables *
    // ********************************
    RestoreInt("iDeekinFriendship");
    RestoreInt("x2_hen_deekdisc");
    RestoreInt("x2_hen_deekstory");
    RestoreInt("x2_deekin_final_story");
    // ********************************

    // * Georg: Intelligent weapon storage
    RestoreInt("X2_L_INTWEAPON_NUMTALKS");
    RestoreInt("X2_L_IW_ASKED_1");
    RestoreInt("X2_L_IW_ASKED_2");
    RestoreInt("X2_L_IW_ASKED_3");
    RestoreInt("X2_L_IW_ASKED_4");
    RestoreInt("X2_L_IW_ASKED_5");
    RestoreInt("X2_L_IW_ASKED_6");

    //retrieve Reaper variable
    RestoreInt("X2_L_DEATHINFOREVEALED");

     // * remember there is a max length of variables that can be stored
     // * in database (variable name)
    RestoreIntFromObject("BANT" + "x2_hen_valen", oDeekin);
    RestoreIntFromObject("BANT" + "x2_hen_deekin", oDeekin);
    RestoreIntFromObject("BANT" + "x2_hen_valen", oDeekin);

    RestoreIntFromObject("BANT" + "x2_hen_valen", oValen);
    RestoreIntFromObject("BANT" + "x2_hen_deekin", oValen);
    RestoreIntFromObject("BANT" + "x2_hen_valen", oValen);

    RestoreIntFromObject("BANT" + "x2_hen_valen", oNathyrra);
    RestoreIntFromObject("BANT" + "x2_hen_deekin", oNathyrra);
    RestoreIntFromObject("BANT" + "x2_hen_valen", oNathyrra);

    RestoreInt("PC_BETRAY_NAT");
    RestoreInt("PC_BETRAY_VAL");

    RestoreInt("bSeerBetrayed");
    RestoreString("sShatteredMirrorGivenTo");
    RestoreInt("bElderBrainSurvived");
//    RestoreInt("bIllithidsSideWithDrow");
//    RestoreInt("bIllithidsGainDracolichArtifact");
    RestoreInt("X2_Q2DOvermind");


    RestoreInt("bDracolichKilled");
    RestoreInt("bArmandKilled");
    RestoreInt("bDevaDead");
    // * the mage golem
    RestoreInt("Q4D_GOLEM_SLOT0");
    RestoreInt("Q4D_GOLEM_SLOT1");
    RestoreInt("Q4D_GOLEM_SLOT2");
    RestoreInt("Q4D_GOLEM_SLOT3");

    // * store Genie variables
    RestoreIntFromObject("DJINNITHREAT", oPC);
    RestoreIntFromObject("FIRSTDJINNITALK", oPC);

    // *
    // * Delete Previous databases and perform an AutoSave.
    // *
    DestroyCampaignDatabase(DB_NAME);
    // * need to do a delay to give the database time to do its stuff
    // * Commented this out because the save happens before all the spawn
    // * scripts have had a chance to run. brad will move the savegame
    // *
    //DelayCommand(0.8, DoSinglePlayerAutoSave());

}
// * Valen and Nathyrra needs custom scripting to get their interjections to work correctly
void SetupValenAndNathyrra_1(object oValen, object oNathyrra)
{
    // * Make sure Nathyrra and Valen will not say their specific Chapter 2 randomers
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOMONELINERS", 1);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOMONELINERS", 2);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOMONELINERS", 3);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOMONELINERS", 4);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOMONELINERS", 5);
    GetRandomTextNumber(oValen, "X2_L_RANDOMONELINERS", 1);
    GetRandomTextNumber(oValen, "X2_L_RANDOMONELINERS", 2);
    GetRandomTextNumber(oValen, "X2_L_RANDOMONELINERS", 3);
    GetRandomTextNumber(oValen, "X2_L_RANDOMONELINERS", 4);
    GetRandomTextNumber(oValen, "X2_L_RANDOMONELINERS", 5);
}
// * Valen and Nathyrra needs custom scripting to get their interjections to work correctly
void SetupValenAndNathyrra(object oValen, object oNathyrra)
{

    // * add the five new one-liners
    string sOldString = GetLocalString(oNathyrra, "X2_L_RANDOMONELINERS");

    SetLocalString(oNathyrra, "X2_L_RANDOMONELINERS", sOldString+"|26|27|28|29|30");
    sOldString = GetLocalString(oValen, "X2_L_RANDOMONELINERS");
    SetLocalString(oValen, "X2_L_RANDOMONELINERS", sOldString+"|26|27|28|29|30");
    // * now do the same for the interjection text
    GetRandomTextNumber(oValen, "X2_L_RANDOM_INTERJECTIONS", 1);
    GetRandomTextNumber(oValen, "X2_L_RANDOM_INTERJECTIONS", 2);
    GetRandomTextNumber(oValen, "X2_L_RANDOM_INTERJECTIONS", 3);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOM_INTERJECTIONS", 1);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOM_INTERJECTIONS", 2);
    GetRandomTextNumber(oNathyrra, "X2_L_RANDOM_INTERJECTIONS", 3);
    sOldString = GetLocalString(oNathyrra, "X2_L_RANDOM_INTERJECTIONS");
    SetLocalString(oNathyrra, "X2_L_RANDOM_INTERJECTIONS", sOldString + "|6|7");
    sOldString = GetLocalString(oValen, "X2_L_RANDOM_INTERJECTIONS");
    SetLocalString(oValen, "X2_L_RANDOM_INTERJECTIONS", sOldString + "|6|7");
}
