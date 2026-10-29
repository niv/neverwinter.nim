//::///////////////////////////////////////////////
//:: Aura of Blinding On Enter
//:: NW_S1_AuraBlndA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be blinded because of the
    sheer ugliness or beauty of the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eLink = EffectLinkEffects(eBlind, eDur);
    int nDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;

    object oTarget = GetEnteringObject();
    int nDuration = 1 + GetHitDice(GetAreaOfEffectCreator())/3;
    //Scale the duration according to the HD of the monster
    nDuration = (nDuration / 3) + 1;
    //Entering object must make a will save or be blinded for the duration.
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_BLINDING));
        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            //Apply the blind effect and the VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        }
    }
}
