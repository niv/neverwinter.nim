//::///////////////////////////////////////////////
//:: Racial Types Same and Intelligence Low
//:: NW_D2_RACESMI_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types the
            same AND
            Is Intelligence Low
*/
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"
int StartingConditional()
{
    return GetRacialType(OBJECT_SELF) == GetRacialType(GetPCSpeaker()) && CheckIntelligenceLow();
}
