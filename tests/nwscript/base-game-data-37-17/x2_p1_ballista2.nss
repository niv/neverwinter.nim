//::///////////////////////////////////////////////
//:: Ballista Fireball
//:: x2_p1_ballista
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball fired from a ballista is a burst of flame
// that detonates with a low roar and inflicts 2d6 points
// of damage to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 6/02
//:://////////////////////////////////////////////
//

#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables

    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(504); //Red chunks with sound
    effect eDam;
    //Get the spell target location as opposed to the spell target.

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetSpellTargetObject();
    //Cycle through the targets within the spell shape until an invalid object is captured.

    //Roll damage for each target
    nDamage = d6(2);
    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC());
    //Set the damage effect
    eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
    if(nDamage > 0)
    {
        // Apply effects to the currently selected target.
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        //This visual effect is applied to the target object not the location as above.  This visual effect
        //represents the flame that erupts on the target not on the ground.
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        //DelayCommand(fDelay, AssignCommand(oTarget, PlaySound("bf_med_insect")));
     }
}

