//::///////////////////////////////////////////////
//:: Pulse: Fire
//:: NW_S1_PulsFire
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

void main()
{
    //Declare major variables
    int nDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eHowl;
    float fDelay;
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 10 + nHD;
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
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
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_FIRE));
                //Roll the damage
                nDamage = d6(nHD);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                eHowl = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}


