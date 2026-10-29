//::///////////////////////////////////////////////
//:: Howl: Sonic
//:: NW_S1_HowlSonic
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
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eHowl;
    effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    int nHD = GetHitDice(OBJECT_SELF);
    int nAmount = nHD/4;
    if(nAmount == 0)
    {
        nAmount = 1;
    }
    int nDC = 10 + nAmount;
    int nDamage;
    float fDelay;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsFriend(oTarget) && oTarget != OBJECT_SELF)
    	{
            fDelay = GetDistanceToObject(oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_SONIC));
            nDamage = d6(nAmount);
            //Make a saving throw check
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC, OBJECT_SELF, fDelay))
            {
                nDamage = nDamage / 2;
            }
            //Set damage effect
            eHowl = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            //Apply the VFX impact and effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}


