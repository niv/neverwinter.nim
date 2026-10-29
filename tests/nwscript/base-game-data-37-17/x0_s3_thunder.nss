//::///////////////////////////////////////////////
//:: Thunderstone
//:: x0_s3_thunder
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 All creatures in area of effect must make a FORT
 save vs.DC 15 or be deaf for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

float nSize =  RADIUS_SIZE_MEDIUM;

void main()
{
    //Declare major variables

    object oCaster = OBJECT_SELF;
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDeaf = EffectDeaf();
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    int nDuration = 5;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(3));

    //Apply epicenter explosion on caster
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
     	if(!GetIsReactionTypeFriendly(oTarget))
    	{
             SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
    	    {

                // * caster can't be affected by the spell
                if((oTarget != oCaster))
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 15))
                {

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nDuration)));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}










