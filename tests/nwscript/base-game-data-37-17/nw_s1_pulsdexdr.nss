//::///////////////////////////////////////////////
//:: Pulse: Dexterity Drain
//:: NW_S1_PulsDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A wave of energy emanates from the creature which affects
    all within 10ft.  Damage can be reduced by half for all
    damaging variants.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nDamage = GetHitDice(OBJECT_SELF)/5;
    if (nDamage == 0)
    {
        nDamage = 1;
    }
    float fDelay;
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 10 + nHD;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eHowl;
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	if(oTarget != OBJECT_SELF)
    	{
        	if(!GetIsReactionTypeFriendly(oTarget))
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY));
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Make a saving throw check
                if(!/*FortSave*/MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
                {
                    //Set the Ability mod and change to supernatural effect
                    eHowl = EffectAbilityDecrease(ABILITY_DEXTERITY, nDamage);
                    eHowl = SupernaturalEffect(eHowl);
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHowl, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get first target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}

