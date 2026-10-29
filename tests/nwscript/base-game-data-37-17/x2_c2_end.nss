//::///////////////////////////////////////////////
//:: x2_c1_end
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Copies all data from Chapter 1 for
    use in Chapter 2.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_globals"
#include "x0_i0_henchman"

// * strips chapter 1 only plot items from player and henchmen
void StripPlotItems();
// * destroys all instances of items with these tags
//* this will destroy items on henchmen and pcs
void DestroyItems(string sTag);

void StoreIt(object oStoreIt, string sVarName, object oPC)
{
    if (GetIsObjectValid(oStoreIt) == TRUE)
    {
        if (GetObjectType(oStoreIt) == OBJECT_TYPE_STORE)
        {
            // * since stores cannot be stored to the database
            // * transfer items to a deep rothe and move it across.
            // * Seriously.
            object oRothe = CreateObject(OBJECT_TYPE_CREATURE, "x2_deeprothe001", GetLocation(oStoreIt));
            CopyInventory(oStoreIt, oRothe);
            oStoreIt = oRothe;
        }
        StoreCampaignObject(DB_NAME, sVarName, oStoreIt, oPC);
    }
}


void RaiseAndHeal(object oHench)
{
    effect eRes = EffectResurrection();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oHench);

    int nMaxHP = GetMaxHitPoints(oHench);
    int nCurrHP = GetCurrentHitPoints(oHench);
    effect eHeal = EffectHeal(nMaxHP-nCurrHP);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHench);
    // * clear all actions
    AssignCommand(oHench, ClearAllActions());
}


void main()
{   // SpawnScriptDebugger();

    StripPlotItems();
    // * Delete redundant database
    object oPC = GetFirstPC();


    // * Store Variables

    // * This is more complicated than in Chapter 1
    // * Basically store Deekin, Valen or Nathyrra out (but not V or N if they were betrayed)
    object oDeekin = GetObjectByTag("x2_hen_deekin");
    object oNathyrra = GetObjectByTag("x2_hen_nathyra");
    object oValen = GetObjectByTag("x2_hen_valen");

    if (GetIsObjectValid(oDeekin) == TRUE)
    {
        RaiseAndHeal(oDeekin);
        // * raise Deekin & Heal & store variables
        if (GetPlayerHasHired(oPC, oDeekin) == TRUE)
        {
            StoreCampaignObject(DB_NAME, "c2_deekin", oDeekin, oPC);
            StoreHenchmenVariables(oDeekin);
        }
    }
    if (GetIsObjectValid(oNathyrra) == TRUE)
    {
        // * Player did not betray
        if (GetLocalInt(GetModule(), "PC_BETRAY_NAT") == 0)
        {
            RaiseAndHeal(oNathyrra);
            // * raise oNathyrra & Heal & store variables
            if (GetPlayerHasHired(oPC, oNathyrra) == TRUE)
            {
                StoreCampaignObject(DB_NAME, "c2_nathyrra", oNathyrra, oPC);
                StoreHenchmenVariables(oNathyrra);
            }
        }
    }
    if (GetIsObjectValid(oValen) == TRUE)
    {
        if (GetLocalInt(GetModule(), "PC_BETRAY_VAL") == 0)
        {
            RaiseAndHeal(oValen);
            // * raise oValen & Heal & store variables
            if (GetPlayerHasHired(oPC, oValen) == TRUE)
            {
                StoreHenchmenVariables(oValen);
                StoreCampaignObject(DB_NAME, "c2_valen", oValen, oPC);
            }
        }
    }

        // * copy the djinni store
    object oStoreIt = GetObjectByTag("x2_genie_store");
    StoreIt(oStoreIt, "Genie_Store", oPC);
    oStoreIt = OBJECT_INVALID;

    // Store Reaper Variable
    StoreInt("X2_L_DEATHINFOREVEALED");

    // * used for end game
    StoreInt("bDaelanMetHalaster");
    StoreInt("bTomiMetHalaster");
    StoreInt("bLinuMetHalaster");
    StoreInt("bSharwynMetHalaster");

    // * Georg: Intelligent weapon storage
    StoreInt("X2_L_INTWEAPON_NUMTALKS");
    StoreInt("X2_L_IW_ASKED_1");
    StoreInt("X2_L_IW_ASKED_2");
    StoreInt("X2_L_IW_ASKED_3");
    StoreInt("X2_L_IW_ASKED_4");
    StoreInt("X2_L_IW_ASKED_5");
    StoreInt("X2_L_IW_ASKED_6");



    // ********************************
    // * Nathyra Variables *
    // ********************************
    StoreInt("iNathyrraRomance");
    StoreInt("iNathyrraRomLevel");

    StoreInt("iNathyrraStage");
    StoreInt("iNathyrraStage1");
    StoreInt("iNathyrraStage2");
    StoreInt("iNathyrraStage3");
    StoreInt("iNathyrraStage4");
    StoreInt("iNathyrraStage5");
    StoreInt("iNathyrraStage6");
    // ********************************

    // ********************************
    // * Valen Variables *
    // ********************************
    StoreInt("iValenRomance");
    StoreInt("iValenRomLevel");

    StoreInt("iValenStage");
    StoreInt("iValenStage1");
    StoreInt("iValenStage2");
    StoreInt("iValenStage3");
    StoreInt("iValenStage4");
    StoreInt("iValenStage5");
    StoreInt("iValenStage6");

    // ********************************


    // ********************************
    // * Deekin Variables *
    // ********************************
    StoreInt("iDeekinFriendship");
    StoreInt("x2_hen_deekdisc");
    StoreInt("x2_hen_deekstory");
    StoreInt("“x2_deekin_final_story");
    // ********************************


    // * Store Banter Variables
    StoreIntFromObject("BANT" + "x2_hen_valen", oDeekin);
    StoreIntFromObject("BANT" + "x2_hen_deekin", oDeekin);
    StoreIntFromObject("BANT" + "x2_hen_valen", oDeekin);

    StoreIntFromObject("BANT" + "x2_hen_valen", oValen);
    StoreIntFromObject("BANT"+ "x2_hen_deekin", oValen);
    StoreIntFromObject("BANT" + "x2_hen_valen", oValen);

    StoreIntFromObject("BANT" + "x2_hen_valen", oNathyrra);
    StoreIntFromObject("BANT" + "x2_hen_deekin", oNathyrra);
    StoreIntFromObject("BANT" + "x2_hen_valen", oNathyrra);


    StoreInt("PC_BETRAY_NAT");
    StoreInt("PC_BETRAY_VAL");

    StoreInt("bSeerBetrayed");
    StoreString("sShatteredMirrorGivenTo");
    StoreInt("bElderBrainSurvived");
    //StoreInt("bIllithidsSideWithDrow");
    //StoreInt("bIllithidsGainDracolichArtifact");
    StoreInt("X2_Q2DOvermind");




    StoreInt("X2_Q2DOvermind");

    StoreInt("bDracolichKilled");
    StoreInt("bArmandKilled");
    StoreInt("bDevaDead");
    // * the mage golem
    StoreInt("Q4D_GOLEM_SLOT0");
    StoreInt("Q4D_GOLEM_SLOT1");
    StoreInt("Q4D_GOLEM_SLOT2");
    StoreInt("Q4D_GOLEM_SLOT3");

    // * store Genie variables
    StoreIntFromObject("DJINNITHREAT", oPC);
    StoreIntFromObject("FIRSTDJINNITALK", oPC);

    StoreWeaponVars(oPC);
    StorePoolOfLostSouls(oPC);

}

// * destroys all instances of items with these tags
//* this will destroy items on henchmen and pcs
void DestroyItems(string sTag)
{
    object oItem = GetObjectByTag(sTag);
    int i = 1;
    while (GetIsObjectValid(oItem) == TRUE)
    {
        i++;
        DestroyObject(oItem);
        oItem = GetObjectByTag(sTag, i);

    }
}
// * strips chapter 1 only plot items from player and henchmen
void StripPlotItems()
{
    DestroyItems("q5_note");
    DestroyItems("burnedbook");
    DestroyItems("q4_notes2");
    DestroyItems("q4_notes3");
    DestroyItems("q4_notes4");
    DestroyItems("q4_notes");
    DestroyItems("q3_matronletter");
    DestroyItems("q4_dictionary");
    DestroyItems("MagicsofGolemEnhancments");
    DestroyItems("ScripturesoftheCreated");
    DestroyItems("q3_dracohint");
    DestroyItems("q3_vampirehint");
    DestroyItems("bk_pearl_ix");
    DestroyItems("bk_pearl_tongue");
    DestroyItems("SoulGem");
    DestroyItems("BlackPearl");
    DestroyItems("q4b_GolemAttractorItem");
    DestroyItems("q4b_binder");
    DestroyItems("q4b_crasher");

    DestroyItems("q3b_rope");
    DestroyItems("q4b_comp1");
    DestroyItems("q3c_blood");
    DestroyItems("Q3C_ChargedOrb");
    DestroyItems("q4c_ferron_head");
    DestroyItems("q4b_comp5");
    DestroyItems("q4d_GolemHead");
    DestroyItems("q4_GolLeftHand");
    DestroyItems("q4_GolLeftLeg");
    DestroyItems("q4_mach_act");
    DestroyItems("q4_GolRightHand");
    DestroyItems("q4_GolRightLeg");
    DestroyItems("q4d_golem_seal");
    DestroyItems("q4_GolemTorso");
    DestroyItems("q2amaeviirkey");
    DestroyItems("q3b_LowerCryptKey");
    DestroyItems("q4b_comp4");


    DestroyItems("q6_compass");
    DestroyItems("q6_shard");
    DestroyItems("q4b_comp6");
    DestroyItems("q3c_entry_key");
    DestroyItems("q3c_NullifierRod");
    DestroyItems("q6c_potion");
    DestroyItems("q4b_comp2");
    DestroyItems("q3c_stake");
    DestroyItems("q5_StoneSlab");
    DestroyItems("q6e_cure");
    DestroyItems("q2d5cellkey");
    DestroyItems("q4b_comp4");
}
