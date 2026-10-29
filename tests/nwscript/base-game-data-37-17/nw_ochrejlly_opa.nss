//::///////////////////////////////////////////////
//:: nw_ochrejlly_opa
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The NPC On Physically Attacked script is for the
    Ochre Jellies in PotSC. If the Target is physically
    attacked, divide into smaller jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: August 2004
//:: Modified On: January, 2006
//:://////////////////////////////////////////////
#include "nw_i0_ochrejelly"

void main()
{
    object oPC = GetLastAttacker();
    object oSelf = OBJECT_SELF;
    object oWeapon = GetLastWeaponUsed(oPC);

    effect eGhost = EffectCutsceneGhost();
    int iCurrentHP = GetCurrentHitPoints(oSelf);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oSelf);
    SplitCreature(oSelf, iCurrentHP);
}
