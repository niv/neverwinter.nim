//::///////////////////////////////////////////////
//:: x0_con_atwork
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if this area has this NPC
    marked as an employee
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

int StartingConditional()
{
    int iResult;

    iResult = IsAtJob(OBJECT_SELF) == TRUE;
    return iResult;
}
