//::///////////////////////////////////////////////
//:: Intimidate Check Easy - Strength Based
//:: x2_intdtstr_easy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made a easy
    intimidate check. (#24 in the skills.2da), and
    include the PCs strength bonus for this check
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 22/03
//:://////////////////////////////////////////////
#include "nw_i0_plot"


int StartingConditional()
{
    return CheckDCStr(DC_EASY, 24, GetPCSpeaker());
}

