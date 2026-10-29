//::///////////////////////////////////////////////
//:: NW_C2_BOSSDIE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 This script fires when the boss monster dies.
 It creates boss monster treasure on the creature.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "NW_O2_CONINCLUDE"


void main()
{

    object oKiller = GetLastKiller();
    if (GetIsObjectValid(oKiller) == TRUE)
    {
        // * If I have a master then use him to determine the treasure
        if (GetIsObjectValid(GetMaster(oKiller)) == TRUE)
        {
            oKiller = GetMaster(oKiller);
        }
         // * generate boss treasure
         // * May 13 2002: For some reason death seems able to happen multiple
         // * times. Made it so that the treasure will only spawn once
         if (GetLocalInt(OBJECT_SELF, "NW_L_SPAWNTREASURE1X") == 0)
         {
            GenerateNPCTreasure(4, OBJECT_SELF, oKiller);
            SetLocalInt(OBJECT_SELF, "NW_L_SPAWNTREASURE1X", 1);
         }
    }
    else
        AssignCommand(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC), SpeakString("No Killer!"));



    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        object oKiller = GetLastKiller();
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);
    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
}

