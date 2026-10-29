//::///////////////////////////////////////////////
//:: Aura Stunning On Enter
//:: NW_S1_AuraStunA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eVis2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDeath = EffectStunned();
    effect eLink = EffectLinkEffects(eVis2, eDeath);
    int nDuration = GetHitDice(GetAreaOfEffectCreator());
    nDuration = (nDuration / 3) + 1;
    int nDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;
    nDuration = GetScaledDuration(nDuration, oTarget);
	if(!GetIsFriend(oTarget))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_STUN));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
