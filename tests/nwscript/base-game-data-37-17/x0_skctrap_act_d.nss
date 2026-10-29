//::///////////////////////////////////////////////
//:: x0_skctrap_act_d
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the current 'view mode' to sonic traps;
    this simplifies the dialog writing a little because
    I can reuse the check/make trap routines in one
    group of nodes.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_skills"

void main()
{
    skillCTRAPSetCurrentTrapView(SKILL_CTRAP_SONICCOMPONENT);
}

