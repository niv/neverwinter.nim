//::///////////////////////////////////////////////
//:: x0_skctrap_act_4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a strong trap kit of the current 'trap type'

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "x0_inc_skills"

void main()
{
    skillCTRAPCreateTrapKit(skillCTRAPGetCurrentTrapView(), GetPCSpeaker(), SKILL_TRAP_STRONG);
}

