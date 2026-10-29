//::///////////////////////////////////////////////
//:: Attack on End of Conversation
//:: NW_D1_AttOnEnd02
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script makes an NPC attack the person
    they are currently talking with.  This will
    only make the single character hostile not
    their entire faction.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
void main()
{
    SetIsTemporaryEnemy(GetPCSpeaker());
    DetermineCombatRound();
}

