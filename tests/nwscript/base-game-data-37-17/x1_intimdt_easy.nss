//::///////////////////////////////////////////////
//:: Name: x1_intimdt_easy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
        Do an easy intimidation check - return
        TRUE on success
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Feb 13/03
//:://////////////////////////////////////////////

//#include "nw_i0_plot"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    int nLevel = GetHitDice(oPC);
    int nBase;
    int nTest = 0;
    if (nLevel <= 0)
    {
        nLevel = 1;
    }
    nTest = nLevel / 4 + 1;


    nBase = GetSkillRank(SKILL_PERSUADE, oPC) + GetAbilityModifier(ABILITY_STRENGTH, oPC);
    if (GetRacialType(oPC) == RACIAL_TYPE_HALFORC)
        nBase += 1;
    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == TRUE)
        nBase += 1;
    if (GetHasFeat(FEAT_THUG, oPC) == TRUE)
        nBase += 1;
    // * Roll d20 + base vs. DC + 10
    if (nBase + d20() >= (nTest + 10) )
    {
       return TRUE;
    }
    return FALSE;

}

