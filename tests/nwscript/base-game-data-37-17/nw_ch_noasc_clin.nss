//::///////////////////////////////////////////////
//:: Check to see if I have a Henchman already
//:: nw_ch_noassoc.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Intelligence Low
   */
//:://////////////////////////////////////////////
//:: Created By:     Brent
//:: Created On:     October 22, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
	int l_iResult;
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetPCSpeaker())) == FALSE)
    {
     return CheckIntelligenceLow();
    }
	return FALSE;
}

