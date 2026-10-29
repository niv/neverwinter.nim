//::///////////////////////////////////////////////
//:: x0_s3_berry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ice berry - gives animal companion ice-centered
        abilities
        
    Flame berry - gives animal companion fire-centered
        abilities
        
    Lasts for 1 turn per caster level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: March 2003
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void ImproveAnimal(object oTarget, int nVis, int nDamageType, int nDamageBonus, int nReduction)
{
    int nLevel = GetHitDice(OBJECT_SELF);
        effect eVis = EffectVisualEffect(nVis);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        effect eDamage = EffectDamageIncrease(nDamageBonus, nDamageType);
        effect eReduction = EffectDamageResistance(nDamageType, nReduction);
        effect eHaste = EffectHaste();
        effect eRegen = EffectRegenerate(1, 6.0);
        effect eLink = EffectLinkEffects(eDamage, eReduction);
        eLink = EffectLinkEffects(eLink, eHaste);
        eLink = EffectLinkEffects(eLink, eRegen);

        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        eLink = EffectLinkEffects(eLink, eDur);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel));

}
void main()
{
    int nId = GetSpellId();
    object oTarget = GetSpellTargetObject();
    object oMyCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);


    if (GetIsObjectValid(oMyCompanion) && GetIsObjectValid(oTarget))
    {
        if (oTarget == oMyCompanion)
        {
            // ice berry
            if (nId == 617)
            {
                // * remove the opposite berry
                RemoveSpellEffects(618, OBJECT_SELF, oTarget);
                ImproveAnimal(oTarget, VFX_IMP_FROST_L, DAMAGE_TYPE_COLD, DAMAGE_BONUS_1d10, 10);
            }
            // flame berry
            else
            if (nId == 618)
            {
                RemoveSpellEffects(617, OBJECT_SELF, oTarget);
                ImproveAnimal(oTarget, VFX_IMP_FLAME_M, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d10, 10);
            }
        }
        else
        {
            SpeakStringByStrRef(40076);
        }
    }
    else
    {
        SpeakStringByStrRef(40076);
    }
}
