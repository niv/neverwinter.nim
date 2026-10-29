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


void main()
{

    StripPlotItems();
    object oPC = GetFirstPC();
    CopyAllHenchmen(oPC);
    CopyOriginalFourInventory();
    StorePoolOfLostSouls(oPC);

    // * copy the djinni store
    object oStoreIt = GetObjectByTag("x2_genie_store");
    StoreIt(oStoreIt, "Genie_Store", oPC);
    oStoreIt = OBJECT_INVALID;

    oStoreIt = GetObjectByTag("x2_chapter1pcequip");
    //StoreIt(oStoreIt, "Stolen_Items");



    // ***********
    object oDeekin = GetObjectByTag("x2_hen_deekin");
    StoreHenchmenVariables(oDeekin);
    StoreInt("bDaelanMetHalaster");
    StoreInt("bTomiMetHalaster");
    StoreInt("bLinuMetHalaster");
    StoreInt("bSharwynMetHalaster");

    StoreInt("x2_hen_deekdisc");
    StoreInt("x2_hen_deekstory");
    StoreInt("x2_deekin_final_story");
    
    // Store Reaper Variable
    StoreInt("X2_L_DEATHINFOREVEALED");

    // * store Genie variables
    StoreIntFromObject("DJINNITHREAT", oPC);
    StoreIntFromObject("FIRSTDJINNITALK", oPC);

    // * Georg: Intelligent weapon storage
    StoreInt("X2_L_INTWEAPON_NUMTALKS");
    StoreInt("X2_L_IW_ASKED_1");
    StoreInt("X2_L_IW_ASKED_2");
    StoreInt("X2_L_IW_ASKED_3");
    StoreInt("X2_L_IW_ASKED_4");
    StoreInt("X2_L_IW_ASKED_5");
    StoreInt("X2_L_IW_ASKED_6");

    StoreInt("iDeekinFriendship");
    StoreWeaponVars(oPC);

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
    DestroyItems("q2c_gobkey");
    DestroyItems("q2chobkey");
    DestroyItems("q2cstone");
    DestroyItems("bk_note1");
    DestroyItems("q2b03FairyDust");
    DestroyItems("q2c2_chain_gre");
    DestroyItems("bk_note2");
    DestroyItems("halasternote");
    DestroyItems("q2c2_chain_pur");
    DestroyItems("q2c2_chain_red");
    DestroyItems("q2c2_chain_yel");
    DestroyItems("q2craksanctumkey");
    DestroyItems("q2bratseeds");
    DestroyItems("q2bhallofkingkey");
    DestroyItems("q2brodblue");
    DestroyItems("q2brodgreen");
    DestroyItems("q2brodred");
    DestroyItems("q2brodwhite");
    DestroyItems("q2brodyellow");
}
