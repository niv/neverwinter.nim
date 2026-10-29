//::///////////////////////////////////////////////
//:: Race Type Different, Intelligence Low
//:: NW_D2_RACEDIFI_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types different
            AND Is Intelligence Low
*/
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"
int StartingConditional()
{
    return GetRacialType(OBJECT_SELF) != GetRacialType(GetPCSpeaker()) && CheckIntelligenceLow();
}

