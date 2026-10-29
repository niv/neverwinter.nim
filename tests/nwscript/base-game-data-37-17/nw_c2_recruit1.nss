//::///////////////////////////////////////////////
//:: Guard Summoned Heartbeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Looks for summoner.
   If summoner dead, be sad and return to point of spawn
   in.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_generic"

void SearchForPlayer()
{
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

        if (GetIsObjectValid(oPC) == FALSE)
        // * scratch head if cannot find anyone
        {
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
            if (Random(100) < 30)
            {
                SpeakOneLinerConversation();
            }

        }
        else
        {
            ClearAllActions();
            DetermineCombatRound(oPC);
        }
}

void main()
{
   if (GetIsInCombat() == TRUE)
     return;

   object oHostile = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

   // * if a hostile creature is around
   // * then don't run the heartbeat
   if (GetIsObjectValid(oHostile) == TRUE)
   {
    return;
   }
   if (GetLocalInt(OBJECT_SELF,"NW_L_ONTHEMOVE") == 1)
   {
       object oSummoner = GetLocalObject(OBJECT_SELF,"NW_L_MY_SUMMONER");
       ClearAllActions();

       if (GetIsObjectValid(oSummoner) == TRUE)
       {
        SpeakString("in move");

        if (GetDistanceToObject(GetLocalObject(OBJECT_SELF,"NW_L_MY_SUMMONER")) >= 3.5)
        {
            ActionMoveToObject(oSummoner, TRUE, 3.5);
        }
        else
        {
          SearchForPlayer();
        }
       }
       else
   // * My SUmmoner is dead
       {
            location lDest = GetLocalLocation(OBJECT_SELF,"NW_L_MY_SUMMONER_LOCATION");
            // * Weep for my summoner
            if (GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lDest) > 3.5)
            {
                ActionMoveToLocation(lDest, TRUE);
            }
            else
            {
                 ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING);
                 SearchForPlayer();
            }

           }
   } // only ever more there once
}
