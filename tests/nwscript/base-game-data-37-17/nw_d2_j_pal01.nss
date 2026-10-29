//::///////////////////////////////////////////////
//:: Paladin
//:: TEMPL_PAL01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character has paladin as their highest level
    and is still Lawful Good
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 14, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    int oClass;
    nClass = GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    oClass = GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker());
    oClass += GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker());
    if ((nClass>=oClass) && (nClass!=0))
    {
        if ((GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_GOOD) && (GetAlignmentLawChaos(GetPCSpeaker()) == ALIGNMENT_LAWFUL))
        {
            return TRUE;
        }
        return FALSE;
    }
    return FALSE;
}

