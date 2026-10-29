//:://////////////////////////////////////////////////
//:: X0_I0_INFDESERT
/*
  Desert-specific include file for the infinite desert
  system. See comments in x0_i0_infinite for more details.

  Note to modmakers: the "Message" functions can just as
  easily return ordinary double-quoted strings; you do NOT
  need to modify the dialog.tlk to use this system and
  probably shouldn't.
*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/12/2003
//:://////////////////////////////////////////////////


#include "x0_i0_spawncond"
#include "x0_i0_position"
#include "x0_i0_stringlib"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Base tag for this infinite area
string INF_BASE = "INF_DESERT";

// Tag for encounter spawn waypoints.
string INF_ENCOUNTER = INF_BASE + "_ENCOUNTER";

// Maximum length of a run
const int INF_MAX_RUN_LENGTH = 3;

// Minimum length of a run
const int INF_MIN_RUN_LENGTH = 2;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Create a random encounter in the specified area, possibly based
// on the PC's characteristics.
void INF_CreateRandomEncounter(object oArea, object oPC);

// Create random decorative placeables in the specified area.
void INF_CreateRandomPlaceables(object oArea, object oPC);

// Message sent to the player the first time they enter an
// infinite area.
string INF_GetEntryMessage();

// The message sent to the player when they re-enter an
// infinite area that they've been to before.
string INF_GetReentryMessage();

// Message sent to PC when they get dropped back to the starting
// point from within the desert for the first time.
string INF_GetReachStartMessage();

// Message sent to PC when they get dropped back to the starting
// point after the first time.
string INF_GetReturnToStartMessage();

// Message sent to PC when they reach the reward area of the infinite
// run for the first time.
string INF_GetReachRewardMessage();

// Message sent to PC when they reach the reward area of the infinite
// run on a subsequent re-entry.
string INF_GetReturnToRewardMessage();

// Message sent to PC in the case where the pool of generic areas
// is empty and no new area can be allocated. This should happen
// very rarely, and the result will be that the PC is returned to
// the starting point.
string INF_GetPoolEmptyMessage();

// Message sent to PC when they would reach the reward area but don't
// have the key.
string INF_GetNeedKeyMessage();

// Message sent to PC when no starting marker is available, which
// means they can't enter the desert. This should only happen if
// the modmaker has forgotten to put down a starting marker!
string INF_GetNoStartMessage();

/**********************************************************************
 * PRIVATE CONSTANTS FUNCTIONS
 * These are utility functions for this library.
 * Most of these are just used to make random encounters
 **********************************************************************/

// Hit dice restriction for spawning a boss
int MIN_HD_FOR_BOSS = 6;

// Encounter lists -- see comments to CreateEncounterGroup below.
// To add a new encounter, simply create a new string list, and modify
// PickRandomEncounter() so it will occasionally grab it.
//
// Format:
// <creature>|...|<creature>|<boss>+<min>+<max>
// If you don't want a boss, put in NOBOSS.
// You can't have more than one boss. Create a separate encounter
// with the different boss instead.
//
// If you make min/max the same, that number will always be generated.
//
string ENCOUNTER_WOLF = "nw_wolf|nw_dog|nw_direwolf|nw_wolfdireboss+2+5";
string ENCOUNTER_CAT = "nw_cougar|nw_cragcat|nw_beastmalar001|nw_panther|nw_cougar+2+5";
string ENCOUNTER_EARTH_ELEM = "nw_earth|NOBOSS+1+3";
string ENCOUNTER_HUMANOID = "nw_goblina|nw_goblinb|nw_gobchiefb|nw_orca|nw_orcchiefa|nw_gobwiza+3+6";
string ENCOUNTER_ASABI1 = "x0_asabi_warrior|x0_asabi_chief+2+3";
string ENCOUNTER_ASABI2 = "x0_asabi_warrior|x0_asabi_shaman+2+3";
string ENCOUNTER_BEETLE = "nw_btlfire|nw_btlfire02|nw_btlbomb|NOBOSS+4+6";
string ENCOUNTER_BASILISK = "x0_basilisk|NOBOSS+1+1";
string ENCOUNTER_COCKATRICE = "x0_cockatrice|NOBOSS+1+1";
string ENCOUNTER_GORGON = "x0_gorgon|NOBOSS+1+1";
string ENCOUNTER_STINGER = "x0_stinger|x0_stinger_war|x0_stinger_mage|x0_stinger_chief+2+4";
string ENCOUNTER_WILLOWISP = "nw_willowisp|NOBOSS+1+1";
string ENCOUNTER_FORMIAN = "x0_form_warrior|x0_form_worker|x0_form_taskmast+2+5";
string ENCOUNTER_WERECAT = "nw_werecat001|NOBOSS+2+4";
string ENCOUNTER_MUMMY = "nw_mummy|nw_mumcleric|nw_mumfight|NOBOSS+1+3";
string ENCOUNTER_UNDEAD = "nw_shadow|nw_shfiend|nw_skeleton|nw_skelwarr01|nw_ghast|nw_ghoul|NOBOSS+3+5";
string ENCOUNTER_BANDIT = "nw_bandit001|nw_bandit002|nw_bandit003|NOBOSS+3+5";
string ENCOUNTER_MERC = "nw_halfmerc001|nw_dwarfmerc001|nw_humanmerc002|nw_elfmerc001|NOBOSS+3+6";
string ENCOUNTER_ZHENT = "zhentarimcleric|zhentarimclrf2|zhentarimguard|zhentarimguar007|zhentarimmage003|zhentarimmage|zhentarimguar001|zhentarimguar008+4+6";
string ENCOUNTER_HUMANOID2 = "nw_goblina|nw_goblinb|nw_gobchiefb|nw_gobwiza+6+8";


// Randomly selects one of the encounter lists above
string PickRandomEncounter()
{
    int nEnc = Random(21);
    switch (nEnc) {
    case 0: return ENCOUNTER_WOLF ;
    case 1: return ENCOUNTER_CAT ;
    case 2: return ENCOUNTER_EARTH_ELEM ;
    case 3: return ENCOUNTER_HUMANOID ;
    case 4: return ENCOUNTER_ASABI1 ;
    case 5: return ENCOUNTER_ASABI2 ;
    case 6: return ENCOUNTER_BEETLE ;
    case 7: return ENCOUNTER_BASILISK ;
    case 8: return ENCOUNTER_COCKATRICE ;
    case 9: return ENCOUNTER_GORGON ;
    case 10: return ENCOUNTER_STINGER ;
    case 11: return ENCOUNTER_WILLOWISP ;
    case 12: return ENCOUNTER_FORMIAN ;
    case 13: return ENCOUNTER_WERECAT ;
    case 14: return ENCOUNTER_MUMMY ;
    case 15: return ENCOUNTER_UNDEAD ;
    case 16: return ENCOUNTER_BANDIT ;
    case 17: return ENCOUNTER_MERC ;
    case 18:
    case 19: return ENCOUNTER_ZHENT ;
    case 20: return ENCOUNTER_HUMANOID2 ;
        // case : return ENCOUNTER_ ;
    }
    return "";
}

// This takes a string for an encounter type (eg, ENCOUNTER_WOLF)
// that is a pipe-delimited list of creature blueprints. It will
// randomly generate the specified number of creatures out of the
// list and create them in the given location.
//
// The last two entries in the list after the + symbol are the
// min/max number of creatures to generate.
//
// The last blueprint in a list is the boss. (To make a list
// with no boss, simply repeat one creature at the end.) Bosses will
// be unique and will show up randomly, if the given PC has HD lower
// than the minimum hit dice required.
//
// Each creature in the list will have an equal chance of showing up.
//
// Each creature will have the ambient animations spawn-in condition
// set to make them wander about.
void CreateEncounterGroup(location locEnc, object oPC)
{
    string sEncounterList = PickRandomEncounter();
    string sEnc = GetTokenByPosition(sEncounterList, "+", 0);
    int nMin = StringToInt(GetTokenByPosition(sEncounterList, "+", 1));
    int nMax = StringToInt(GetTokenByPosition(sEncounterList, "+", 2));

    // Get the number to create
    int nCreatures;
    if (nMin == nMax) {
        nCreatures = nMin;
    } else {
        // Generate a random number between min and max
        nCreatures = Random(nMax - nMin + 1) + nMin;
    }

    struct sStringTokenizer stTok = GetStringTokenizer(sEnc, "|");
    int nElements = 0;
    string sBoss = "";
    while (HasMoreTokens(stTok)) {
        stTok = AdvanceToNextToken(stTok);
        sBoss = GetNextToken(stTok);
        nElements++;
    }

    object oCreated;

    // We now know how many elements we have. If just one, create it and go.
    string sResRef = "";
    int i;
    int bHasBoss = FALSE; int nRoll;
    for (i=0; i < nCreatures; i++) {
        if (GetIsObjectValid(oCreated)) {
            // change the position slightly
            locEnc = GetAheadRightLocation(oCreated);
            /*
            nRoll = Random(7);
            switch (nRoll) {
                case 0: locEnc = GetAheadRightLocation(oCreated); break;
                case 1: locEnc = GetFlankingLeftLocation(oCreated); break;
                case 2: locEnc = GetFlankingRightLocation(oCreated); break;
                case 3: locEnc = GetOppositeLocation(oCreated); break;
                case 4: locEnc = GetStepLeftLocation(oCreated); break;
                case 5: locEnc = GetStepRightLocation(oCreated); break;
                case 6: locEnc = GetAheadLeftLocation(oCreated); break;
            }
            */
        }

        // Check to see if we're going to make a boss
        if (sBoss != "NOBOSS" && !bHasBoss && GetHitDice(oPC) > MIN_HD_FOR_BOSS && Random(3) == 0) {
            oCreated = CreateObject(OBJECT_TYPE_CREATURE, sBoss, locEnc);
            bHasBoss = TRUE;
        } else {
            nRoll = Random(nElements - 1);
            sResRef = GetTokenByPosition(sEnc, "|", nRoll);
            oCreated = CreateObject(OBJECT_TYPE_CREATURE, sResRef, locEnc);
        }
        AssignCommand(oCreated, SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS));
        //PrintString("Created: " + GetTag(oCreated));
    }
}




/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/


// Create a random encounter in the specified area, possibly based
// on the PC's characteristics.
// This particular version looks for a waypoint named
// with the INF_ENCOUNTER tag and spawns there if it exists.
void INF_CreateRandomEncounter(object oArea, object oPC)
{
    location locEnc;
    object oSource = GetFirstObjectInArea(oArea);

    // Make as many encounters as there are waypoints
    // or just one if none exists. Check to make sure
    // the first object in the area isn't one of them!
    object oEncWay;
    int nNth = 0;
    if (GetTag(oSource) == INF_ENCOUNTER) {
        oEncWay = oSource;
    } else {
        nNth = 1;
        oEncWay = GetNearestObjectByTag(INF_ENCOUNTER, oSource, nNth);
    }

    if (!GetIsObjectValid(oEncWay)) {
        locEnc = GetRandomLocation(oArea);
        // Create the group
        CreateEncounterGroup(locEnc, oPC);
    } else {
        while (GetIsObjectValid(oEncWay)) {
            locEnc = GetLocation(oEncWay);
            //PrintString("Creating encounter at location: "
            //            + LocationToString(locEnc));

            // Create the group
            CreateEncounterGroup(locEnc, oPC);
            nNth++;
            oEncWay = GetNearestObjectByTag(INF_ENCOUNTER, oSource, nNth);
        }
    }
}

// Create some random decorative placeables in the specified area.
void INF_CreateRandomPlaceables(object oArea, object oPC)
{
    string sResRef = "";
    int nPlaceables = Random(3)+3;
    int i; int plc;
    location locPlc;
    object oLastPlc = OBJECT_INVALID;
    for (i = 0; i < nPlaceables; i++) {
        plc = Random(28);
        switch (plc) {
            case 0: sResRef = "x0_brokenpillar"; break;
            case 1: sResRef = "x0_cityrubble2"; break;
            case 2: sResRef = "x0_fenceruined"; break;
            case 3: sResRef = "x0_cacti"; break;
            case 4: sResRef = "x0_deadtree"; break;
            case 5: sResRef = "x0_desertboulder"; break;
            case 6: sResRef = "x0_desertboulde2"; break;
            case 7: sResRef = "x0_desertrocks"; break;
            case 8: sResRef = "x0_dragonskull"; break;
            case 9: sResRef = "x0_palm"; break;
            case 10: sResRef = "x0_golempartssto"; break;
            case 11: sResRef = "plc_bloodstain"; break;
            case 12: sResRef = "plc_bones"; break;
            case 13: sResRef = "plc_impledcrpse1"; break;
            case 14: sResRef = "plc_burnwagon"; break;
            case 15: sResRef = "plc_ruinwagon"; break;
            case 16: sResRef = "nw_pl_skeleton"; break;
            case 17: sResRef = "nw_pl_zombie"; break;
            case 18: sResRef = "plc_corpse1"; break;
            case 19: sResRef = "plc_corpse2"; break;
            case 20: sResRef = "plc_corpse3"; break;
            case 21: sResRef = "plc_corpse4"; break;
            case 22: sResRef = "plc_pilestones"; break;
            case 23: sResRef = "nw_stat_garg"; break;
            case 24: sResRef = "plc_statue1"; break;
            case 25: sResRef = "plc_boulder"; break;
            case 26: sResRef = "plc_grasstuft"; break;
            case 27: sResRef = "plc_stones"; break;
        }
        locPlc = GetRandomLocation(oArea, oLastPlc);
        vector vPos = GetPositionFromLocation(locPlc);
        oLastPlc = CreateObject(OBJECT_TYPE_PLACEABLE,
                                sResRef,
                                locPlc);
    }
}

// Message sent to the player the first time they enter an
// infinite area.
string INF_GetEntryMessage()
{
    return "You set forth into the trackless wastes.";
}


// The message sent to the player when they re-enter an
// infinite area that they've been to before.
string INF_GetReentryMessage()
{
    return "You set out once more into the trackless wastes.";
}

// Message sent to PC when they get dropped back to the starting
// point from within the desert for the first time or from the
// reward area.
string INF_GetReachStartMessage()
{
    return "After a thorough exploration, "
        + "you eventually make your way back to your starting point.";
}

// Message sent to PC when they get dropped back to the starting
// point after the first time. This only gets sent if there is no
// reward area.
string INF_GetReturnToStartMessage()
{
    return "Having explored these empty wastes before, "
        + "you quickly return to your starting point.";
}

// Message sent to PC when they reach the reward area of the infinite
// run for the first time.
// <CUSTOM0> in this message will be replaced by the name of the area.
string INF_GetReachRewardMessage()
{
    return "After long journeying through the trackless wastes, "
        + "you stumble upon <CUSTOM0>.";
}

// Message sent to PC when they reach the reward area of the infinite
// run on a subsequent re-entry.
// <CUSTOM0> in this message will be replaced by the name of the area.
string INF_GetReturnToRewardMessage()
{
    return "Knowing the route, you make your way to <CUSTOM0>.";
}

// Message sent to PC in the case where the pool of generic areas
// is empty AND none of the generic areas currently allocated have
// anyone from their same starting point inside. This should happen
// very rarely, and the result will be that the PC is returned to
// the starting point.
string INF_GetPoolEmptyMessage()
{
    return "A sudden sandstorm temporarily forces you to return to your starting point.";
}

// Message sent to PC when they would reach the reward area but don't
// have the key.
string INF_GetNeedKeyMessage()
{
    return "You have traveled as far as you can without further guidance.";
}

// Message sent to PC when no starting marker is available, which
// means they can't enter the desert. This should only happen if
// the modmaker has forgotten to put down a starting marker!
string INF_GetNoStartMessage()
{
    return "You see no guiding marker and wisely avoid going into the trackless desert.";
}


// For compilation testing only
/* void main() {} /* */
