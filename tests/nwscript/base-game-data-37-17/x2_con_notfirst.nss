//::///////////////////////////////////////////////
//:: x2_con_notfirst
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if this is not the first time
    you've spoken to this character
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES") > 0)
        return TRUE;
    return FALSE;
}
