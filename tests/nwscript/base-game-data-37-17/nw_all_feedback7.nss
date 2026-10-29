//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK7.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Return true if Feedback, message #7 should be
  displayed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_FEEDBACK") == 7;
    return iResult;
}

