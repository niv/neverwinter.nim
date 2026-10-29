//::///////////////////////////////////////////////
//:: Etherealness
//:: x2_s1_ether.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Turns a creature ethereal
    Used by one of the undead shape forms for
    shifter/druids. lasts 5 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/08/01
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_BLUR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSanc = EffectEthereal();
    effect eLink = EffectLinkEffects(eVis, eSanc);
    eLink = EffectLinkEffects(eLink, eDur);
    int nDuration = 5;
    //Enter Metamagic conditions

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply the VFX impact and effects
    if(!GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }

}

