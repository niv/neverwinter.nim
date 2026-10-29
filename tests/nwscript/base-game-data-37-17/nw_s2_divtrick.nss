//::///////////////////////////////////////////////
//:: Divine Trickery
//:: NW_S2_DivTrick.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the user a bonus to Search, Disable Traps,
    Move Silently, Open Lock , Pick Pockets
    Set Trap for 5 Turns + Chr Mod
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA);
    int nLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    nLevel = 1 + nLevel/2;

    //Declare major variables
    effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nLevel);
    effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, nLevel);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nLevel);
    effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, nLevel);
    effect ePick = EffectSkillIncrease(SKILL_PICK_POCKET, nLevel);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nLevel);
    effect ePers = EffectSkillIncrease(SKILL_PERSUADE, nLevel);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    //Link Effects
    effect eLink = EffectLinkEffects(eSearch, eDisable);
    eLink = EffectLinkEffects(eLink, eMove);
    eLink = EffectLinkEffects(eLink, eOpen);
    eLink = EffectLinkEffects(eLink, ePick);
    eLink = EffectLinkEffects(eLink, eHide);
    eLink = EffectLinkEffects(eLink, ePers);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_TRICKERY, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
