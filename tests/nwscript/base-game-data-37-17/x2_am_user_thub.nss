//::///////////////////////////////////////////////
//:: x2_am_user_thub
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script responds to requests from other
    townhubs to share crowd patrons
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void main()
{
//SpawnScriptDebugger();

    int nUser = GetUserDefinedEventNumber();
   // SpeakString("got user event");
    
    if(nUser == EVENT_NEEDMOREPATRONS) //NEED MORE PATRONS
    {
      // * will only give up a bar patron
      // * if it has five of them or more
      object oFive = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, 5);
      if (CreatureValidForHubUse(oFive) == TRUE)
      {
       // SpeakString("will ask patron to leave");
        AskPatronToLeave(oFive);
      }
    }
}

