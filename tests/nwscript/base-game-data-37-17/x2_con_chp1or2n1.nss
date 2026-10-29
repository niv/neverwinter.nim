//::///////////////////////////////////////////////
//:: x2_con-chp1or2n1
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
        First time talked to in either Chapter 1 or
        Chapter 2.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    // * does not say this in Chapter 3
    if (GetTag(GetModule()) == "x0_module3")
    {
        return FALSE;
    }
    // * first time spoken to
    if (GetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES") == 0)
    {
        return TRUE;
    }
    return FALSE;
}

