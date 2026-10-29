//::///////////////////////////////////////////////
//:: Pulse Drown
//:: NW_S1_PulsDrwn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    CHANGED JANUARY 2003
     - does an actual 'drown spell' on each target
     in the area of effect.
     - Each use of this spells consumes 50% of the
     elementals hit points.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watmaniuk
//:: Created On: April 15, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
void Drown(object oTarget)
{

    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    // * certain racial types are immune
    if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
     &&(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
     &&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
    {
        //Make a fortitude save
        if(MySavingThrow(SAVING_THROW_FORT, oTarget, 20) == FALSE)
        {
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            //Set damage effect to kill the target
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);

         }
    }
}
void main ()
{
    int nDamage = GetCurrentHitPoints() / 2;
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamage(nDamage), OBJECT_SELF);
    //Declare major variables
    object oTarget;
    int bSave = FALSE;
    int nIdx;

    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget) == TRUE)
    {
      	if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_DROWN));
            Drown(oTarget);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}


