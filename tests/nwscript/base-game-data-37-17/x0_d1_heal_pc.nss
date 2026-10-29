//::///////////////////////////////////////////////////
//:: X0_D1_HEAL_PC
/*
  Fakes the effects of a greater restorations spell on the PC and
  any associates.

  Taken almost entirely from Bioware's NW_D1_TEMPLEHEAL script.
*/
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/11/2002
//::///////////////////////////////////////////////////

void FakeRestore(object oTarget);

void main()
{
    object oPC = GetPCSpeaker();
    object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC);
    object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC);
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC);
    object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC);
    object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC);
    ActionPauseConversation();
    ActionCastFakeSpellAtObject(SPELL_GREATER_RESTORATION, OBJECT_SELF);
    ActionDoCommand(FakeRestore(oPC));
    if(GetIsObjectValid(oHenchman))
    {
        ActionDoCommand(FakeRestore(oHenchman));
        // checks to see if they have any cure crital wound potions; 
        // if not, creates it on them.
        if (!GetIsObjectValid(GetItemPossessedBy(oHenchman,"NW_IT_MPOTION003")))
        {
            CreateItemOnObject("NW_IT_MPOTION003",oHenchman,3);
        }
    }
    if(GetIsObjectValid(oAnimal))
    {
        ActionDoCommand(FakeRestore(oAnimal));
    }
    if(GetIsObjectValid(oFamiliar))
    {
        ActionDoCommand(FakeRestore(oFamiliar));
    }
    if(GetIsObjectValid(oDominated))
    {
        ActionDoCommand(FakeRestore(oDominated));
    }
    if(GetIsObjectValid(oSummoned))
    {
        ActionDoCommand(FakeRestore(oSummoned));
    }
    ActionResumeConversation();
}

void FakeRestore(object oTarget)
{
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        int nEffectType = GetEffectType(eBad);
        if (nEffectType == EFFECT_TYPE_ABILITY_DECREASE ||
            nEffectType == EFFECT_TYPE_AC_DECREASE ||
            nEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE ||
            nEffectType == EFFECT_TYPE_ATTACK_DECREASE ||
            nEffectType == EFFECT_TYPE_BLINDNESS ||
            nEffectType == EFFECT_TYPE_CHARMED ||
            nEffectType == EFFECT_TYPE_CONFUSED ||
            nEffectType == EFFECT_TYPE_CURSE ||
            nEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE ||
            nEffectType == EFFECT_TYPE_DAMAGE_DECREASE ||
            nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            nEffectType == EFFECT_TYPE_DAZED ||
            nEffectType == EFFECT_TYPE_DEAF ||
            nEffectType == EFFECT_TYPE_DISEASE ||
            nEffectType == EFFECT_TYPE_DOMINATED ||
            nEffectType == EFFECT_TYPE_ENTANGLE ||
            nEffectType == EFFECT_TYPE_FRIGHTENED ||
            nEffectType == EFFECT_TYPE_NEGATIVELEVEL ||
            nEffectType == EFFECT_TYPE_PARALYZE ||
            nEffectType == EFFECT_TYPE_PETRIFY ||
            nEffectType == EFFECT_TYPE_POISON ||
            nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            nEffectType == EFFECT_TYPE_SILENCE ||
            nEffectType == EFFECT_TYPE_SKILL_DECREASE ||
            nEffectType == EFFECT_TYPE_SLEEP ||
            nEffectType == EFFECT_TYPE_SLOW ||
            nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            nEffectType == EFFECT_TYPE_STUNNED)
        {
            //Remove effect if it is negative.
            RemoveEffect(oTarget, eBad);
        }
        eBad = GetNextEffect(oTarget);
    }

    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        effect eHeal = EffectHeal(nHeal);
        if (nHeal > 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}
