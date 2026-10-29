//::///////////////////////////////////////////////
//:: Psionic Inertial Barrier
//:: x2_s1_psibarr.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Caster gains Damage Reduction that absorbs
    10 points of damage per hit die and lasts
    1 round per hit die

    damage power is +20 for illithids and
    shifter level /3

    Reduction is 10 + some amount per level

    Used by illithids and shifters
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Sept 2003
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
void main()
{
    //Declare major variables
    int nDuration;
    int nDamagePower;
    int nReduction;
    if (!GetIsPC(OBJECT_SELF))
    {
        nDuration = GetHitDice(OBJECT_SELF);
        nDamagePower =   DAMAGE_POWER_PLUS_TWENTY;
    }
    else // shifter
    {
        nDuration = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)/3) +1;
        nDamagePower = IPGetDamagePowerConstantFromNumber(nDuration);
    }
        nReduction = nDuration /2;
    if(nReduction <10)
    {
       nReduction = 10;
    }


    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eDam = EffectDamageReduction(nReduction, nDamagePower , nDuration*10);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    effect eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Apply the VFX impact and effects
    if (!GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
}

