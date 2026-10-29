//::///////////////////////////////////////////////
//:: Check Arcane
//:: NW_D2_Arcane
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC is a Wizard, Sorcerer or Bard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker());
    if (nClass>0)
    {
        return TRUE;
    }
    return FALSE;
}

