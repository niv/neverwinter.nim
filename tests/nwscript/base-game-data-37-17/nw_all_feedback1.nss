//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Return true if Feedback, message #1 should be
  displayed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_FEEDBACK") == 1;
    return iResult;
}
