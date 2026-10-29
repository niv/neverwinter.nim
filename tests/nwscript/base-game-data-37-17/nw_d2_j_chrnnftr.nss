//::///////////////////////////////////////////////
//:: Non-Fighter Class, Charisma Normal
//:: TEMPL_FTR_CHRH
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is not a fighter class and
    has a Charisma of 9+
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 17, 2001
//:://////////////////////////////////////////////
#include "nw_i0_plot"

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    if (nClass=0)
    {
        return CheckCharismaNormal();
    }
    return FALSE;
}

