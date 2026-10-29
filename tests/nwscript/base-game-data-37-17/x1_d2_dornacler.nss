//::///////////////////////////////////////////////
//:: x1_d2_dornacler
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true only if Dorna has at least
   one level in cleric.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0)
    {
        return TRUE;
    }
    return FALSE;
}
