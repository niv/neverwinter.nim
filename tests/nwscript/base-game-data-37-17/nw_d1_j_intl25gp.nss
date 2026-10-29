//::///////////////////////////////////////////////
//:: Intelligence 8- Has 25 GP
//:: TEMPL_I825GP
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the character has a low normal int
    and has 25 gp
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    int l_iResult;
    l_iResult = GetAbilityScore(GetPCSpeaker(),ABILITY_INTELLIGENCE);
    if (l_iResult < 9)
    {
        return (HasGold(25,GetPCSpeaker()));
    }
    return FALSE;
}

