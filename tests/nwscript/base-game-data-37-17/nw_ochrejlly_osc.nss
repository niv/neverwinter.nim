//::///////////////////////////////////////////////
//:: nw_ochrejlly_osc
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This NPC On Spell Cast at script is specially
    designed for Orche Jellys. It will check to
    see what spell was cast at it, then (it the
    spell was electrical) it will cause the jelly
    to split into smaller jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: Oct, 2004
//:: Modified On: January, 2006
//:://////////////////////////////////////////////
#include "nw_i0_ochrejelly"

void main()
{
    object oPC = GetLastSpellCaster();
    object oSelf = OBJECT_SELF;

    int iCurrentHP = GetCurrentHitPoints(oSelf);
    int iSpell = GetLastSpell();

    effect eGhost = EffectCutsceneGhost();

    // if the Spell is eletrical in nature, split the Jelly into smaller jellies
    if((iSpell == SPELL_BALL_LIGHTNING) || (iSpell == SPELL_CHAIN_LIGHTNING)
      || (iSpell == SPELL_ELECTRIC_JOLT) || (iSpell == SPELL_GEDLEES_ELECTRIC_LOOP)
      || (iSpell == SPELL_GREAT_THUNDERCLAP) || (iSpell == SPELL_HAMMER_OF_THE_GODS)
      || (iSpell == SPELL_LIGHTNING_BOLT) || (iSpell == SPELL_STORM_OF_VENGEANCE))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oSelf);
        SplitCreature(oSelf, iCurrentHP);
    }
    ExecuteScript("x2_def_ondamage", oSelf);
}
