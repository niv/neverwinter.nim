//::///////////////////////////////////////////////
//:: Improved Grenade weapons script
//:: x2_s3_bomb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    More powerful versions of the standard grenade
    weapons.
    They do 10d6 points of damage and create an
    persistant AOE effect for a 5 rounds


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-18
//:://////////////////////////////////////////////

#include "x0_i0_spells"
void main()
{
    int nSpell = GetSpellId();


    if (nSpell == 745)  // acid bomb
    {
         DoGrenade(d6(10),1, VFX_IMP_ACID_L, VFX_FNF_LOS_NORMAL_30,DAMAGE_TYPE_ACID,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
         ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_FOGACID), GetSpellTargetLocation(), RoundsToSeconds(5));
    } else if (nSpell == 744)
    {
         DoGrenade(d6(10),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
         ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_FOGFIRE), GetSpellTargetLocation(), RoundsToSeconds(5));
    }




}
