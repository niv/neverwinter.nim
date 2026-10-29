//::///////////////////////////////////////////////
//:: nw_all_feedbackh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Only returns true if a lost item store has
    called it.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_IAMLOSTSTORE") == 10;
    return iResult;
}
