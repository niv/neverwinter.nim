//::///////////////////////////////////////////////
//:: Divine Strength
//:: NW_S2_DivStr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cleric gains +2 to strength +1 for every 3 levels
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 4, 2001
//:://////////////////////////////////////////////


void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eStr;
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCasterLvl = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nModify = (nCasterLvl/3) + 2;
    int nDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA);
    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_STRENGTH, FALSE));

    //Apply effects and VFX to target
    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
    effect eLink = EffectLinkEffects(eStr, eDur);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
