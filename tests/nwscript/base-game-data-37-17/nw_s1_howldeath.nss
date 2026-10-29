//::///////////////////////////////////////////////
//:: Howl: Death
//:: NW_S1_HowlDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A howl emanates from the creature which affects
    all within 10ft unless they make a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
void main()
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    effect eHowl = EffectDeath();
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 10 + (nHD/4);
    float fDelay;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget) && !GetIsFriend(oTarget) && oTarget != OBJECT_SELF)
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_DEATH));
            fDelay = GetDistanceToObject(oTarget)/10;
            //Make a saving throw check
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

