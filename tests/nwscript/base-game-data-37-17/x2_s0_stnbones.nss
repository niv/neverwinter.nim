//::///////////////////////////////////////////////
//:: Stone Bones
//:: X2_S0_StnBones
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the target +3 AC Bonus to Natural Armor.
    Only if target creature is undead.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

#include "nw_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDuration  = nCasterLvl * 10;
    int nMetaMagic = GetMetaMagicFeat();
    int nRacial = GetRacialType(oTarget);
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Set the one unique armor bonuses
    effect eAC1 = EffectACIncrease(3, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAC1, eDur);

    //Stacking Spellpass, 2003-07-07, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    if(nRacial == RACIAL_TYPE_UNDEAD)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else
    {
        FloatingTextStrRefOnCreature(85390,OBJECT_SELF); // only affects undead;
    }
}
