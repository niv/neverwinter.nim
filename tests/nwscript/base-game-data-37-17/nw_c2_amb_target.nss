//::///////////////////////////////////////////////
//:: Ambient Attack placeables
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  This script attacks archery targets or
  training dummies, if a player is around to watch
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December 2001
//:://////////////////////////////////////////////

void main()
{
    if ((IsInConversation(OBJECT_SELF) == FALSE) && (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)) == TRUE)&&(GetIsInCombat() == FALSE))
    {
        ClearAllActions();
        ActionAttack(GetNearestObjectByTag("NW_TARGET"));
    }
}
