//:://////////////////////////////////////////////////
//:: X0_I0_SPAWNCOND
/*
  This library separates out the spawn-in conditions from
  nw_i0_generic for improved clarity. This cannot be
  dual-#included with nw_i0_generic.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////


// * needed access to 'clearaction' function in x0_i0_asoc in lower branches
#include "x0_i0_combat"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/



// This is the name of the local variable that holds the spawn-in conditions
const string sSpawnCondVarname = "NW_GENERIC_MASTER";

// The available spawn-in conditions

const int NW_FLAG_SPECIAL_CONVERSATION        = 0x00000001;
const int NW_FLAG_SHOUT_ATTACK_MY_TARGET      = 0x00000002;
const int NW_FLAG_STEALTH                     = 0x00000004;
const int NW_FLAG_SEARCH                      = 0x00000008;
const int NW_FLAG_SET_WARNINGS                = 0x00000010;
const int NW_FLAG_ESCAPE_RETURN               = 0x00000020; //Failed
const int NW_FLAG_ESCAPE_LEAVE                = 0x00000040;
const int NW_FLAG_TELEPORT_RETURN             = 0x00000080; //Failed
const int NW_FLAG_TELEPORT_LEAVE              = 0x00000100;
const int NW_FLAG_PERCIEVE_EVENT              = 0x00000200;
const int NW_FLAG_ATTACK_EVENT                = 0x00000400;
const int NW_FLAG_DAMAGED_EVENT               = 0x00000800;
const int NW_FLAG_SPELL_CAST_AT_EVENT         = 0x00001000;
const int NW_FLAG_DISTURBED_EVENT             = 0x00002000;
const int NW_FLAG_END_COMBAT_ROUND_EVENT      = 0x00004000;
const int NW_FLAG_ON_DIALOGUE_EVENT           = 0x00008000;
const int NW_FLAG_RESTED_EVENT                = 0x00010000;
const int NW_FLAG_DEATH_EVENT                 = 0x00020000;
const int NW_FLAG_SPECIAL_COMBAT_CONVERSATION = 0x00040000;
const int NW_FLAG_AMBIENT_ANIMATIONS          = 0x00080000;
const int NW_FLAG_HEARTBEAT_EVENT             = 0x00100000;
const int NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS = 0x00200000;
const int NW_FLAG_DAY_NIGHT_POSTING           = 0x00400000;
const int NW_FLAG_AMBIENT_ANIMATIONS_AVIAN    = 0x00800000;
const int NW_FLAG_APPEAR_SPAWN_IN_ANIMATION   = 0x01000000;
const int NW_FLAG_SLEEPING_AT_NIGHT           = 0x02000000;
const int NW_FLAG_FAST_BUFF_ENEMY             = 0x04000000;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Sets the specified spawn-in condition on the caller as directed.
void SetSpawnInCondition(int nCondition, int bValid = TRUE);

// Returns TRUE if the specified condition has been set on the
// caller, otherwise FALSE.
int GetSpawnInCondition(int nCondition);

// Sets the listening patterns and local variables needed
// for the given spawn-in condition on the caller.
void SetSpawnInLocals(int nCondition);

//     Sets the correct listen checks on the NPC by
//     determining what talents they possess or what
//     class they use.
void SetListeningPatterns();

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Sets the specified spawn-in condition on the caller as directed.
void SetSpawnInCondition(int nCondition, int bValid = TRUE)
{
    int nSpawnInConditions = GetLocalInt(OBJECT_SELF, sSpawnCondVarname);
    if(bValid == TRUE)
    {
        // Add the given spawn-in condition
        nSpawnInConditions = nSpawnInConditions | nCondition;
        SetLocalInt(OBJECT_SELF, sSpawnCondVarname, nSpawnInConditions);

        // Set the listening patterns appropriate to the
        // given condition.
        SetSpawnInLocals(nCondition);
    }
    else if (bValid == FALSE)
    {
        // Remove the given spawn-in condition
        nSpawnInConditions = nSpawnInConditions & ~nCondition;
        SetLocalInt(OBJECT_SELF, sSpawnCondVarname, nSpawnInConditions);
    }
}

// Returns TRUE if the specified condition has been set on the
// caller, otherwise FALSE.
int GetSpawnInCondition(int nCondition)
{
    int nPlot = GetLocalInt(OBJECT_SELF, sSpawnCondVarname);
    if(nPlot & nCondition)
    {
        return TRUE;
    }
    return FALSE;
}

// Sets the listening patterns and local variables needed
// for the given spawn-in condition on the caller.
void SetSpawnInLocals(int nCondition)
{
    if(nCondition == NW_FLAG_SHOUT_ATTACK_MY_TARGET)
    {
        // Listen for shouts from allies directing
        // the caller to attack their targets
        SetListenPattern(OBJECT_SELF,
                         "NW_ATTACK_MY_TARGET",
                         5);
    }
    else if(nCondition == NW_FLAG_ESCAPE_RETURN)
    {
        // Mark our starting location (here)
        SetLocalLocation(OBJECT_SELF,
                         "NW_GENERIC_START_POINT",
                         GetLocation(OBJECT_SELF));
    }
    else if(nCondition == NW_FLAG_TELEPORT_LEAVE)
    {
        // Mark our starting location (here)
        SetLocalLocation(OBJECT_SELF,
                         "NW_GENERIC_START_POINT",
                         GetLocation(OBJECT_SELF));
    }
}

//::///////////////////////////////////////////////
//:: SetListeningPatterns
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the correct listen checks on the NPC by
    determining what talents they possess or what
    class they use.

    This is also a good place to set up all of
    the sleep and appear disappear animations for
    various models.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////

void SetListeningPatterns()
{
    if(GetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION))
    {
        effect eAppear = EffectAppear();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, OBJECT_SELF);
    }

    SetListening(OBJECT_SELF, TRUE);

    SetListenPattern(OBJECT_SELF, "NW_I_WAS_ATTACKED", 1);

    //This sets the commoners listen pattern to mob under
    //certain conditions
    if(GetLevelByClass(CLASS_TYPE_COMMONER) > 0)
    {
        SetListenPattern(OBJECT_SELF, "NW_MOB_ATTACK", 2);
    }
    SetListenPattern(OBJECT_SELF, "NW_I_AM_DEAD", 3);

    SetListenPattern(OBJECT_SELF, "inventory",101);

    //Set a custom listening pattern for the creature so that placables with
    //"NW_BLOCKER" + Blocker NPC Tag will correctly call to their blockers.
    string sBlocker = "NW_BLOCKER_BLK_" + GetTag(OBJECT_SELF);
    SetListenPattern(OBJECT_SELF, sBlocker, 4);
    SetListenPattern(OBJECT_SELF, "NW_CALL_TO_ARMS", 6);
}


/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
