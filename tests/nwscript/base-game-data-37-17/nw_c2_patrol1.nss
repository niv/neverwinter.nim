//::///////////////////////////////////////////////
//:: Patrol Alarm Guard, Ambient
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Guard occasionally mutters to self and stuff.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November
//:://////////////////////////////////////////////
#include "nw_i0_generic"

void main()
{
    // * If I can seen an enemy then don't do this
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    if (GetIsObjectValid(oPC) == TRUE)
      return;

    if (GetIsInCombat() == FALSE)
    {
      // SpeakString("in here");
        // * reset patrol state
        if (GetLocalInt(OBJECT_SELF,"NW_L_PATROLSTATE") > 0)
        {

            SetLocalInt(OBJECT_SELF,"NW_L_PATROLSTATE",0);
            ClearAllActions();
            WalkWayPoints();
            return;
        }
        int nRandom = Random(100);
        if (nRandom < 20)
        {
            SpeakOneLinerConversation();
        }
        else
        if (nRandom >= 20 && nRandom < 30)
        {
            ClearAllActions();
            PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,3.0);
            WalkWayPoints();
        }
        else
        if (nRandom >= 30 && nRandom < 40)
        {
            ClearAllActions();
            PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,3.0);
            WalkWayPoints();
        }
    }
}
