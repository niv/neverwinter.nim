//::///////////////////////////////////////////////
//:: Race
//:: TEMPL_RAC04
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is of the same race
    (but not human)
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 15, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (((GetRacialType(GetPCSpeaker()))==(GetRacialType(OBJECT_SELF))) && ((GetRacialType(GetPCSpeaker()))!=RACIAL_TYPE_HUMAN))
    {
        return TRUE;
    }
    return FALSE;
}

