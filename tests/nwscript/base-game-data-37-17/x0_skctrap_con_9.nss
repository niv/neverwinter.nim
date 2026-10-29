//::///////////////////////////////////////////////
//:: x0_skctrap_con_9
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the player have at least one GAS
    trap component?
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "x0_inc_skills"

int StartingConditional()
{
    int iResult;

    iResult = skillCTRAPGetHasComponent(SKILL_CTRAP_GASCOMPONENT, GetPCSpeaker(), SKILL_TRAP_MINOR) == TRUE;
    return iResult;
}
