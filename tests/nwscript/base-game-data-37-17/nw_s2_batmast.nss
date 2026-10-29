//::///////////////////////////////////////////////
//:: Battle Mastery
//:: NW_S2_BatMast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    1st to 5th Level
        +1 Hit, Con, Dex, Damage
        Damage Reduction of 2/+5
    6th to 10th Level
        +2 Hit, Con, Dex, Damage
        Damage Reduction of 4/+5
    11th to 15th Level
        +3 Hit, Con, Dex, Damage
        Damage Reduction of 6/+5
    16 and up
        +4 Hit, Con, Dex, Damage
        Damage Reduction of 8/+5
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Novemeber 4, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Mitchell Fujino, December 10, 2003.
//::         added Epic Level support.

void main()
{
    //Determine bonus amount
    int nBonus = GetLevelByClass(CLASS_TYPE_CLERIC);
    nBonus /= 5;
    nBonus = nBonus + 1;

    // Have to seperate damage due to epic levels.
    int nDamBonus = nBonus;
    if (nDamBonus > 5)
    {
        nDamBonus += 10;
    }

    //Declare effects
    effect eAttack = EffectAttackIncrease(nBonus);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nBonus);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nBonus);
    effect eDam = EffectDamageIncrease(nDamBonus, DAMAGE_TYPE_BLUDGEONING);
    nBonus *= 2;
    effect eDamRed = EffectDamageReduction(nBonus, DAMAGE_POWER_PLUS_FIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eCon);
    eLink = EffectLinkEffects(eLink, eDex);
    eLink = EffectLinkEffects(eLink, eDam);
    eLink = EffectLinkEffects(eLink, eDamRed);
    eLink = EffectLinkEffects(eLink, eDur);
    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BATTLE_MASTERY, FALSE));

    //Determined duration
    int nDuration = GetAbilityModifier(ABILITY_CHARISMA) + 5;
    //Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

}

