//::///////////////////////////////////////////////
//:: x0_d2_level2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if henchman in primary class levelup mode
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "X0_L_LEVELRULES") == 2)
    {
        return TRUE;
    }
    return FALSE;
}
