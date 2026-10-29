//::///////////////////////////////////////////////
//:: Racial Types same non-human and Intelligence Normal
//:: NW_D2_RACESMI_N
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types the
            same AND not human AND
            Is Intelligence Normal
*/
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"
int StartingConditional()
{
    return GetRacialType(OBJECT_SELF) == GetRacialType(GetPCSpeaker()) && GetRacialType(GetPCSpeaker())!=RACIAL_TYPE_HUMAN &&
CheckIntelligenceNormal();
}



