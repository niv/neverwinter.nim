#include "x0_i0_henchman"

const string DB_NAME = "XP2";

// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
void SetGlobalInt(string sVarName, int nValue);
// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
int GetGlobalInt(string sVarName);
// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
void SetGlobalString(string sVarName, string sValue);
// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
string GetGlobalString(string sVarName);
// * Only needed while things are being implemented
// * Should be called ????;
void ClearDatabase();
// * Copies the specified variable from the Module to the database
void CopyVariableIntToDatabase(string sVar);
// * Copies all henchmen over
// *
void CopyAllHenchmen(object oPlayer);
// * Restore henchmen. THis function should be called after all other
// * database fetches because it destroys the database.
void RestoreAllHenchmen(location lLoc, object oPlayer);
// * Call this function as a wrapper for retrieving a henchman from hell
// * the henchmen should have been loaded in
void CallForthHenchman(string sTag, string sMemory);
// * ReStores all important variables that the
// * the henchmen may have on them  from db
void RestoreHenchmenVariables(object oHench);


// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
void SetGlobalInt(string sVarName, int nValue)
{
    SetLocalInt(GetModule(), sVarName, nValue);
    //SetCampaignInt("XP2_TEMP", sVarName, nValue);
}
// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
int GetGlobalInt(string sVarName)
{
//    return GetCampaignInt("XP2_TEMP", sVarName);
    return GetLocalInt(GetModule(), sVarName);
}

// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
void SetGlobalString(string sVarName, string sValue)
{
    // SetLocalInt(GetModule(), sVarName, nValue);
    //SetCampaignString("XP2_TEMP", sVarName, sValue);
    SetLocalString(GetModule(), sVarName, sValue);
}
// * Wrapper function for setting important variables in Chapter 2
// * This will eventually be modified to set the variables on the
// * database.
string GetGlobalString(string sVarName)
{
//    return GetCampaignString("XP2_TEMP", sVarName);
 return GetLocalString(GetModule(), sVarName);
}

// * Only needed while things are being implemented
// * Should be called ????
void ClearDatabase()
{
    DestroyCampaignDatabase("XP2_TEMP");
}

// * Copies the specified variable from the Module to the database
void CopyVariableIntToDatabase(string sVar)
{
    SetCampaignInt(DB_NAME, sVar, GetLocalInt(GetModule(), sVar));
}

// * Copies all henchmen over
// *
void CopyAllHenchmen(object oPlayer)
{
    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPlayer, i);
    while (GetIsObjectValid(oHench) == TRUE)
    {
        StoreCampaignObject(DB_NAME, "Henchmen" + IntToString(i), oHench, oPlayer);
        i++;
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPlayer, i);
    }
    // * if at least one henchman store the number of them
    if (i - 1 > 0)
    {
        SetCampaignInt(DB_NAME, "NumberofHenches", i - 1, oPlayer);
    }
}
void ReturnToChapter2()
{
    CopyAllHenchmen(GetEnteringObject());
    StartNewModule("XP2_Chapter2");

}
// * Restore henchmen. THis function should be called after all other
// * database fetches because it destroys the database.
void RestoreAllHenchmen(location lLoc, object oPlayer)
{
    int nMax = GetCampaignInt(DB_NAME, "NumberofHenches", oPlayer);
    int i = 0;
    object oHench = OBJECT_INVALID;
    for (i = 1; i <= nMax; i++)
    {
        oHench = RetrieveCampaignObject(DB_NAME, "Henchmen" + IntToString(i), lLoc, OBJECT_INVALID, oPlayer);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            RestoreHenchmenVariables(oHench);
            AddHenchman(oPlayer, oHench);
        }
    }
   DestroyCampaignDatabase(DB_NAME);
}

// * Call this function as a wrapper for retrieving a henchman from hell
// * the henchmen should have been loaded in
void CallForthHenchman(string sTag, string sMemory)
{
    ActionPauseConversation();
    object oPC = GetPCSpeaker();
    location lPC = GetLocation(oPC);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //object oDeekin = RetrieveCampaignObject(DB_NAME, sDbVar, GetLocation(oPC), OBJECT_INVALID, OBJECT_SELF);
    object oDeekin = GetObjectByTag(sTag);
    AssignCommand(oDeekin, JumpToLocation(lPC));
    DelayCommand(0.2, AssignCommand(oDeekin, JumpToLocation(lPC))); // * redundancy*
    DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oDeekin)));
    SetLocalInt(GetModule(), sMemory, 1);
    int nCount = X2_GetNumberOfHenchmen(oPC);
    if (nCount < 2)
        AddHenchman(oPC, oDeekin);
    ActionResumeConversation();
}
// * Returns whether player betrayed nathyrra
int PCBetrayedNathyrra()
{
    // * the variable should have already been copied over
    if (GetLocalInt(GetModule(), "PC_BETRAY_NAT") == 1)
    {
        return TRUE;
    }
    return FALSE;
}
// * Returns whether player betrayed nathyrra
int PCBetrayedValen()
{
    // * the variable should have already been copied over
    if (GetLocalInt(GetModule(), "PC_BETRAY_VAL") == 1)
    {
        return TRUE;
    }
    return FALSE;
}
// * Store/Restore used as a quick short-cut to save and the load the GetModule() globals
void StoreInt(string sVarName)
{
   SetCampaignInt(DB_NAME, sVarName, GetLocalInt(GetModule(), sVarName));
}
void RestoreInt(string sVarName)
{
   SetLocalInt(GetModule(), sVarName, GetCampaignInt(DB_NAME, sVarName));

}
// * gets an int from an object other than the module
void StoreIntFromObject(string sVarName, object oSelf)
{
   SetCampaignInt(DB_NAME, sVarName, GetLocalInt(oSelf, sVarName), oSelf);
}
// * gets an int from an object other than the module
void RestoreIntFromObject(string sVarName, object oSelf)
{
   SetLocalInt(oSelf, sVarName, GetCampaignInt(DB_NAME, sVarName, oSelf));

}
void StoreString(string sVarName)
{
   SetCampaignString(DB_NAME, sVarName, GetLocalString(GetModule(), sVarName));
}
void RestoreString(string sVarName)
{
   SetLocalString(GetModule(), sVarName, GetCampaignString(DB_NAME, sVarName));

}

// * Stores all important variables that the
// * the henchmen may have on them  into the database
// * Must be careful in this function to avoid strings that are too long...
void StoreHenchmenVariables(object oHench)
{
     string sTag = GetTag(oHench);
     SetCampaignInt(DB_NAME, sTag+"X2_FIRE_C1", GetLocalInt(oHench, "X2_FIRE_C1"));
     SetCampaignInt(DB_NAME, sTag+"X2_FIRE_C2", GetLocalInt(oHench, "X2_FIRE_C2"));
     SetCampaignInt(DB_NAME, sTag+"X2_FIRE_C3", GetLocalInt(oHench, "X2_FIRE_C3"));

     SetCampaignInt(DB_NAME, sTag+"X2_WHIRLPERCENT", GetLocalInt(oHench, "X2_WHIRLPERCENT"));


     string sRandomOnes =  GetLocalString(oHench, "X2_L_RANDOMONELINERS");
     SetCampaignString(DB_NAME, sTag+"ONELINERS", sRandomOnes);
     sRandomOnes = GetLocalString(oHench, "X2_L_RANDOM_INTERJECTIONS");
     SetCampaignString(DB_NAME, sTag+"INTERJECTIONS", sRandomOnes);

     SetCampaignInt(DB_NAME, sTag+"RULE", GetLocalInt(oHench, "X0_L_LEVELRULES"));
     SetCampaignInt(DB_NAME, sTag+"NW_MODES_CONDITION", GetLocalInt(oHench, "NW_MODES_CONDITION"));
     SetCampaignInt(DB_NAME, sTag+"X2_L_STOPCASTING", GetLocalInt(oHench, "X2_L_STOPCASTING"));
     SetCampaignInt(DB_NAME, sTag+"STEALTH", GetLocalInt(oHench, "X2_HENCH_STEALTH_MODE"));
     SetCampaignInt(DB_NAME, sTag+"DISPEL", GetLocalInt(oHench, "X2_HENCH_DO_NOT_DISPEL"));


}

// * ReStores all important variables that the
// * the henchmen may have on them  from db
void RestoreHenchmenVariables(object oHench)
{
    string sTag = GetTag(oHench);
     SetLocalInt(oHench, "X2_FIRE_C1", GetCampaignInt(DB_NAME, sTag+"X2_FIRE_C1"));
     SetLocalInt(oHench, "X2_FIRE_C2", GetCampaignInt(DB_NAME, sTag+"X2_FIRE_C2"));
     SetLocalInt(oHench, "X2_FIRE_C3", GetCampaignInt(DB_NAME, sTag+"X2_FIRE_C3"));

    SetLocalInt(oHench, "X2_WHIRLPERCENT", GetCampaignInt(DB_NAME, sTag+"X2_WHIRLPERCENT"));

 //       SpawnScriptDebugger();
     string sOneLiner = GetCampaignString(DB_NAME, sTag+"ONELINERS");
     SetLocalString(oHench, "X2_L_RANDOMONELINERS", sOneLiner);
     SetLocalString(oHench, "X2_L_RANDOM_INTERJECTIONS", GetCampaignString(DB_NAME, sTag+"INTERJECTIONS"));

     SetLocalInt(oHench, "NW_MODES_CONDITION", GetCampaignInt(DB_NAME, sTag+"NW_MODES_CONDITION"));
     SetLocalInt(oHench, "X2_L_STOPCASTING", GetCampaignInt(DB_NAME, sTag+"X2_L_STOPCASTING"));
     SetLocalInt(oHench, "X0_L_LEVELRULES", GetCampaignInt(DB_NAME, sTag+"RULE"));
     SetLocalInt(oHench, "X2_HENCH_STEALTH_MODE", GetCampaignInt(DB_NAME, sTag+"STEALTH"));
     SetLocalInt(oHench, "X2_HENCH_DO_NOT_DISPEL", GetCampaignInt(DB_NAME, sTag+"DISPEL"));


}

object WrapCopyItem(object oItem, object oTarget, int bIgnoreCursedAndNoDrop=FALSE)
{
    int bAllowedToCopy = TRUE;
    if (bIgnoreCursedAndNoDrop == TRUE)
    {
        // * if I don't want to copy plot or cursed items, then do not.
        if (GetPlotFlag(oItem) == TRUE || GetItemCursedFlag(oItem) == TRUE)
        {
            bAllowedToCopy = FALSE;
        }
    }
    if (bAllowedToCopy == TRUE)
    {
        return CopyItem(oItem, oTarget, TRUE);
    }
    return OBJECT_INVALID;
}
// * copies everything from oSource's inventory into oTarget
// * can be used with either Creatures or Stores
// * does not destroy original
// bIgnoreCursedAndNoDrop - set this flag to true if you don't want things like henchmen items copied
void CopyInventory(object oSource, object oTarget, int bIgnoreCursedAndNoDrop=FALSE)
{
    object oItem;
    if (GetObjectType(oSource) == OBJECT_TYPE_CREATURE)
    {
        int i = 0;
        // * go through all equipped slots
        for (i = INVENTORY_SLOT_HEAD; i <= INVENTORY_SLOT_BOLTS; i++)
        {
            oItem = GetItemInSlot(i, oSource);
            if (GetIsObjectValid(oItem) == TRUE)
            {
                WrapCopyItem(oItem, oTarget, bIgnoreCursedAndNoDrop);
            }
        }
    }
    
    // * copy repository
    oItem = GetFirstItemInInventory(oSource);
    object oJunkItem;
    
    while (GetIsObjectValid(oItem) == TRUE)
    {
        oJunkItem = WrapCopyItem(oItem, oTarget, bIgnoreCursedAndNoDrop);
        oItem = GetNextItemInInventory(oSource);
    }
}
// * used at start of c2 and c3 to "blank" the genie store.
void RemoveInventory(object oStore)
{
    object oItem = GetFirstItemInInventory(oStore);
    string sTag = "";
    
    while (GetIsObjectValid(oItem) == TRUE)
    {
        // * hack to keep infinite rogue stones and other disposables in
        sTag = GetTag(oItem);
        if (sTag != "x2_p_rogue" && sTag != "NW_IT_MEDKIT003" && sTag != "NW_IT_MEDKIT004" && sTag !="NW_IT_MPOTION011"
         && sTag !="NW_IT_SPDVSCR401")
            DestroyObject(oItem, 0.1);
        oItem = GetNextItemInInventory(oStore);
    }
}

// * Copies the original 4 henchmen inventories into the Pool of Lost Souls
void CopyOriginalFourInventory()
{
//SpawnScriptDebugger();
    // * Get henchman
    // * cycle through inventory, copying it all
    object oCritter = GetObjectByTag("x2_hen_tomi");
    object oStore = GetObjectByTag("LostItems");
    
    CopyInventory(oCritter, oStore, TRUE);
    oCritter = GetObjectByTag("x2_hen_linu");
    CopyInventory(oCritter, oStore, TRUE);
    oCritter = GetObjectByTag("x2_hen_sharwyn");
    CopyInventory(oCritter, oStore, TRUE);
    oCritter = GetObjectByTag("x2_hen_daelan");
    CopyInventory(oCritter, oStore, TRUE);
}

// * Copies the Pool of Lost Souls
void StorePoolOfLostSouls(object oPC)
{
    object oStore = GetObjectByTag("LostItems");
                // * since stores cannot be stored to the database
            // * transfer items to a deep rothe and move it across.
            // * Seriously.
            object oRothe = CreateObject(OBJECT_TYPE_CREATURE, "x2_deeprothe001", GetLocation(oStore));
            CopyInventory(oStore, oRothe);
            oStore = oRothe;

    StoreCampaignObject(DB_NAME, "Pool_OF_LOST", oStore, oPC);
}
// * Copies the Pool of Lost Souls  into the place of the existing one in the module
object RestorePoolOfLostSouls(object oPC)
{   //  SpawnScriptDebugger();
    object oStore = GetObjectByTag("LostItems");
    location lStore = GetLocation(oStore);

    object oNewStore = RetrieveCampaignObject(DB_NAME, "Pool_OF_LOST", lStore, oPC);
    CopyInventory(oNewStore, oStore);
    DestroyObject(oNewStore, 0.5);
    return oStore;
}

void StoreWeaponInt(object oPC, string sVarName)
{
    // * the variable stored globally uses
    // * the player's name
    // * but this is too long to store on the database
    string sName = GetName(oPC) + sVarName;
    int nValue = GetLocalInt(GetModule(), sName);
    // * store it using shorter name
    StoreInt(sVarName);
}
void RestoreWeaponInt(object oPC, string sVarName)
{
    int nValue = GetCampaignInt(DB_NAME, sVarName);
    SetLocalInt(GetModule(), GetName(oPC) + sVarName, nValue);
}
// * stores the variables for the intelligent weapon
void StoreWeaponVars(object oPC)
{
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_1x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_2x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_3x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_4x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_5x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_6x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_7x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_8x2_iw_enserric");
    StoreWeaponInt(oPC, "X2_L_IW_ASKED_9x2_iw_enserric");
}
// * restores weapon variables
void RestoreWeaponVars(object oPC)
{
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_1x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_2x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_3x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_4x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_5x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_6x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_7x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_8x2_iw_enserric");
    RestoreWeaponInt(oPC, "X2_L_IW_ASKED_9x2_iw_enserric");
}
