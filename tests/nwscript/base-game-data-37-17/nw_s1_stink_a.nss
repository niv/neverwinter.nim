//::///////////////////////////////////////////////
//:: Stinking Cloud On Enter
//:: NW_S1_Stink_A.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if(GetRacialType(oTarget) != RACIAL_TYPE_VERMIN)
    {
        if(GetIsEnemy(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 14, SAVING_THROW_TYPE_POISON))
            {
               fDelay = GetRandomDelay(0.25, 1.0);
               //Apply the VFX impact and linked effects
               if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
               {
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
               }
            }
        }
    }
}
