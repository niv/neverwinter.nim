//::///////////////////////////////////////////////
//:: Outsider Shape - Azer - Fire stream
//:: x2_s2_gwburn
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

  Azer shoot fire ability. The fire they breathe
  is natural, so there is no SR check against it

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "x2_inc_shifter"
void main()
{
    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    /*    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }
    */

    //--------------------------------------------------------------------------
    // Create VFX
    //--------------------------------------------------------------------------
    object oTarget = GetSpellTargetObject();
    int     nTouch = TouchAttackRanged(oTarget);
    effect eRay      = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST,(nTouch == 0));
    effect eDur      = EffectVisualEffect(498);


    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/14;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRay,oTarget,1.7f);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));


    if (nTouch > 0)
    {
        int nDamage = ((GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)/3)* d4()) + GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);
        if (nTouch ==2)
        {
            nDamage *= 2;
        }
        int nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL);
        nDamage = GetReflexAdjustedDamage(nDamage,oTarget,nDC,SAVING_THROW_TYPE_FIRE,OBJECT_SELF);
        effect eDamage = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
        effect eHit = EffectVisualEffect(VFX_IMP_FLAME_S);

        eHit = EffectLinkEffects(eDamage,eHit);
        DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,3.0f));
        DelayCommand(fDelay+0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget,3.0f));
    }


}



