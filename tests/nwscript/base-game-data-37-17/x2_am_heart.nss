//::///////////////////////////////////////////////
//:: x2_am_heart
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ambient system heartbeat.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
#include "nw_i0_generic"
void debugit(string s)
{
   // if (GetTag(OBJECT_SELF) == "TownWait01")
 //       if (GetLocalInt(OBJECT_SELF, "NW_L_RANDOMTAG") == 0) SetLocalInt(OBJECT_SELF, "NW_L_RANDOMTAG", Random(10000));
}
void main()
{

    if (GetAILevel() < AI_LEVEL_LOW) return; // * don't run this if no one is around


     //if (GetAmbientBusy(OBJECT_SELF) == TRUE)
     //{
     //   debugit("ambient mode = TRUE");
     //}
     //if (GetReady(OBJECT_SELF) == FALSE)
     //{
     //   debugit("not ready");
     //}
     //if (GetInTransition(OBJECT_SELF) == TRUE)
     //{
     //   debugit("transition");
     //}
     //else
     //{
     //   debugit("no transition");
     //}

    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        if(TalentAdvancedBuff(40.0))
        {
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);
            return;
        }
    }

     // * Nov 8: added conditions before they are allowed to try and leave
     if(GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING) )
    {
        // * bk NOV 1:  Trying to streamline the day/night transitioning
        // * scripting
        // * Nov 8: Adding the transition setting to it, to prevent
        // * the barmaid from being over eager in serving drinks to everyone
        // * even after closing
        //debugit("check action move");
        if (GetCurrentAction() != ACTION_MOVETOPOINT && GetCurrentAction() != ACTION_DIALOGOBJECT)
        {
            //debugit("going to check on waypoints");
            object oDayWay = GetObjectByTag("POST_" + GetTag(OBJECT_SELF));
            object oNightWay = GetObjectByTag("NIGHT_" + GetTag(OBJECT_SELF));
            if (
                GetIsObjectValid(oDayWay) == TRUE && GetIsDay() == TRUE
                && GetArea(oDayWay) != GetArea(OBJECT_SELF)
                )
            {
                //debugit("going to Day waypoint");
                SetInTransition(TRUE, OBJECT_SELF);
                WalkWayPoints();
            }
            else
            if (
                GetIsObjectValid(oNightWay) == TRUE && GetIsNight() == TRUE
                && GetArea(oNightWay) != GetArea(OBJECT_SELF)
                )
            {
                //debugit("going to Night waypoint");
                SetInTransition(TRUE, OBJECT_SELF);
                WalkWayPoints();
            }
            else
            // * I am in the right area
            {
                //debugit("debug transition OFF");
                if (GetInTransition() == TRUE)
                {
                    SetInTransition(FALSE, OBJECT_SELF);
                }
            }

        }
    }
   //debugit("try job");
   DoJob();

    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1001));
    }

}
