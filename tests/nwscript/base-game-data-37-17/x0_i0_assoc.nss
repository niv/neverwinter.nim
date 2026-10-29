//:://////////////////////////////////////////////////
//:: X0_I0_ASSOC
/*
  Library holding generic code for associates.

  MODIFIED February 6 2003: Added a ClearAllActions wrapper.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// If true will speakstring debug on clearallactions
const int CLEAR_DEBUG = FALSE;



// This is the variable on the henchman that stores the
// state.
const string sAssociateMasterConditionVarname = "NW_ASSOCIATE_MASTER";

//Distance
const int NW_ASC_DISTANCE_2_METERS =   0x00000001;
const int NW_ASC_DISTANCE_4_METERS =   0x00000002;
const int NW_ASC_DISTANCE_6_METERS =   0x00000004;

// Percentage of master's damage at which the
// assoc will try to heal them.
const int NW_ASC_HEAL_AT_75 =          0x00000008;
const int NW_ASC_HEAL_AT_50 =          0x00000010;
const int NW_ASC_HEAL_AT_25 =          0x00000020;

//Auto AI
const int NW_ASC_AGGRESSIVE_BUFF =     0x00000040;
const int NW_ASC_AGGRESSIVE_SEARCH =   0x00000080;
const int NW_ASC_AGGRESSIVE_STEALTH =  0x00000100;

//Open Locks on master fail
const int NW_ASC_RETRY_OPEN_LOCKS =    0x00000200;

//Casting power
const int NW_ASC_OVERKIll_CASTING =    0x00000400; // GetMax Spell
const int NW_ASC_POWER_CASTING =       0x00000800; // Get Double CR or max 4 casting
const int NW_ASC_SCALED_CASTING =      0x00001000; // CR + 4;

const int NW_ASC_USE_CUSTOM_DIALOGUE = 0x00002000;
const int NW_ASC_DISARM_TRAPS =        0x00004000;
const int NW_ASC_USE_RANGED_WEAPON   = 0x00008000;

// Playing Dead mode, used to make sure the associate is
// not targeted while dying.
const int NW_ASC_MODE_DYING          = 0x00010000;

//Guard Me Mode, Attack Nearest sets this to FALSE.
const int NW_ASC_MODE_DEFEND_MASTER =  0x04000000;

//The Henchman will ignore move to object in their OnHeartbeat.
//If this is set to FALSE then they are in follow mode.
const int NW_ASC_MODE_STAND_GROUND =   0x08000000;

const int NW_ASC_MASTER_GONE =         0x10000000;

const int NW_ASC_MASTER_REVOKED =      0x20000000;

//Only busy if attempting to bash or pick a lock or dead
const int NW_ASC_IS_BUSY =             0x40000000;

//Not actually used, here for system continuity
const int NW_ASC_HAVE_MASTER =         0x80000000;


// * CLEAR CONSTANTS

const int CLEAR_X0_INC_HENAI_BKATTEMPTTODISARMTRAP_ThrowSelfOnTrap = 1;
const int CLEAR_X0_I0_ASSOC_RESETHENCHMENSTATE = 2;
const int CLEAR_NW_C2_DEFAULT4_29 = 3;
const int CLEAR_NW_C2_DEFAULTB_GUSTWIND = 4;
const int CLEAR_NW_CH_AC1_49 = 5;
const int CLEAR_NW_CH_AC1_81 = 6;
const int CLEAR_NW_CH_AC4_28 = 7;
const int CLEAR_NW_I0_GENERIC_658 = 8;
const int CLEAR_NW_I0_GENERIC_834 = 9;
const int CLEAR_NW_I0_GENERIC_ExitAOESpellArea = 10;
const int CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior1 = 11;
const int CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior2 = 12;
const int CLEAR_X0_CH_HEN_CONV_26 = 13;
const int CLEAR_X0_CH_HEN_USRDEF_91 = 14;
const int CLEAR_X0_CH_HEN_USRDEF_92 = 15;
const int CLEAR_X0_I0_ANIMS_PlayMobile = 16;
const int CLEAR_X0_I0_ANIMS_PlayRandomMobile = 17;
const int CLEAR_X0_I0_ANIMS_PlayRandomCloseRange1 = 18;
const int CLEAR_X0_I0_ANIMS_PlayRandomCloseRange2 = 19;
const int CLEAR_X0_I0_ANIMS_AnimActionPlayRandomMobile1 = 20;
const int CLEAR_X0_I0_ANIMS_AnimActionPlayRandomMobile2 = 21;
const int CLEAR_X0_I0_ANIMS_AnimActionPlayRandomUncivilized =22;
const int CLEAR_X0_I0_ANIMS_AnimActionGetUpFromChair = 23;
const int CLEAR_X0_I0_ANIMS_AnimActionGoToStop = 24;
const int CLEAR_X0_I0_ANIMS_AnimActionRest1 = 25;
const int CLEAR_X0_I0_ANIMS_AnimActionRest2 = 26;
const int CLEAR_X0_I0_ANIMS_GoHome = 27;
const int CLEAR_X0_I0_ANIMS_AnimActionLeaveHome = 28;
const int CLEAR_X0_I0_ANIMS_AnimActionChallengeIntruder = 29;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsRanged1 = 30;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsRanged2 = 31;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsRanged3 = 32;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsAmbusher = 33;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsCowardly1 = 34;
const int CLEAR_X0_I0_COMBAT_SpecialTacticsCowardly2 = 35;
const int CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons1 = 36;
const int CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons2 = 37;
const int CLEAR_X0_I0_EQUIP_EquipMelee1 = 38;
const int CLEAR_X0_I0_EQUIP_EquipMelee2 = 39;
const int CLEAR_X0_I0_EQUIP_EquipMelee3 = 40;
const int CLEAR_X0_I0_HENCHMAN_Fire = 41;
const int CLEAR_X0_I0_HENCHMAN_LevelUp = 42;

const int CLEAR_X0_I0_HENCHMAN_PreRespawn = 71;

const int CLEAR_X0_INC_GENERIC_TalentFilter = 43;
const int CLEAR_X0_I0_TALENT_RangedAttackers = 44;

const int CLEAR_X0_I0_TALENT_RangedEnemies = 68;

const int CLEAR_X0_I0_TALENT_TalentFlee = 69;

const int CLEAR_X0_I0_TALENT_UseTurning = 70;



const int CLEAR_X0_I0_TALENT_SummonAllies = 45;
const int CLEAR_X0_I0_TALENT_MeleeAttack1 =46;
const int CLEAR_X0_I0_TALENT_MeleeAttack2 = 47;
const int CLEAR_X0_I0_TALENT_TalentFlee2 =48;
const int CLEAR_X0_I0_TALENT_AdvancedBuff = 49;
const int CLEAR_X0_I0_TALENT_SeeInvisible = 50;
const int CLEAR_X0_I0_TALENT_BardSong = 51;
const int CLEAR_X0_I0_WALKWAY_WalkWayPoints = 52;
const int CLEAR_X0_INC_HENAI_HCR = 53;
const int CLEAR_X0_INC_HENAI_AttemptToDisarmTrap = 54;
const int CLEAR_X0_INC_HENAI_AttemptToOpenLock1 = 55;
const int CLEAR_X0_INC_HENAI_AttemptToOpenLock2 = 56;
const int CLEAR_X0_INC_HENAI_AttemptToOpenLock3 = 57;
const int CLEAR_X0_INC_HENAI_RespondToShout1 = 58;
const int CLEAR_X0_INC_HENAI_RespondToShout2 = 59;
const int CLEAR_X0_INC_HENAI_RespondToShout3 = 60;
const int CLEAR_X0_INC_HENAI_RespondToShout4 = 61;
const int CLEAR_X0_INC_HENAI_CombatAttemptHeal1 = 62;
const int CLEAR_X0_INC_HENAI_CombatAttemptHeal2 = 63;
const int CLEAR_X0_INC_HENAI_Combat = 64;
const int CLEAR_X0_INC_HENAI_CombatAttemptHeal = 65;
const int CLEAR_X0_INC_HENAI_CombatFollowMaster1 = 66;
const int CLEAR_X0_INC_HENAI_CombatFollowMaster2 = 67;

/*MAX # = 71 so far*/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Determine the percentage of hit points the object has left.
// Used to determine whether the assoc should heal their master.
// Returns an integer between 0 - 100.
int GetPercentageHPLoss(object oWounded);

// Set/unset the specified condition flag in the caller's associate state
void SetAssociateState(int nCondition, int bValid = TRUE, object oAssoc=OBJECT_SELF);

// Returns TRUE if the specified condition flag is set on
// the associate.
int GetAssociateState(int nCondition, object oAssoc=OBJECT_SELF);

//Returns the henchmen to a commandable state of grace
void ResetHenchmenState();

// TRUE if the object to check is NOT the caller's henchman
int AssociateCheck(object oCheck);

// Returns TRUE if the associate should attempt to heal the master
int GetAssociateHealMaster();

// Returns the distance in meters at which the associate should begin
// to run after the master.
float GetFollowDistance();

// Sets the associate's current location as their
// start location.
void SetAssociateStartLocation();

// Gets the associate's current start location.
location GetAssociateStartLocation();


//    This is a wrapper for ClearAllActions.
//    Added to try and track down some bugs in
//    the AI.
void ClearActions(int nClearConstant=0, int bClearCombat=FALSE);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: Get Percentage of HP Loss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Determine the percentage of hit points the object has left.
   Used to determine whether the assoc should heal their master.
   Returns an integer between 0 - 100.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////

int GetPercentageHPLoss(object oWounded)
{
    float fMaxHP = IntToFloat(GetMaxHitPoints(oWounded));
    float fCurrentHP = IntToFloat(GetCurrentHitPoints(oWounded));
    float fHP_Perc = (fCurrentHP / fMaxHP) * 100;

    int nHP = FloatToInt(fHP_Perc);
    return nHP;
}


//::///////////////////////////////////////////////
//:: Reset Henchmen
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the henchmen to commandable, deletes locals
    having to do with doors and clears actions
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////
void ResetHenchmenState()
{
    SetCommandable(TRUE);
    DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
    DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
    SetAssociateState(NW_ASC_IS_BUSY, FALSE);
    ClearActions(CLEAR_X0_I0_ASSOC_RESETHENCHMENSTATE);
}


// True if the object is NOT the caller's henchman
int AssociateCheck(object oCheck)
{
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN);
    if(oCheck != oHench)
    {
        return TRUE;
    }
    return FALSE;
}

void SetAssociateState(int nCondition, int bValid = TRUE, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    int nPlot = GetLocalInt(oAssoc, sAssociateMasterConditionVarname);
    if(bValid == TRUE)
    {
        nPlot = nPlot | nCondition;
        SetLocalInt(oAssoc, sAssociateMasterConditionVarname, nPlot);
    }
    else if (bValid == FALSE)
    {
        nPlot = nPlot & ~nCondition;
        SetLocalInt(oAssoc, sAssociateMasterConditionVarname, nPlot);
    }
}

int GetAssociateState(int nCondition, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    if(nCondition == NW_ASC_HAVE_MASTER)
    {
        if(GetIsObjectValid(GetMaster(oAssoc)))
            return TRUE;
    }
    else
    {
        int nPlot = GetLocalInt(oAssoc, sAssociateMasterConditionVarname);
        if(nPlot & nCondition)
            return TRUE;
    }
    return FALSE;
}


//::///////////////////////////////////////////////
//:: Should I Heal My Master
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the healing variable for the master
    and then asks if the master if below that level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////
int GetAssociateHealMaster()
{
    if(GetAssociateState(NW_ASC_HAVE_MASTER))
    {
        object oMaster = GetMaster();
        int nLoss = GetPercentageHPLoss(oMaster);
        if(!GetIsDead(oMaster))
        {
            if(GetAssociateState(NW_ASC_HEAL_AT_75) && nLoss <= 75)
            {
                return TRUE;
            }
            else if(GetAssociateState(NW_ASC_HEAL_AT_50) && nLoss <= 50)
            {
                return TRUE;
            }
            else if(GetAssociateState(NW_ASC_HEAL_AT_25) && nLoss <= 25)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

// Determine the distance we should follow at
float GetFollowDistance()
{
    float fDistance;
    if(GetAssociateState(NW_ASC_DISTANCE_2_METERS))
    {
        fDistance = 2.0;
    }
    else if(GetAssociateState(NW_ASC_DISTANCE_4_METERS))
    {
        fDistance = 4.0;
    }
    else if(GetAssociateState(NW_ASC_DISTANCE_6_METERS))
    {
        fDistance = 6.0;
    }

    return fDistance;
}


//::///////////////////////////////////////////////
//:: Set Associate Start Location
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Preston Watmaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////
void SetAssociateStartLocation()
{
    SetLocalLocation(OBJECT_SELF, "NW_ASSOCIATE_START", GetLocation(OBJECT_SELF));
}

//::///////////////////////////////////////////////
//:: Get Associate Start Location
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Preston Watmaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////
location GetAssociateStartLocation()
{
    return GetLocalLocation(OBJECT_SELF, "NW_ASSOCIATE_START");
}


//::///////////////////////////////////////////////
//:: ClearActions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a wrapper for ClearAllActions.
    Added to try and track down some bugs in
    the AI.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: February 6, 2003
//:://////////////////////////////////////////////
void ClearActions(int nClearConstant=0, int bClearCombat=FALSE)
{
    // SpeakString ("Clearing Action # " + IntToString(bClearConstant));
    //will comment out this condition, it's just an extra check we don't use anymore
    //if (CLEAR_DEBUG == TRUE)
    //{
    //    SpeakString("Clearing all actions in State # " + IntToString(nClearConstant));
    //}
    ClearAllActions(bClearCombat);
}



/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
