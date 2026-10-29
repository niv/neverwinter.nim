//::///////////////////////////////////////////////
//:: x0_d2_level1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if henchman in Secondary class levelup mode
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "X0_L_LEVELRULES") == 1)
    {
        return TRUE;
    }
    return FALSE;
}
