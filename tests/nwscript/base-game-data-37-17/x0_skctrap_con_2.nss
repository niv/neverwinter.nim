//::///////////////////////////////////////////////
//:: x0_skctrap_con_2
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
    //SpeakString(skillCTRAPGetCurrentTrapView());
    iResult = skillCTRAPGetHasComponent(skillCTRAPGetCurrentTrapView(), GetPCSpeaker(), SKILL_TRAP_AVERAGE) == TRUE;
    return iResult;
}

