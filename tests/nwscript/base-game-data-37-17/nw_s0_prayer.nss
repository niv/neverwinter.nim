//::///////////////////////////////////////////////
//:: Prayer
//:: NW_S0_Prayer.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allies gain +1 Attack, damage, saves, skill checks
    Enemies gain -1 to these stats
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    effect ePosVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eNegVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    int nBonus = 1;
    effect eBonAttack = EffectAttackIncrease(nBonus);
    effect eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eBonDam = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
    effect eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
    effect ePosDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    
    effect ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
    ePosLink = EffectLinkEffects(ePosLink, eBonDam);
    ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
    ePosLink = EffectLinkEffects(ePosLink, ePosDur);

    effect eNegAttack = EffectAttackDecrease(nBonus);
    effect eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nBonus);
    effect eNegDam = EffectDamageDecrease(nBonus, DAMAGE_TYPE_SLASHING);
    effect eNegSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nBonus);
    effect eNegDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);


    effect eNegLink = EffectLinkEffects(eNegAttack, eNegSave);
    eNegLink = EffectLinkEffects(eNegLink, eNegDam);
    eNegLink = EffectLinkEffects(eNegLink, eNegSkill);
    eNegLink = EffectLinkEffects(eNegLink, eNegDur);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Metamagic duration check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	if(GetIsFriend(oTarget))
    	{
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER, FALSE));
            //Apply VFX impact and bonus effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePosVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePosLink, oTarget,RoundsToSeconds(nDuration));
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER));
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Apply VFX impact and bonus effects
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegLink, oTarget, RoundsToSeconds(nDuration));
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}


