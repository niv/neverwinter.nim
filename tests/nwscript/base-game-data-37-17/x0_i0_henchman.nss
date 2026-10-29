//:://////////////////////////////////////////////////
//:: X0_I0_HENCHMAN
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*

 * MODIFIED April 2/03
 * Make is so when a henchmen is hired he automatically levels up to
 * the level of his master

 * MODIFIED 2/4/2000
 * Added a hack to HireHenchman so that it will skip some problem areas
 * that might surface with my 'keeping the henchman' stuff in the death script.
 * Felt it was worth it because now you can use potions to bring the henchman back.

 * MODIFIED 1/31/2003
 * Removed the SetAdditionalListeningPatterns function because this
 * library will now be included in x0_inc_henai, so we can just include
 * that and then use bkSetListeningPatterns in the henchman spawn script.
 *
 * MODIFIED 1/3/2003
 * Removed personal item code and added code to handle setting up
 * henchmen using campaign variables instead of local variables,
 * so the information will persist between modules. Also added
 * code for storing/retrieving henchman as you move between sequel
 * modules.
 *
 * MODIFIED 12/6/2002
 * Added functions to handle henchman death. Henchmen do not die normally;
 * they are insta-resurrected to 1 HP and are kept there, playing the 'dead'
 * animation, until time runs out, the master flees the area/dies, or the
 * master heals the henchman.
 *
 * MODIFIED 11/16/2002
 * Added a new function, "SetAdditionalListeningPatterns", to set the
 * added listening patterns for the new henchman AI from Bioware.
 * Since only our OnSpawn script needs to be different, it's easier to
 * duplicate this one function.
 *
 * IMPORTANT NOTE:
 * This include file REPLACES the original henchman include file from
 * campaign one; both should not be included in the same script.
 * Many functions here have the same names/parameters as functions
 * from Bioware's henchman include file to facilitate code reuse,
 * so dual includes will result in major compile errors due to
 * function redefinition.
 *
 * ** Function behavior may and does differ from the originals. **
 *
 * The primary difference is that X0 henchmen can be hired by
 * more than one person during the course of the game. The
 * current master of the henchman will be stored in a local var
 * on the henchman itself; campaign variables on the player will
 * indicate whether the player has ever hired the henchman.
 *
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/12/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"
#include "nw_i0_plot"
#include "nw_i0_generic"
#include "nw_i0_spells"


/**********************************************************************
 * CONSTANTS
 **********************************************************************/

/**** Number of henchmen ****/
const int X0_NUMBER_HENCHMEN = 3;

const int X2_NUMBER_HENCHMEN = 2; // This won't be the same as the GetMaxHenchmen() function due to followers


/**** XP1 Henchmen tags ****/
const string sDeekin = "X0_HEN_DEE";
const string sDorna = "X0_HEN_DOR";
const string sXandos = "X0_HEN_XAN";

/**** variable names and suffixes ****/
const string sHenchmanDeathVarname = "NW_L_HEN_I_DIED";
const string sIsHiredVarname = "X0_IS_CURRENTLY_HIRED";
const string sLastMasterVarname = "X0_LAST_MASTER_TAG";
const string sHenchmanKilledSuffix = "_GOTKILLED";
const string sHenchmanResurrectedSuffix = "_RESURRECTED";
const string sHenchmanDyingVarname = "X0_HEN_IS_DYING";
const string sStoredHenchmanVarname = "X0_HEN_STORED";

// Amount of time to pass between respawn checks
const float DELAY_BETWEEN_RESPAWN_CHECKS = 3.0f;

// * duration henchmen play their die animations
const float HENCHMEN_DIE_ANIM_DURATION = 6500000000.0f;

// The maximum length of the wait before respawn
const float MAX_RESPAWN_WAIT = 60.0f;

/**** Script names ****/
const string sGoHomeScript = "x0_ch_hen_gohome";



/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

/**** GENERAL FUNCTIONS ****/

// Copy all henchman-related local variables from source to target.
// Used when henchmen level up to keep variables consistent between
// the two copies of the henchman.
// This is a good function to look at to see what the local variables
// used on henchmen are.
void CopyHenchmanLocals(object oSource, object oTarget);

/**** GREETING & MEETING FUNCTIONS ****/

// Use when the player first meets the henchman/NPC
// This uses local variables, not campaign variables.
void SetHasMet(object oPC, object oHench=OBJECT_SELF);

// Returns TRUE if the player has met this henchman
// This uses local variables, not campaign variables.
int GetHasMet(object oPC, object oHench=OBJECT_SELF);


/**** HIRING FUNCTIONS ****/

// Can be used for both initial hiring and rejoining.
void HireHenchman(object oPC, object oHench=OBJECT_SELF, int bAdd=TRUE);

// Use to fire the henchman
void FireHenchman(object oPC, object oHench=OBJECT_SELF);

// Used when the henchman quits
void QuitHenchman(object oPC, object oHench=OBJECT_SELF);

// Returns TRUE if the henchman is currently hired
int GetIsHired(object oHench=OBJECT_SELF);

// Set the last master
void SetLastMaster(object oPC, object oHench=OBJECT_SELF);

// Returns the last master of this henchman (useful for death situations)
object GetLastMaster(object oHench=OBJECT_SELF);

// Indicate whether the player has ever hired this henchman
void SetPlayerHasHired(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE);

// Determine whether the player has ever hired this henchman
int GetPlayerHasHired(object oPC, object oHench=OBJECT_SELF);

// Indicate whether the player has ever hired this henchman in this
// campaign.
void SetPlayerHasHiredInCampaign(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE);

// Indicate whether the player has ever hired this henchman in this
// campaign.
int GetPlayerHasHiredInCampaign(object oPC, object oHench=OBJECT_SELF);

// Determine whether the henchman is currently working
// for this PC.
int GetWorkingForPlayer(object oPC, object oHench=OBJECT_SELF);

// Set whether the henchman quit this player's employ
void SetDidQuit(object oPC, object oHench=OBJECT_SELF, int bQuit=TRUE);

// Determine if the henchman quit
int GetDidQuit(object oPC, object oHench=OBJECT_SELF);

/**** LEVELING UP ****/

// Checks to see if the henchman can level up.
// Can only level up if player is 2 or more levels
// higher than henchman.
//  MAX = Level 14
int GetCanLevelUp(object oPC, object oHench = OBJECT_SELF);

// Levels the henchman up to be one level less than player.
// Returns the new creature.
object DoLevelUp(object oPC, object oHench = OBJECT_SELF);

// Store all items in the henchman's inventory in the campaign DB,
// skipping those items which have the henchman's tag in their
// name.
// This is paired with RetrieveHenchmanItems for the leveling-up
// process.
void StoreHenchmanItems(object oPC, object oHench);

// Retrieve (and then delete) all henchman inventory items out of
// the campaign DB, putting them in the inventory of the henchman.
// This is paired with StoreHenchmanItems for the leveling-up
// process.
void RetrieveHenchmanItems(object oPC, object oHench);

/*** DEATH FUNCTIONS ***/
// * Wrapper function added to fix bugs in the dying-state
// * process. Need to figure out whenever his value changes.
void SetHenchmanDying(object oHench=OBJECT_SELF, int bIsDying=TRUE);


// Set on the henchman to indicate s/he died; can also be used to
// unset this variable.
void SetDidDie(int bDie=TRUE, object oHench=OBJECT_SELF);

// Returns TRUE if the henchman died.
// UNLIKE original, does NOT reset the value -- use
// SetDidDie(FALSE) to do that.
int GetDidDie(object oHench=OBJECT_SELF);

// Set got killed
void SetKilled(object oPC, object oHench=OBJECT_SELF, int bKilled=TRUE);

// Determine if this PC got the henchman killed
int GetKilled(object oPC, object oHench=OBJECT_SELF);

// Set that this PC resurrected the henchman
void SetResurrected(object oPC, object oHench=OBJECT_SELF, int bResurrected=TRUE);

// Determine if this PC resurrected the henchman
int GetResurrected(object oPC, object oHench=OBJECT_SELF);

// Respawn the henchman, by preference at the master's current
// respawn point, or at the henchman's starting location otherwise.
void RespawnHenchman(object oHench=OBJECT_SELF);

// Keep dead by playing the appropriate death animation for the
// maximum wait until respawn.
void KeepDead(object oHench=OBJECT_SELF);

// Stop keeping dead by playing the 'woozy' standing animation.
void StopKeepingDead(object oHench=OBJECT_SELF);

// Raise and freeze henchman to 1 hp so s/he can be stabilized
void RaiseForRespawn(object oPC, object oHench=OBJECT_SELF);

// See if our maximum wait time has passed
int GetHasMaxWaitPassed(int nChecks);

// Do the checking to see if we respawn -- this function works
// in a circle with DoRespawnCheck.
void RespawnCheck(object oPC, int nChecks=0, object oHench=OBJECT_SELF);

// Perform a single respawn check -- this function works
// in a circle with RespawnCheck.
void DoRespawnCheck(object oPC, int nChecks, object oHench=OBJECT_SELF);

// This function actually invokes the respawn.
void DoRespawn(object oPC, object oHench=OBJECT_SELF);

// Set up before the respawn
void PreRespawnSetup(object oHench=OBJECT_SELF);

// Clean up after the respawn.
void PostRespawnCleanup(object oHench=OBJECT_SELF);

// Determine if this henchman is currently dying
int GetIsHenchmanDying(object oHench=OBJECT_SELF);

// levels up the henchman assigned to oPC
void LevelUpXP1Henchman(object oPC);


/***** MODULE TRANSFER FUNCTIONS *****/

// Call this function when the PC is about to leave a module
// to enable restoration of the henchman on re-entry into the
// sequel module. Both modules must use the same campaign db
// for this to work.
void StoreCampaignHenchman(object oPC);

// Call this function when a PC enters a sequel module to restore
// the henchman (complete with inventory). The function
// StoreCampaignHenchman must have been called first, and both
// modules must use the same campaign db. (See notes in x0_i0_campaign.)
//
// The restored henchman will automatically be re-hired and will be
// created next to the PC.
void RetrieveCampaignHenchman(object oPC);

// Levels a henchman up to the given level, alternating
// between the first and second classes if they are multiclassed.
void LevelHenchmanUpTo(object oHenchman, int nLevel, int nClass2=CLASS_TYPE_INVALID, int nMaxLevelInSecondClass=0, int nPackageClass1=PACKAGE_INVALID, int nPackageClass2=PACKAGE_INVALID);

// *returns true if oHench is a follower
int GetIsFollower(object oHench);
// * sets whether oHench is a follower or not
void SetIsFollower(object oHench, int bValue=TRUE);
// * removes all followers
// * if bRemoveAll=TRUe then remove normal hencies too
void RemoveAllFollowers(object oPC, int bRemoveAll = FALSE);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// * had to add this commandable wrapper to track down a bug in the henchmen
void WrapCommandable(int bCommand, object oHench)
{
/*   string s ="";
    if (bCommand)
        s = "TRUE";
    else
        s = "FALSE";
    SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + " commandable set to " + s);*/
    while (GetCommandable(oHench) != bCommand)
    {
        SetCommandable(bCommand, oHench);
    }
}

void brentDebug(string s)
{
   // SendMessageToPC(GetFirstPC(), s);
}

/**** GENERAL FUNCTIONS ****/

// Copy all henchman-related local variables from source to target.
// Used when henchmen level up to keep variables consistent between
// the two copies of the henchman.
// This is a good function to look at to see what the local variables
// used on henchmen are.
void CopyHenchmanLocals(object oSource, object oTarget)
{
    if ( !GetIsObjectValid(oTarget) || !GetIsObjectValid(oSource))
        return;

    // This copies over our current associate state, so we
    // keep whatever settings we had before.
    SetLocalInt(oTarget,
                sAssociateMasterConditionVarname,
                GetLocalInt(oSource, sAssociateMasterConditionVarname));

}


/**** GREETING & MEETING FUNCTIONS ****/

// Use when the player first meets the henchman
void SetHasMet(object oPC, object oHench=OBJECT_SELF)
{
    SetBooleanValue(oPC, GetTag(oHench) + sHasMetSuffix);
}

// Returns TRUE if the player has met this henchman
int GetHasMet(object oPC, object oHench=OBJECT_SELF)
{
    return GetBooleanValue(oPC, GetTag(oHench) + sHasMetSuffix);
}


/**** HIRING FUNCTIONS ****/

// *returns true if oHench is a follower
int GetIsFollower(object oHench)
{
    return GetLocalInt(oHench, "X2_JUST_A_FOLLOWER");
}
// * sets whether oHench is a follower or not
void SetIsFollower(object oHench, int bValue=TRUE)
{
    SetLocalInt(oHench, "X2_JUST_A_FOLLOWER", bValue);
}

// * removes all followers
// * if bRemoveAll=true, it removes
// * all henchmen.
void RemoveAllFollowers(object oPC, int bRemoveAll = FALSE)
{
    //int bDone = FALSE;
    object oHench = OBJECT_INVALID;
    int i = 0;
    int j;

    // * have to count down because creatures are being deleted
    for (j=10; j>0; j--)
    {
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, j);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            // * if the creature is marked as a follower
            // * dump them
            if ( (GetIsFollower(oHench) == TRUE) || (bRemoveAll == TRUE))
            {
                // * Take them out of stealth mode too (Nov 1 - BK)
                SetActionMode(oHench, ACTION_MODE_STEALTH, FALSE);
                // * Remove invisibility type effects off of henchmen (Nov 7 - BK)
                RemoveSpellEffects(SPELL_INVISIBILITY, oHench, oHench);
                RemoveSpellEffects(SPELL_IMPROVED_INVISIBILITY, oHench, oHench);
                RemoveSpellEffects(SPELL_SANCTUARY, oHench, oHench);
                RemoveSpellEffects(SPELL_ETHEREALNESS, oHench, oHench);

                FireHenchman(oPC, oHench);
                //bDone = TRUE;
            }
        }
    }

}

// * count number of henchman
// * if nFollowersInstead = TRUE then count the # of
int X2_GetNumberOfHenchmen(object oPC, int bFollowersInstead=FALSE)
{
    int i = 1;
    int nCount = 0;
    int bDone = FALSE;
    object oHench = OBJECT_INVALID;

    do
    {
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
        i++;
        if (GetIsObjectValid(oHench) == TRUE)
        {
            // * if the creature is marked as a follower
            // * they do not count against the henchman limit
            if (bFollowersInstead == FALSE && GetIsFollower(oHench) == FALSE)
                nCount++;
            else
            if (bFollowersInstead == TRUE && GetIsFollower(oHench) == TRUE)
               nCount++;
        }
        else
        {
            bDone = TRUE;
        }
    }
    while (bDone == FALSE);

    return nCount;

}

// * Fires the first henchman who is not
// * a follower
void X2_FireFirstHenchman(object oPC)
{
    int i = 1;
    int bDone = FALSE;
    object oHench = OBJECT_INVALID;

    do
    {
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
        i++;
        if (GetIsObjectValid(oHench) == TRUE)
        {
            // * if the creature is marked as a follower
            // * they do not count against the henchman limit
            if (GetIsFollower(oHench) == FALSE)
            {
                FireHenchman(oPC, oHench);
                bDone = TRUE;
            }
        }
        else
        {
            bDone = TRUE;
        }
    }
    while (bDone == FALSE);


}
// Can be used for both initial hiring and rejoining.
void HireHenchman(object oPC, object oHench=OBJECT_SELF, int bAdd=TRUE)
{
    if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
    {
        return;
    }
//    SpawnScriptDebugger();

    // Fire the PC's former henchman if necessary
//    object oFormerHench = GetAss*ociate(ASSOCIATE_TYPE_HENCHMAN, oPC, 1);
    int nCountHenchmen = X2_GetNumberOfHenchmen(oPC);
    int nNumberOfFollowers = X2_GetNumberOfHenchmen(oPC, TRUE);
    // * The true number of henchmen are the number of hired
    nCountHenchmen = nCountHenchmen ;

    int nMaxHenchmen = X2_NUMBER_HENCHMEN;

    // Adding this henchman would exceed the module imposed
    // henchman limit.
    // Fire the first henchman
    // The third slot is reserved for the follower
    if ( (nCountHenchmen  >= nMaxHenchmen) && bAdd == TRUE)
    {
        X2_FireFirstHenchman(oPC);
    }

/*    if (GetIsObjectValid(oFormerHench) && bAdd == TRUE)
    {
        DBG_msg("Firing former henchman");
        FireHenchman(oPC, oFormerHench);
    }
    else
    {
        DBG_msg("No valid former henchman");
    }
*/
    // Mark the henchman as working for the given player
    if (!GetPlayerHasHired(oPC, oHench))
    {
        // This keeps track if the player has EVER hired this henchman
        // Floodgate only (XP1). Should never store info to a database as game runs, only between modules or in Persistent setting
        if (GetLocalInt(GetModule(), "X2_L_XP2") !=  1)
        {
            SetPlayerHasHiredInCampaign(oPC, oHench);
        }
        SetPlayerHasHired(oPC, oHench);
    }
    SetLastMaster(oPC, oHench);

    // Clear the 'quit' setting in case we just persuaded
    // the henchman to rejoin us.
    SetDidQuit(oPC, oHench, FALSE);

    // If we're hooking back up with the henchman after s/he
    //  died, clear that.
    SetDidDie(FALSE, oHench);
    SetKilled(oPC, oHench, FALSE);
    SetResurrected(oPC, oHench, FALSE);

    // Turn on standard henchman listening patterns
    SetAssociateListenPatterns(oHench);

    // By default, companions come in with Attack Nearest and Follow
    // modes enabled.
    SetLocalInt(oHench,
                "NW_COM_MODE_COMBAT",ASSOCIATE_COMMAND_ATTACKNEAREST);
    SetLocalInt(oHench,
                "NW_COM_MODE_MOVEMENT",ASSOCIATE_COMMAND_FOLLOWMASTER);

    // Add the henchman
    if (bAdd == TRUE)
    {
        AddHenchman(oPC, oHench);
        DelayCommand(1.0, AssignCommand(oHench, LevelUpXP1Henchman(oPC)));
    }

}

// Use to fire the PC's current henchman
void FireHenchman(object oPC, object oHench=OBJECT_SELF)
{
    if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
    {
        //DBG_msg("Invalid PC or henchman!");
        return;
    }
    // * turn off stealth mode
    SetActionMode(oHench, ACTION_MODE_STEALTH, FALSE);
    // If we're firing the henchman after s/he died,
    // clear that first, since we're not really "hired"
    SetDidDie(FALSE, oHench);
    SetKilled(oPC, oHench, FALSE);
    SetResurrected(oPC, oHench, FALSE);

    // Now double-check that this is actually our master
    if (!GetIsHired(oHench) || GetMaster(oHench) != oPC)
    {
        //DBG_msg("FireHenchman: not hired or this PC isn't her master.");
        return;
    }

    // Remove the henchman
    AssignCommand(oHench, ClearActions(CLEAR_X0_I0_HENCHMAN_Fire));
    RemoveHenchman(oPC, oHench);

    //Store former henchmen for retrieval in Interlude
    // April 28 2003. This storage only happens in Chapter 1
    string sModTag = GetTag(GetModule());
    if (sModTag == "x0_module1")
    {
        if (GetTag(oHench) == "x0_hen_xan")
            StoreCampaignObject("dbHenchmen", "xp0_hen_xan", oHench);
        else if (GetTag(oHench) == "x0_hen_dor")
            StoreCampaignObject("dbHenchmen", "xp0_hen_dor", oHench);
    }

    //DBG_msg("Removed henchman");
    // Clear everything that was previously set, EXCEPT
    // that the player has hired -- that info we want to
    // keep for the future.

    // Clear this out so if the henchman gets killed while
    // unhired, she won't think this PC is still her master
    SetLastMaster(OBJECT_INVALID, oHench);

    // Clear dialogue events
    ClearAllDialogue(oPC, oHench);

    // Send the henchman home
    // APril 2003: Cut this. Make them stay where they are.
   // ExecuteScript(sGoHomeScript, oHench);
}

// Used when the henchman quits
void QuitHenchman(object oPC, object oHench=OBJECT_SELF)
{
    SetDidQuit(oPC, oHench, TRUE);
    FireHenchman(oPC, oHench);
}


// Returns TRUE if the henchman is currently hired
int GetIsHired(object oHench=OBJECT_SELF)
{
    return GetIsObjectValid(GetMaster(oHench));
}

// Set the last master
void SetLastMaster(object oPC, object oHench=OBJECT_SELF)
{
    //DBG_msg("Set last master to " + GetName(oPC));
    SetLocalObject(oHench, sLastMasterVarname, oPC);
}

// Returns the last master of this henchman (useful for death situations)
object GetLastMaster(object oHench=OBJECT_SELF)
{
    //DBG_msg("Getting last master: "
    //        + GetName(GetLocalObject(oHench, sLastMasterVarname)));
    return GetLocalObject(oHench, sLastMasterVarname);
}

// Indicate whether the player has ever hired this henchman
void SetPlayerHasHired(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE)
{
    if (!GetIsObjectValid(oHench)) {return;}
    SetBooleanValue(oPC, GetTag(oHench) + sHasHiredSuffix, bHired);
}

// Determine whether the player has ever hired this henchman
int GetPlayerHasHired(object oPC, object oHench=OBJECT_SELF)
{
    if (!GetIsObjectValid(oHench)) {return FALSE;}
    return GetBooleanValue(oPC, GetTag(oHench) + sHasHiredSuffix);
}


// Indicate whether the player has ever hired this henchman in this
// campaign.
void SetPlayerHasHiredInCampaign(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE)
{
    if (!GetIsObjectValid(oHench)) {return;}
    SetCampaignBooleanValue(oPC, GetTag(oHench) + sHasHiredSuffix, bHired);
}

// Indicate whether the player has ever hired this henchman in this
// campaign.
int GetPlayerHasHiredInCampaign(object oPC, object oHench=OBJECT_SELF)
{
    if (!GetIsObjectValid(oHench)) {return FALSE;}
    return GetCampaignBooleanValue(oPC, GetTag(oHench) + sHasHiredSuffix);
}



// Determine whether the henchman is currently working
// for this PC.
int GetWorkingForPlayer(object oPC, object oHench=OBJECT_SELF)
{
    if (!GetIsObjectValid(oHench) || !GetIsObjectValid(oPC)) {return FALSE;}
    return (GetMaster(oHench) == oPC);
}

// Set whether the henchman quit this player's employ
void SetDidQuit(object oPC, object oHench=OBJECT_SELF, int bQuit=TRUE)
{
    if (!GetIsObjectValid(oHench)) {return;}
    SetBooleanValue(oPC, GetTag(oHench) + sDidQuitSuffix, bQuit);
}

// Determine if the henchman quit
int GetDidQuit(object oPC, object oHench=OBJECT_SELF)
{
    if (!GetIsObjectValid(oHench)) {return FALSE;}
    return GetBooleanValue(oPC, GetTag(oHench) + sDidQuitSuffix);
}

/**** LEVELING UP ****/

// Checks to see if the henchman can level up.
// Can only level up if player is 2 or more levels
// higher than henchman.
//  MIN = Level 4
//  MAX = Level 14
int GetCanLevelUp(object oPC, object oHench = OBJECT_SELF)
{
//    SpeakString("This function no longer does nothing. Should not be called");
    return FALSE;
}

// Levels the henchman up to be one level less than player.
// Returns the new creature.
object DoLevelUp(object oPC, object oHench = OBJECT_SELF)
{
//    SpeakString("This function no longer does anything. Should not be called");
    return OBJECT_INVALID;
}

// Store all items in the henchman's inventory in the campaign DB.
void StoreHenchmanItems(object oPC, object oHench)
{
    string sHenchTag = GetTag(oHench);

    string sTag;
    object oItem;
    int nNth = 0;
    string sItemName; string sVarname;

    // Mark and store equipped items
    int i;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++) {
        oItem = GetItemInSlot(i, oHench);
        if (GetIsObjectValid(oItem)) {
            sItemName = GetTag(oItem);
            //DBG_msg("Found equipped item " + sItemName);

            // store the slot number + 1 so when we
            // retrieve a 0 can be treated as unequipped
            SetLocalInt(oPC, "HENCH_HAS_EQUIPPED_" + sItemName, i+1);

            if (FindSubString(sItemName, sHenchTag) == -1) {
                // put it in the db
                sVarname = sHenchTag + "_ITEM_" + IntToString(nNth);
                //DBG_msg("Storing equipped item: " + sItemName
                //        + ", varname " + sVarname);
                nNth++;
                StoreCampaignDBObject(oPC, sVarname, oItem);
            }
        }
    }

    // Store all the henchman inventory in the campaign db
    oItem = GetFirstItemInInventory(oHench);
    while (GetIsObjectValid(oItem)) {
        sItemName = GetTag(oItem);
        //DBG_msg("Found item " + sItemName);
        if (FindSubString(sItemName, sHenchTag) == -1) {
            // put it in the db
            sVarname = sHenchTag + "_ITEM_" + IntToString(nNth);
            //DBG_msg("Storing item: " + sItemName + ", varname " + sVarname);
            nNth++;
            StoreCampaignDBObject(oPC, sVarname, oItem);
        }

        oItem = GetNextItemInInventory(oHench);
    }
}


// Retrieve (and then delete) all henchman inventory items out of
// the campaign DB, putting them in the inventory of the henchman.
void RetrieveHenchmanItems(object oPC, object oHench)
{
    location lHench  = GetLocation(oHench);
    string sHenchTag = GetTag(oHench);
    int nNth = 0; int nSlot = -1;
    object oCurItem = OBJECT_INVALID;

    string sVarname = sHenchTag + "_ITEM_0";

    object oItem = RetrieveCampaignDBObject(oPC, sVarname, lHench, oHench);
    string sItemName = GetTag(oItem);

    //DBG_msg("Retrieving item " + sItemName + ", varname: " + sVarname);
    while (GetIsObjectValid(oItem)) {
        DeleteCampaignDBVariable(oPC, sVarname);
        nNth++;
        sVarname = sHenchTag + "_ITEM_" + IntToString(nNth);
        oItem = RetrieveCampaignDBObject(oPC, sVarname, lHench, oHench);
        sItemName = GetTag(oItem);
        //DBG_msg("Retrieving item " + sItemName + ", varname: " + sVarname);
    }

    // Now run through inventory and restore equipped items
    oItem = GetFirstItemInInventory(oHench);
    while (GetIsObjectValid(oItem)) {
        sItemName = GetTag(oItem);

        // Above, we stored the slot + 1 so we could treat a 0
        // as meaning "not equipped".
        nSlot = GetLocalInt(oPC, "HENCH_HAS_EQUIPPED_" + sItemName) - 1;
        if (nSlot != -1) {
            //DBG_msg("Item was equipped in slot " + IntToString(nSlot));
            DeleteLocalInt(oPC, "HENCH_HAS_EQUIPPED_" + sItemName);
            oCurItem = GetItemInSlot(nSlot, oHench);
            if (GetIsObjectValid(oCurItem)) {
                AssignCommand(oHench, ActionUnequipItem(oCurItem));
            }
            AssignCommand(oHench, ActionEquipItem(oItem, nSlot));
        }
        oItem = GetNextItemInInventory(oHench);
    }
}


/*** DEATH FUNCTIONS ***/

// Set on the henchman to indicate s/he died; can also be used to
// unset this variable.
void SetDidDie(int bDie=TRUE, object oHench=OBJECT_SELF)
{
    SetBooleanValue(oHench, sHenchmanDeathVarname, bDie);
}

// Returns TRUE if the henchman died
int GetDidDie(object oHench=OBJECT_SELF)
{
    return GetBooleanValue(oHench, sHenchmanDeathVarname);
}

// Set got killed
void SetKilled(object oPC, object oHench=OBJECT_SELF, int bKilled=TRUE)
{
    SetBooleanValue(oPC, GetTag(oHench) + sHenchmanKilledSuffix, bKilled);
}

// Determine if this PC got the henchman killed
int GetKilled(object oPC, object oHench=OBJECT_SELF)
{
    return GetBooleanValue(oPC, GetTag(oHench) + sHenchmanKilledSuffix);
}

// Set that this PC resurrected the henchman
void SetResurrected(object oPC, object oHench=OBJECT_SELF, int bResurrected=TRUE)
{
    SetBooleanValue(oPC, GetTag(oHench) + sHenchmanResurrectedSuffix, bResurrected);
}

// Determine if this PC resurrected the henchman
int GetResurrected(object oPC, object oHench=OBJECT_SELF)
{
    return GetBooleanValue(oPC, GetTag(oHench) + sHenchmanResurrectedSuffix);
}



// Handle the respawning of the henchman back at either the
// respawn location or the starting location
void RespawnHenchman(object oHench=OBJECT_SELF)
{

    // : REMINDER: The delay is here for a reason
    // Remove effects on the henchman
    DelayCommand(0.1, RemoveEffects(oHench));

    // Resurrect
    DelayCommand(0.2,
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                     EffectResurrection(),
                                     oHench));

    // Heal back to full hp
    DelayCommand(0.3,
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                     EffectHeal(GetMaxHitPoints(oHench)),
                                     oHench));

    // Set back to destroyable
    DelayCommand(5.1,
                 AssignCommand(oHench,
                               SetIsDestroyable(TRUE, TRUE, TRUE)));


    // Handle sending back to respawn point
    location lRespawn = GetRespawnLocation(oHench);

    // Check for validity
    if (GetIsObjectValid(GetAreaFromLocation(lRespawn)))
    {
        DelayCommand(0.3, JumpToLocation(lRespawn));
    }// else
    //{
    //    DelayCommand(0.3, ActionSpeakString("NO VALID RESPAWN POINT FOUND"));
    //}
}




// Keep dead by playing the appropriate death animation for the
// maximum wait until respawn.
void KeepDead(object oHench=OBJECT_SELF)
{   // SpawnScriptDebugger();
    DelayCommand(0.1, WrapCommandable(TRUE, oHench));
    DelayCommand(0.2,
        AssignCommand(oHench,
                      ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
                                          1.0, HENCHMEN_DIE_ANIM_DURATION)));
    DelayCommand(0.3, WrapCommandable(FALSE, oHench));
}

// Stop keeping dead by playing the 'woozy' standing animation.
void StopKeepingDead(object oHench=OBJECT_SELF)
{
    DelayCommand(0.1, WrapCommandable(TRUE, oHench));
    DelayCommand(0.2,
                 AssignCommand(oHench,
                               PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                             1.0, 6.0)));
    DelayCommand(0.3, WrapCommandable(FALSE, oHench));
}

// Does a partial restoration to get rid of negative effects
void PartialRes(object oHench)
{
    RemoveEffects(oHench);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oHench);
}

// Raise and freeze henchman to 1 hp so s/he can be stabilized
void RaiseForRespawn(object oPC, object oHench=OBJECT_SELF)
{
    // Resurrect
    DelayCommand(0.1, PartialRes(oHench));

    // * May 13 2003
    // * if something weird has happened and my hitpoints are restored
    // * then bring back to life (i.e., a con penalty going away might restore
    // * hitpoints).
    if (GetCurrentHitPoints(oHench) > 1)
    {
        DoRespawn(oPC, OBJECT_SELF);
        return;
    }
    KeepDead(oHench);

    //DBG_msg("Henchman " + GetTag(oHench) + " raised for respawn");
}


// See if our maximum wait time has passed
int GetHasMaxWaitPassed(int nChecks)
{
    return ( (nChecks * DELAY_BETWEEN_RESPAWN_CHECKS) >= MAX_RESPAWN_WAIT ) ;
}


// Do the checking to see if we respawn -- this function works
// in a circle with DoRespawnCheck.
void RespawnCheck(object oPC, int nChecks=0, object oHench=OBJECT_SELF)
{
    //DBG_msg("Doing respawn check " + IntToString(nChecks + 1));
    DelayCommand(DELAY_BETWEEN_RESPAWN_CHECKS,
                 DoRespawnCheck(oPC, nChecks+1, oHench));
}


// Perform a single respawn check -- this function works
// in a circle with RespawnCheck.
void DoRespawnCheck(object oPC, int nChecks, object oHench=OBJECT_SELF)
{
    //brentDebug("In RespawnCheck");
    // * if a healing spell has been used on henchmen, they ain't dead no more
    if (GetIsHenchmanDying(oHench) == FALSE)
        return;

    //   SpawnScriptDebugger();
    if ( GetCurrentHitPoints(oHench) == 1 && GetHasMaxWaitPassed(nChecks))
    {
        //DBG_msg("Maximum wait reached, respawning");
        DoRespawn(oPC, oHench);
    }
    else if (GetCurrentHitPoints(oHench) == 1
        &&
        ( GetArea(oPC) != GetArea(oHench) || GetIsDead(oPC)) )
    {
        //DBG_msg("Master left or died, respawning");
        DoRespawn(oPC, oHench);
    }
    else if (GetCurrentHitPoints(oHench) > 1 && !GetResurrected(oPC))
    {
        // We're alive, must have been resurrected
        // Do the 'respawn' anyway to clean up after death
        //DBG_msg("Master stabilized us, respawning");
        DoRespawn(oPC, oHench);
    }
    else
    {
        // We aren't resurrecting yet, but keep checking
        RespawnCheck(oPC, nChecks, oHench);
    }
}

// This function actually invokes the respawn.
void DoRespawn(object oPC, object oHench=OBJECT_SELF)
{
//  SpawnScriptDebugger();
        StopKeepingDead(oHench);

        // Set henchman commandable
        DelayCommand(0.4,
                     WrapCommandable(TRUE, oHench));

       // if (GetCurrentHitPoints(oHench) > 0)
        if (GetLocalInt(oHench, "X0_L_WAS_HEALED") == 10)
        {
            SetLocalInt(oHench, "X0_L_WAS_HEALED",0);
            // Hey, we've been stabilized! Good on you, master.
            SetResurrected(oPC, oHench);

            // Automatically re-add the henchman   BK 2003 Don't rehire them completely since they were never not hired.
            HireHenchman(oPC, oHench, FALSE);
        }
        else
        {

            // * only in Chapter 1 will the henchmen respawn
            // * somewhere, otherwise they'll stay where they are.
            if (GetTag(GetModule()) == "x0_module1")
            {
                // Indicate that this master got us killed
                SetKilled(oPC, oHench);
                RemoveHenchman(oPC, oHench);
                // Do the respawn
                DelayCommand(1.0, RespawnHenchman(oHench));
            }
        }
        PostRespawnCleanup(oHench);
}

void PreRespawnSetup(object oHench=OBJECT_SELF)
{
    // Mark us as in the process of dying
    SetHenchmanDying(oHench, TRUE);

    // Indicate the henchman died
    SetDidDie(TRUE, oHench);

    // Mark henchman PLOT & Busy
    SetPlotFlag(oHench, TRUE);
    SetAssociateState(NW_ASC_IS_BUSY, TRUE, oHench);

    // Make henchman's corpse stick around,
    // be raiseable, and selectable
    AssignCommand(oHench, SetIsDestroyable(FALSE, TRUE, TRUE));

    AssignCommand(oHench, ClearActions(CLEAR_X0_I0_HENCHMAN_PreRespawn, TRUE));
}


void PostRespawnCleanup(object oHench=OBJECT_SELF)
{
    DelayCommand(1.0,
                 SetHenchmanDying(oHench, FALSE));

    // Clear henchman being busy
    DelayCommand(1.1,
                 SetAssociateState(NW_ASC_IS_BUSY, FALSE, oHench));

    // Clear the plot flag
    DelayCommand(1.2, SetPlotFlag(oHench, FALSE));

}

// Determine if this henchman is currently dying
int GetIsHenchmanDying(object oHench=OBJECT_SELF)
{
    int bHenchmanDying = GetAssociateState(NW_ASC_MODE_DYING, oHench);
    if (bHenchmanDying == TRUE)
    {
        //brentDebug("henchman is dying");
        return TRUE;
    }
    else
    {
        //brentDebug("Henchman is not dying");
        return FALSE;
    }
}

// * Wrapper function added to fix bugs in the dying-state
// * process. Need to figure out whenever his value changes.
void SetHenchmanDying(object oHench=OBJECT_SELF, int bIsDying=TRUE)
{
    SetAssociateState(NW_ASC_MODE_DYING, bIsDying, oHench);
    //brentDebug("In SetHenchmanDying. Value for " + GetName(oHench) + " is " + IntToString(bIsDying));
   // GetIsHenchmanDying();
}
/***** MODULE TRANSFER FUNCTIONS *****/

// Call this function when the PC is about to leave a module
// to enable restoration of the henchman on re-entry into the
// sequel module. Both modules must use the same campaign db
// for this to work.
void StoreCampaignHenchman(object oPC)
{
    object oHench = GetHenchman(oPC);
    if (!GetIsObjectValid(oHench)) {
        //DBG_msg("No valid henchman to store");
        return;
    }

    //DBG_msg("Storing henchman: " + GetTag(oHench));
    int ret = StoreCampaignDBObject(oPC, sStoredHenchmanVarname, oHench);
/*    if (!ret) {
        DBG_msg("Error attempting to store henchman");
    } else {
        DBG_msg("Henchman stored successfully");
    }*/
}

// Call this function when a PC enters a sequel module to restore
// the henchman (complete with inventory). The function
// StoreCampaignHenchman must have been called first, and both
// modules must use the same campaign db. (See notes in x0_i0_campaign.)
//
// The restored henchman will automatically be re-hired and will be
// created next to the PC.
//
// Any object in the module with the same tag as the henchman will be
// destroyed (to remove duplicates).
void RetrieveCampaignHenchman(object oPC)
{
    location lLoc = GetLocation(oPC);
    object oHench = RetrieveCampaignDBObject(oPC, sStoredHenchmanVarname, lLoc);

    // Delete the henchman object from the db
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sStoredHenchmanVarname));

    if (GetIsObjectValid(oHench)) {
        DelayCommand(0.5, HireHenchman(oPC, oHench));

        object oHenchDupe = GetNearestObjectByTag(GetTag(oHench),
                                                  oHench);
        if (GetIsObjectValid(oHenchDupe) && oHenchDupe != oHench) {
            DestroyObject(oHenchDupe);
        }
    }// else {
    //    DBG_msg("No valid henchman retrieved");
    //}
}

// Levels a henchman up to the given level, alternating
// between the first and second classes if they are multiclassed.
// 0 as a max level means they will try to keep their levels balanced
void LevelHenchmanUpTo(object oHenchman, int nLevel, int nClass2=CLASS_TYPE_INVALID,
    int nMaxLevelInSecondClass=0, int nPackageClass1=PACKAGE_INVALID, int nPackageClass2=PACKAGE_INVALID)
{

    int nPackageToUse = nPackageClass1;


    if ( !GetIsObjectValid(oHenchman) || GetHitDice(oHenchman) >= nLevel)
        return;

    // * she has 3 rogue levels, decrement nLevel by this
    if (GetTag(oHenchman) == "x2_hen_nathyra" && nClass2 == CLASS_TYPE_ASSASSIN)
    {
        nLevel = nLevel - 3;
    }

    int nClass1 = GetClassByPosition(1, oHenchman);
    if (nClass2 == CLASS_TYPE_INVALID)
    {
        nClass2 = GetClassByPosition(2, oHenchman);
    }

    int nLevel1 = GetLevelByClass(nClass1, oHenchman);
    int nLevel2 = GetLevelByClass(nClass2, oHenchman);

    int nClassToLevelUp;

    while ( (nLevel1 + nLevel2) < nLevel )
    {
        if ( nClass2 != CLASS_TYPE_INVALID && (nLevel1 > nLevel2) )
        {
            nClassToLevelUp = nClass2;
            nLevel2++;
            nPackageToUse = nPackageClass2;
        }
        else
        {
            nClassToLevelUp = nClass1;
             nPackageToUse = nPackageClass1;
            nLevel1++;
        }

        // * if you have exceeded your max level in the second class
        // * only level up in the first class from this point forward
        if (nLevel2 > nMaxLevelInSecondClass)
        {
            nClassToLevelUp = nClass1;
            nPackageToUse = nPackageClass1;
        }

        // * Additional Rules
        // * The player can choose a levelup stratedgy for the henchman
        // * 0 = Normal, as per designer rules
        // * 1 = Secondary Class: only take levels in your second class
        // * 2 = First class: only take levels in your first class
        // * Note: This choice overrides the above nMaxLevelInSecondClass
        int nRule = GetLocalInt(oHenchman, "X0_L_LEVELRULES");

        // HACK: If in XP2, reverse the rules
        if (GetLocalInt(GetModule(), "X2_L_XP2") == 1)
        {
            if (nRule == 1)
             nRule = 2;
            else
            if (nRule == 2)
             nRule = 1;
        }

        if (nRule == 1)
        {
            nClassToLevelUp = nClass2;
            nPackageToUse = nPackageClass2;
        }
        else
        if (nRule == 2)
        {
            nClassToLevelUp = nClass1;
        }
        if (!LevelUpHenchman(oHenchman, nClassToLevelUp, FALSE, nPackageToUse))
        {
            // * In case the levelup failed (july 2003) for a prestige class
            // * try one more time to levelup the primary class.
            // * this way classes with an alternate prestige class will attempt
            // * always to gain that class but fail until they meet the prereqs
            // Feb. 11, 2004 - JE: Made this more generic, to fix evil aribeth
            // at high levels. Instead of trying class 1, it tries the OTHER class,
            // since it's possible for the first class to fail.
            int nClassToLevelUp2;
            if(nClassToLevelUp==nClass2)
            {
                nClassToLevelUp2 = nClass1;
                nPackageToUse = nPackageClass1;
            }
            else
            {
                nClassToLevelUp2 = nClass2;
                nPackageToUse = nPackageClass2;
            }
            if (nClassToLevelUp2==CLASS_TYPE_INVALID ||
                !LevelUpHenchman(oHenchman, nClassToLevelUp2, FALSE, nPackageToUse))
            {
                SendMessageToPC(GetFirstPC(), "Level Up Failed For "
                                              + GetName(oHenchman)
                                              + " in class "
                                              + IntToString(nClassToLevelUp));

                return;
            }
        }
    }
}

// * Adjusts the levels for the henchmen
int AdjustXP2Levels(int nLevel, int nMin=13, int nAdjust=2)
{
    nLevel = nLevel - nAdjust;
    if (nLevel < nMin)
     nLevel = nMin;
    return nLevel;
}
// * levels up the henchman assigned to oPC
// * Modified for XP2 so that it cycles through
// * all the available henchmen and levels them all up
// *
void LevelUpXP1Henchman(object oPC)
{
    if ( !GetIsObjectValid(oPC) )
        return;

    int i = 1;
    object oAssociate;
    for (i=1; i<= GetMaxHenchmen(); i++)
    {
        oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);

        if ( GetIsObjectValid(oAssociate) )
        {
            // * Followers do not level up
            if (GetLocalInt(oAssociate, "X2_JUST_A_FOLLOWER") == FALSE)
            {
                int nResult;
                int nLevel = GetHitDice(oPC);
                string sTag = GetStringLowerCase(GetTag(oAssociate));



                // ********************************
                // XP2 Stuff
                // * if a mini henchman
                // * nLevel = nLevel - 2;
                // * because they are always 2 levels
                // * behind the player.
                // ********************************
                if (sTag == "x2_hen_deekin")
                {
                    //nLevel = AdjustXP2Levels(nLevel);
                    LevelHenchmanUpTo(oAssociate, nLevel, 37, 40, 72, 117);
                }
                else
                if (sTag == "x2_hen_daelan")
                {
                    // * druid would have to be exposed
                    nLevel = AdjustXP2Levels(nLevel);
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_DRUID, 0, 105);
                }
                else
                if (sTag == "x2_hen_sharwyn")
                {
                    nLevel = AdjustXP2Levels(nLevel);
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_FIGHTER, 40, 106, 114);
                }
                else
                if (sTag == "x2_hen_linu")
                {
                // * leveling up as a fighter would have to be exposed
                    nLevel = AdjustXP2Levels(nLevel);
                    LevelHenchmanUpTo(oAssociate, nLevel,CLASS_TYPE_FIGHTER , 0, 104);
                }
                else
                if (sTag == "x2_hen_tomi")
                {   //SpawnScriptDebugger();
                    nLevel = AdjustXP2Levels(nLevel);
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_SHADOWDANCER, 40, 103, 116);
                }
                else
                if (sTag == "x2_hen_nathyra")
                {
                    // After one level of wizard
                    // she will take one level of rogue.

                    if (GetHitDice(oAssociate) <= 6)
                    {
                        LevelHenchmanUpTo(oAssociate, 12, CLASS_TYPE_ROGUE, 3, 101, 8);
                        if (nLevel >= 14)
                            LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_ASSASSIN, 40, 101, 115);
                    }
                    else
                    {
                        LevelHenchmanUpTo(oAssociate, nLevel , CLASS_TYPE_ASSASSIN, 40, 101, 115);
                    }
                }
                else
                if (sTag == "x2_hen_valen")
                {
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_WEAPON_MASTER, 40, 102,113);
                }
                else
                // * Aribeth
                if (sTag =="h2_aribeth")                {
                    /* Aribeth has special rules
                       - if she is good, she'll level up as a paladin
                       - if she is evil, she'll level up as a blackguard
                    */
                    if (GetAlignmentGoodEvil(oAssociate) == ALIGNMENT_GOOD)
                    {
                        LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_INVALID, 0, 129);
                    }
                    else
                    // Blackguard
                    {
                        LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_BLACKGUARD, 40, 129, 130);
                    }

                }


                // ********************************
                // XP1 Stuff
                // ********************************
                if ( sTag == "x0_hen_xan" )
                {
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_BARBARIAN, 2);
                }
                else if (sTag == "x0_hen_dor")
                {
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_CLERIC, 20);
                }
                else if (sTag == "x0_hen_dee")
                {
                    LevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_ROGUE, 0);
                }
                else
                {
                    LevelHenchmanUpTo(oAssociate, nLevel);
                }
            } // Follower
        } // valid associate
    } // Loop
}

//::///////////////////////////////////////////////
//:: LevelUpAribeth
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Initial Aribeth you meet in Chapter 3.
    Levels her up to level 16 Paladin,
    Level 6 Blackguard.

    Does some tricky alignment juggling to allow
    this.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
void LevelUpAribeth(object oAribeth)
{
    // * set alignment good
    AdjustAlignment(oAribeth, ALIGNMENT_GOOD, 100);
    AdjustAlignment(oAribeth, ALIGNMENT_LAWFUL, 100);
    // * give 16 levels of paladin
    LevelHenchmanUpTo(oAribeth, 16, CLASS_TYPE_INVALID, 0, 129);

    // * set alignment lawful evil
    AdjustAlignment(oAribeth, ALIGNMENT_EVIL, 100);
    AdjustAlignment(oAribeth, ALIGNMENT_LAWFUL, 100);

    // * give 6 levels of blackguard
    LevelHenchmanUpTo(oAribeth, 22, CLASS_TYPE_BLACKGUARD, 40, 129, 130);


    // * set alignment chaotic neutral
// AdjustAlignment(oAribeth, ALIGNMENT_NEUTRAL, 100);
// AdjustAlignment(oAribeth, ALIGNMENT_LAWFUL, 100);
}

//::///////////////////////////////////////////////
//:: SetNumberOfRandom
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the number of random popups or
    interjections that the henchman has
    Should be called in henchman
    spawn scripts

    In the format
    1|2|3|4|
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void SetNumberOfRandom(string sVariableName, object oHench, int nNum)
{
    int i = 0;
    string s = "";

    for (i=1; i<= nNum; i++)
    {
        s = s + IntToString(i) + "|";
    }

    SetLocalString(oHench, sVariableName, s);
}

// * Oct 14 - added the oHench parameters
string GetDialogFile(object oPC, string sHenchmenDlg, string sPreHenchDlg, object oHench=OBJECT_SELF)
{
        if ( GetPlayerHasHired(oPC, oHench) == TRUE)
        {
            return sHenchmenDlg;
        }
        else
        {
            return sPreHenchDlg;

        }
}

//::///////////////////////////////////////////////
//:: GetDialogFileToUse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the filename for the appropriate
    dialog file to be used.

    Henchmen have various dialog files throughout
    the game.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: August 2003
//:://////////////////////////////////////////////

string GetDialogFileToUse(object oPC, object oHench = OBJECT_SELF)
{
    string sTag = GetTag(oHench);
    string sModuleTag = GetTag(GetModule());
    // * Chapter 2

    // * Chapter 1 only
    if (sModuleTag == "x0_module1")
    {
        if (sTag == "x2_hen_sharwyn")
        {
            return GetDialogFile(oPC, "xp2_hen_shar", "q2asharwyn", oHench);
        }
        else
        if (sTag == "x2_hen_daelan")
        {
            return GetDialogFile(oPC, "xp2_hen_dae", "q2adaelan", oHench);
        }
        else
        if (sTag == "x2_hen_tomi")
        {
            return GetDialogFile(oPC, "xp2_hen_tomi", "q2atomi", oHench);
        }
        else
        if (sTag == "x2_hen_linu")
        {
            return GetDialogFile(oPC, "xp2_hen_linu", "q2alinu", oHench);
        }
        else
        if (sTag == "x2_hen_deekin")
        {
            return GetDialogFile(oPC, "xp2_hen_dee", "pre_deekin", oHench);
        }
    }
    else
    if (sModuleTag == "x0_module2" || sModuleTag == "x0_module3")
    {
        // * valen and nathyrra have area specific dialog
        string sAreaTag = GetTag(GetArea(oPC));
        if (sTag == "x2_hen_valen")
        {
            if (sAreaTag == "q2a1_temple"  && !GetIsObjectValid(GetMaster(oHench)))
            {
                return "xp2_valen";
            }

            return "xp2_hen_val";
        }
        else
        if (sTag == "x2_hen_nathyra" )
        {
            if (sAreaTag == "q2a1_temple" && !GetIsObjectValid(GetMaster(oHench)))
            {
                return "xp2_nathyrra";
            }

            return "xp2_hen_nat";
        }
    }
    return "";
}

/**********************************************************************
 * PRIVATE FUNCTIONS
 *
 * Note -- these are not really private, it's simply that they're
 * unprototyped and therefore won't show up in the function list.
 **********************************************************************/

// For debugging only. Close the comment below to enable.
// Make sure that the main() function in x0_i0_common is disabled
// or else you'll get duplicate function errors.

/* void main() {} /* */
