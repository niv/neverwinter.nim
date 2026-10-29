//::///////////////////////////////////////////////
//:: x2_con-chp3
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
        First time talked to in either Chapter 3.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    // * say this in Chapter 3 only
    if (GetTag(GetModule()) != "x0_module3")
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


