//::///////////////////////////////////////////////
//:: x2_portal_gate_7
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    REturns true if the chapter is NOT in
    Chapter 3 & info has not yet been revealed
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    if ((GetTag(GetModule()) != "x0_module3") && (GetLocalInt(GetModule(), "X2_L_DEATHINFOREVEALED") == 0))
    {
        return TRUE;
    }
    return FALSE;
}
