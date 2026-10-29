//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK3.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Return true if ANY player has activated a Word of
  Recall before.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "NW_L_LOC_EVERUSED")>0;
    return iResult;
}


