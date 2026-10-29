//::///////////////////////////////////////////////
//:: Ironguts
//:: X2_S0_Ironguts
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: When touched the target creature gains a +4
//:: circumstance bonus on Fortitude saves against
//:: all poisons.
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 19/10/2003

#include "x2_inc_spellhook"
#include "nw_i0_spells"

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
    effect eSave;
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

   //Stacking Spellpass, 2003-07-07, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    int nBonus = 4; //Saving throw bonus to be applied
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl * 10; // Turns
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    //Set the bonus save effect
    eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonus, SAVING_THROW_TYPE_POISON);
    effect eLink = EffectLinkEffects(eSave, eDur);

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
}

