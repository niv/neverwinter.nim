//::///////////////////////////////////////////////
//:: Attack on End of Conversation
//:: NW_D1_AttOnEnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script makes an NPC attack the person
    they are currently talking with.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"


void main()
{
    AdjustReputation(GetPCSpeaker(), OBJECT_SELF, -100);

    DetermineCombatRound();

}
