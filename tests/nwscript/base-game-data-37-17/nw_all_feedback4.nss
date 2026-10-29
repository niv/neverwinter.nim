//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK4.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Return true if you have not activated a Word of
  Recall before.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "NW_L_USED_RECALL") == 0;
    return iResult;
}



