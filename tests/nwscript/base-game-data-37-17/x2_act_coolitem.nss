//::///////////////////////////////////////////////
//:: x2_act_coolitem
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script, when called -- best used
    as an ExecuteScript(x2_act_coolitem); --
    will spawn in a weapon suitable to the
    nearest seen PC.
    Trigger From: Best script is from a perception event
    or a placed trigger that is close to the enemy.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 18, 2003
//:://////////////////////////////////////////////
#include "x2_inc_treasure"

void main()
{
    object oOpener = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    if (GetIsObjectValid(oOpener))
    {   //SpeakString("Firing Exe script");
        object oItem = DTSGenerateCharSpecificTreasure(OBJECT_SELF,oOpener);
        DTSGrantCharSpecificWeaponEnhancement(GetHitDice(oOpener), oItem);
        if (GetIsObjectValid(oItem) == TRUE)
        {
            ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND);
        }
        else
        {
           // SpeakString("fail");
        }
    }
}
