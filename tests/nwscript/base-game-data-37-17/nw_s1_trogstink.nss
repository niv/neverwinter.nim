//::///////////////////////////////////////////////
//:: Troglidyte Stench
//:: nw_s1_TrogStench.nss
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects entering the aura must make a fortitude saving
    throw (DC 13) or suffer 1d6 points of Strength
    Ability Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Craig Welburn
//:: Created On: Nov 6, 2004
//:://////////////////////////////////////////////

void main()
{
    effect eStench = EffectAreaOfEffect(AOE_MOB_TROGLODYTE_STENCH);
    eStench = SupernaturalEffect(eStench);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStench, OBJECT_SELF);
}
