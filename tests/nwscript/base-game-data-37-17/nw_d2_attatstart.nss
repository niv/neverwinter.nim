//::///////////////////////////////////////////////
//:: NW_D2_ATTATASTART
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Always returns True and makes the NPC go hostile

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nw_i0_generic"

int StartingConditional()
{
    int iResult;
    object oFirst = GetFirstFactionMember(GetPCSpeaker());
    while (GetIsObjectValid(oFirst) == TRUE)
    {
        AdjustReputation(oFirst, OBJECT_SELF, -100);
        oFirst = GetNextFactionMember(oFirst);
    }
    DetermineCombatRound();
    iResult = TRUE;
    return iResult;
}
