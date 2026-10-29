//::///////////////////////////////////////////////
//:: Uber Attack on End of Conversation
//:: NW_D1_AttOnEndPL
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script makes an NPC attack the person
    they are currently talking with.
    - Turns Plot Flag off temporarily to allow hostility
    - Adjust both global and personal reputation
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: January 2002
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"


void main()
{
    object oPC = GetPCSpeaker();
    // * If GetPCSpeaker is invalid, then try last talker
    if (GetIsObjectValid(oPC) == FALSE)
    {
        oPC = GetLastSpeaker();
    }
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetIsTemporaryEnemy(oPC);
    AdjustReputation(oPC, OBJECT_SELF, -100);
    SetPlotFlag(OBJECT_SELF, TRUE);
    DetermineCombatRound(oPC);

}
