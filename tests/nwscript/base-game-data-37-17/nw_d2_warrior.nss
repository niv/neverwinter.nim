//::///////////////////////////////////////////////
//:: Check Warrior
//:: NW_D2_Warrior
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC is a Fighter, Ranger, Paladin, Barbarian, or Monk
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int nClass;
    nClass = GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker());
    nClass += GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker());
    if (nClass > 0)
    {
        return TRUE;
    }
    return FALSE;
}


