//::///////////////////////////////////////////////
//:: Good Cleric
//:: TEMPL_GOODCLR
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is a cleric of non-evil alignment
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 14, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    if (nClass>0)
    {
        if (GetAlignmentGoodEvil(GetPCSpeaker()) != ALIGNMENT_EVIL)
        {
            return TRUE;
        }
        return FALSE;
    }
    return FALSE;
}

