//::///////////////////////////////////////////////
//:: x0_skctrap_con_3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the player have at the average component
    for this type of trap.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "x0_inc_skills"

int StartingConditional()
{
    int iResult;

    iResult = skillCTRAPGetHasComponent(skillCTRAPGetCurrentTrapView(), GetPCSpeaker(), SKILL_TRAP_STRONG) == TRUE;
    return iResult;
}
