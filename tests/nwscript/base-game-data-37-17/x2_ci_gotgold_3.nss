//::///////////////////////////////////////////////
//:: Check if PC has enough gold for crafting
//:: x2_ci_gotgold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Check if PC has enough gold for crafting
    the requested item

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-10-06
//:://////////////////////////////////////////////


#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;
    int nNumber = 2;
    object oPC = GetPCSpeaker();
    int       nSkill      =  GetLocalInt(oPC,"X2_CI_CRAFT_SKILL");
    string s2DA;
    if (nSkill == 26) // craft weapon
    {
        s2DA = X2_CI_CRAFTING_WP_2DA;
    }
    else if (nSkill == 25)
    {
        s2DA = X2_CI_CRAFTING_AR_2DA;
    }

    int nRow = GetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW");
    struct craft_struct stItem =  CIGetCraftItemStructFrom2DA(s2DA,nRow,0);

    iResult = (GetGold(oPC) >= stItem.nCost);
    return iResult;
}
