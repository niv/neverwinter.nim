//::///////////////////////////////////////////////
//:: Gaze: Deatroy Evil
//:: NW_S1_GazeGood
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cone shape that affects all within the AoE if they
    fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 13, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

void main()
{
        if( GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }


    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDuration = 1 + (nHD / 3);
    int nDC = 10 + (nHD/2);
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DEATH));
                //Determine effect delay
                float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    //Apply the VFX impact and effects
                    //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGaze, oTarget));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}

