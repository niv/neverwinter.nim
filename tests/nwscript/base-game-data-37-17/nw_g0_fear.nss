//::///////////////////////////////////////////////
//:: Fear Heartbeat
//:: NW_G0_FEAR
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the heartbeat that runs on a creature
    when the creature is under the fear effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////

#include "x0_inc_henai"

void main()
{    SendForHelp();
    //Allow the target to recieve commands for the round
    SetCommandable(TRUE);

    ClearAllActions();
    int nCnt = 1;

    //Get the nearest creature to the affected creature
    object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
    
    while (GetIsObjectValid(oTarget) && fDistance < 5.0)
    {
        fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
        if(GetIsEnemy(oTarget) && fDistance <= 5.0)
        {
            //Run away if they are an enemy of the target's faction
            ActionMoveAwayFromObject(oTarget, TRUE);
            break;
        }

        //If not an enemy interate and find the next target
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    }
    
    //Disable the ability to recieve commands.
    SetCommandable(FALSE);
}
