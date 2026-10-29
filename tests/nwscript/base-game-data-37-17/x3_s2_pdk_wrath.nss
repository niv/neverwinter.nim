//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Oath of Wrath
//:: x3_s2_pdk_wrath.nss
//:://////////////////////////////////////////////
//:: Applies a temporary Attack, Save, Damage, Skill bonus vs
//:: monsters of the targets racial type
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////
/*
    Modified By : gaoneng erick
    Modified On : may 6, 2006
    added custom vfx
*/


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Target

    if (oPC == oTarget)
    {
         FloatingTextStringOnCreature("You cannot target yourself using this ability", oPC, FALSE);
         return;
    }
    if (GetIsFriend(oTarget))
    {
         FloatingTextStringOnCreature("You cannot target an ally using this ability", oPC, FALSE);
         return;
    }

    int nRace = GetRacialType(oTarget);// Get race of target
    int nClass = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
    int nDur = nClass * 2;// Duration
    int nBonus = 2;// Bonus value

    effect eAttack = EffectAttackIncrease(nBonus);// Increase attack
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING);// Increase damage
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);// Increase saving throws
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);    // Increase skills

    // Create 'versis racial type' effects
    eAttack = VersusRacialTypeEffect(eAttack, nRace);
    eDamage = VersusRacialTypeEffect(eDamage, nRace);
    eSave = VersusRacialTypeEffect(eSave, nRace);
    eSkill = VersusRacialTypeEffect(eSkill, nRace);

    // Apply effects to caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, RoundsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oPC, RoundsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oPC, RoundsToSeconds(nDur));

    // apply fx
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_OATH), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_WRATH), oTarget);
}
