//::///////////////////////////////////////////////
//:: Racial Types Same
//:: NW_D2_RACESAME
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types the
            same.
*/
//:://////////////////////////////////////////////

int StartingConditional()
{
    return GetRacialType(OBJECT_SELF) == GetRacialType(GetPCSpeaker());
}
