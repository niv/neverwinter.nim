//::///////////////////////////////////////////////
//:: Divine Class
//:: NW_D2_CLASSHOLY
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is a paladin or cleric
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    return nClass;
}
