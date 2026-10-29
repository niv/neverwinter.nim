//::///////////////////////////////////////////////
//:: Temple Cast Heal
//:: NW_D1_TEMPLEHEAL.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Fakes the effects of a greater restorations spell on the PC and
  any associates.
*/
//:://////////////////////////////////////////////
//:: Created By:     Aidan
//:: Created On:     May29,2002
//:://////////////////////////////////////////////
void FakeRestore(object oTarget);

void main()
{
    object oPC = GetPCSpeaker();
    object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,1);
    object oHenchman2 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,2);
    object oHenchman3 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,3);
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
        // checks to see if they have any cure crital wound potions; if not, creates it on them.
        if (!GetIsObjectValid(GetItemPossessedBy(oHenchman,"NW_IT_MPOTION003")))
        {
            CreateItemOnObject("NW_IT_MPOTION003",oHenchman,3);
        }
    }
    if(GetIsObjectValid(oHenchman2))
    {
        ActionDoCommand(FakeRestore(oHenchman2));
        // checks to see if they have any cure crital wound potions; if not, creates it on them.
        if (!GetIsObjectValid(GetItemPossessedBy(oHenchman2,"NW_IT_MPOTION003")))
        {
            CreateItemOnObject("NW_IT_MPOTION003",oHenchman2,3);
        }
    }
    if(GetIsObjectValid(oHenchman3))
    {
        ActionDoCommand(FakeRestore(oHenchman3));
        // checks to see if they have any cure crital wound potions; if not, creates it on them.
        if (!GetIsObjectValid(GetItemPossessedBy(oHenchman3,"NW_IT_MPOTION003")))
        {
            CreateItemOnObject("NW_IT_MPOTION003",oHenchman3,3);
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
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
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
//        if (nHeal > 0)
//            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        // Mar 2, 2004: Always heal at least one hp. Otherwise, if you have the wounding effect
        // but are at max hp (because of regeneration or whatever), the wounding will not
        // be removed.
        if(nHeal<1) nHeal=1;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}
