//::///////////////////////////////////////////////
//:: Check SpellCasting Class
//:: NW_CH_SPELL_0
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check if the henchmen can cast spells
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC);
    nClass += GetLevelByClass(CLASS_TYPE_RANGER);
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN);
    nClass += GetLevelByClass(CLASS_TYPE_DRUID);
    nClass += GetLevelByClass(CLASS_TYPE_BARD);
    nClass += GetLevelByClass(CLASS_TYPE_WIZARD);
    nClass += GetLevelByClass(CLASS_TYPE_SORCERER);
    return nClass;
}

