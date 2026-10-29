//::///////////////////////////////////////////////
//:: NW_S3_HERB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Various herbs to offer bonuses to the player using
   them.
   Belladonna:
   Garlic:
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void main()
{
    int nID = GetSpellId();
    // * Belladonna
    if (nID == 409)
    {
       object oTarget = GetSpellTargetObject();
       effect eVisual = EffectVisualEffect(VFX_IMP_AC_BONUS);
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisual, oTarget);
       effect eACBonus = VersusRacialTypeEffect(EffectACIncrease(5), RACIAL_TYPE_SHAPECHANGER);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACBonus, oTarget, 60.0);

    }
    else
    // * Garlic; protection against Vampires
    // * Lowers charisma
    if (nID == 410)
    {
       object oTarget = GetSpellTargetObject();
       effect eAttackBonus = VersusRacialTypeEffect(EffectAttackIncrease(2), RACIAL_TYPE_UNDEAD);
       effect eCharisma = EffectAbilityDecrease(ABILITY_CHARISMA, 1);
       effect eVisual = EffectVisualEffect(VFX_IMP_AC_BONUS);
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisual, oTarget);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttackBonus, oTarget, 60.0);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharisma, oTarget, 60.0);

    }

}
