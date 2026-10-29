//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: August  2003
//:: Updated   : October 2003
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    int nRounds;
    effect eHold = EffectParalyze();
    effect eDur = EffectVisualEffect(476  );
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    int nMetaMagic = GetMetaMagicFeat();
    effect eLink = EffectLinkEffects(eDur,eHold);
    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD));
        //Make a SR check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
                //Make a Fort Save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                   nRounds = MaximizeOrEmpower(6, 1, nMetaMagic);
                   fDelay = GetRandomDelay(0.45, 1.85);
                   //Apply the VFX impact and linked effects
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds)));
                }
        }
    }
}
