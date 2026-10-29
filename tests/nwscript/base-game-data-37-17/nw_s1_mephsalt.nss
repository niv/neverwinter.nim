//::///////////////////////////////////////////////
//:: Salt Mephit Breath
//:: NW_S1_MephSalt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Salt Mephit shoots out a bolt of corrosive material
    that causes 1d4 damage and reduces AC and Attack by 2
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eBolt, eAttack, eAC;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Roll damage
    int nDamage = d4();
    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ACID);
    //Make a ranged touch attack
    int nTouch = TouchAttackRanged(oTarget);
    if(nDamage == 0) {nTouch = 0;}
    if(nTouch > 0)
    {
        if(nTouch == 2)
        {
            nDamage *= 2;
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MEPHIT_SALT_BREATH));

        //Set damage, AC mod and attack mod effects
        eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        eAC = EffectACDecrease(2);
        eAttack = EffectAttackDecrease(2);
        effect eLink = EffectLinkEffects(eAttack, eAC);
        eLink = EffectLinkEffects(eLink, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
