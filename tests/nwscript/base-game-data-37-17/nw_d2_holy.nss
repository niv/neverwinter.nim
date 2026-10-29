//::///////////////////////////////////////////////
//:: Check Holy Class
//:: NW_D2_Holy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the PC is a Paladin or Cleric
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: Nov 14, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    return nClass;
}
