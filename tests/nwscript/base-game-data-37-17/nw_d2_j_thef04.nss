//::///////////////////////////////////////////////
//:: Wizard Class, Intelligence Low
//:: TEMPL_FTR_CHRH
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is a rogue or bard
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 19, 2001
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker());
    if (nClass>0)
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}

