//::///////////////////////////////////////////////
//:: [Psionic Charm Monster]
//:: [x2_m1_CharmMon.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save DC 17 or the target is charmed for 4 rounds
//::   **UPDATE - Now doing confused effect instead of charmed**
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5, 2002
//:://////////////////////////////////////////////
//::

#include "NW_I0_SPELLS"    
void main()
{
     //Declare major variables
    int nDuration = 4;
    int nDC = 17;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectConfused();
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    effect eLink = EffectLinkEffects(eDur, eVisDur);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
    	{
            if(oTarget != OBJECT_SELF)
            {

                //Determine effect delay
                float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 552));
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    eGaze = GetScaledEffect(eGaze, oTarget);
                    eLink = EffectLinkEffects(eLink, eGaze);

                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}




