//::///////////////////////////////////////////////
//:: Barbarian
//:: TEMPL_BBN01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character has barbarian as their highest level
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    int oClass;
    nClass = GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker());
    oClass = GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker());
    if ((nClass>=oClass) && (nClass!=0))
    {
        return TRUE;
    }
    return FALSE;
}

