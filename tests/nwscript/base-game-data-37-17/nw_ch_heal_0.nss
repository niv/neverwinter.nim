//::///////////////////////////////////////////////
//:: Check Healing Class
//:: NW_D2_HEAL_0
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the PC is a Paladin, Ranger,
    Cleric, Bard or Druid
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
    return nClass;
}
