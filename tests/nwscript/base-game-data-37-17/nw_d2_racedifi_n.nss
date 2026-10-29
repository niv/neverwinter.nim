//::///////////////////////////////////////////////
//:: Race Type Different, Intelligence Normal
//:: NW_D2_RACEDIFI_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types different
            AND
            Is Intelligence Normal
*/
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"
int StartingConditional()
{
    return GetRacialType(OBJECT_SELF) != GetRacialType(GetPCSpeaker()) && CheckIntelligenceNormal();
}

