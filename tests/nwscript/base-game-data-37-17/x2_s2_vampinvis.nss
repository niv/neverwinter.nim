// Special 5 rounds improved invisibility for shifter

#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = OBJECT_SELF;
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur, eVis);
    eLink = EffectLinkEffects(eDur,eInvis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    int nDuration = 5;
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    if (GetAppearanceType(OBJECT_SELF) == 156)
    {
        eLink = EffectLinkEffects(EffectCutsceneGhost(),eLink);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

    //Spectres also turn CutsceneGhost for that duration

}




