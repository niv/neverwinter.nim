//::///////////////////////////////////////////////
//:: x0_skctrap_act_5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a deadly trap kit of the current 'trap type'

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "x0_inc_skills"

void main()
{
    skillCTRAPCreateTrapKit(skillCTRAPGetCurrentTrapView(), GetPCSpeaker(), SKILL_TRAP_DEADLY);
}

