//::///////////////////////////////////////////////
//:: x2_i0_spells
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Expansion 2 and above include file for spells
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 2002
//:: Updated On: 2003/09/10 - Georg Zoeller
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
#include "x0_i0_spells"

//------------------------------------------------------------------------------
// GZ: These constants are used with for the AOE behavior AI
//------------------------------------------------------------------------------
const int X2_SPELL_AOEBEHAVIOR_FLEE = 0;
const int X2_SPELL_AOEBEHAVIOR_IGNORE = 1;
const int X2_SPELL_AOEBEHAVIOR_GUST = 2;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_L = SPELL_LESSER_DISPEL;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_N = SPELL_DISPEL_MAGIC;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_G = SPELL_GREATER_DISPELLING;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_M = SPELL_MORDENKAINENS_DISJUNCTION;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_C = 727;


// * Will pass back a linked effect for all of the bad tide of battle effects.
effect CreateBadTideEffectsLink();
// * Will pass back a linked effect for all of the good tide of battle effects.
effect CreateGoodTideEffectsLink();
// * Passes in the slashing weapon type
int GetSlashingWeapon(object oItem);
// * Passes in the melee weapon type
int GetMeleeWeapon(object oItem);
// * Passes in if the item is magical or not.
int GetIsMagicalItem(object oItem);
// * Passes back the stat bonus of the characters magical stat, if any.
int GetIsMagicStatBonus(object oCaster);

// * Save DC against Epic Spells is the relevant ability score of the caster
// * + 20. The hightest ability score of the casting relevants is 99.99% identical
// * with the one that is used for casting, so we just take it.
// * if used by a placeable, it is equal to the placeables WILL save field.
int GetEpicSpellSaveDC(object oCaster);

// * Hub function for the epic barbarian feats that upgrade rage. Call from
// * the end of the barbarian rage spellscript
void CheckAndApplyEpicRageFeats(int nRounds);

// * Checks the character for the thundering rage feat and will apply temporary massive critical
// * to the worn weapons
// * called by CheckAndApplyEpicRageFeats(
void CheckAndApplyThunderingRage(int nRounds);

// * Checks and runs Rerrifying Rage feat
// * called by CheckAndApplyEpicRageFeats(
void CheckAndApplyTerrifyingRage(int nRounds);


// * Do a mind blast
// nDC      - DC of the Save to resist
// nRounds  - Rounds the stun effect holds
// fRange   - Range of the EffectCone
void DoMindBlast(int nDC, int nDuration, float fRange);


//::///////////////////////////////////////////////
//:: CreateBadTideEffectsLink
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the linked bad effects for Battletide.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

effect CreateBadTideEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the effects
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

//::///////////////////////////////////////////////
//:: CreateGoodTideEffectsLink
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the linked good effects for Battletide.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

effect CreateGoodTideEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //Link the effects
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE if oItem is a slashing weapon
//------------------------------------------------------------------------------
int GetSlashingWeapon(object oItem)
{
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD)||
      (nItem == BASE_ITEM_SCIMITAR)||
      (nItem == BASE_ITEM_SCYTHE)||
      (nItem == BASE_ITEM_SICKLE)||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_THROWINGAXE) ||
      (nItem == BASE_ITEM_WHIP)

      )
   {
        return TRUE;
   }
   return FALSE;
}


//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE if oItem is a ranged weapon
//------------------------------------------------------------------------------
int GetIsRangedWeapon(object oItem)
{
    // GZ: replaced if statement with engine function
    return GetWeaponRanged(oItem);
}

//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE, if oItem is a melee weapon
//------------------------------------------------------------------------------
int GetMeleeWeapon(object oItem)
{
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD) ||
      (nItem == BASE_ITEM_SCIMITAR) ||
      (nItem == BASE_ITEM_SCYTHE) ||
      (nItem == BASE_ITEM_SICKLE) ||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_CLUB) ||
      (nItem == BASE_ITEM_DAGGER) ||
      (nItem == BASE_ITEM_DIREMACE) ||
      (nItem == BASE_ITEM_HEAVYFLAIL) ||
      (nItem == BASE_ITEM_LIGHTFLAIL) ||
      (nItem == BASE_ITEM_LIGHTHAMMER) ||
      (nItem == BASE_ITEM_LIGHTMACE) ||
      (nItem == BASE_ITEM_MORNINGSTAR) ||
      (nItem == BASE_ITEM_QUARTERSTAFF) ||
      (nItem == BASE_ITEM_RAPIER) ||
      (nItem == BASE_ITEM_SHORTSPEAR) ||
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_WARHAMMER)  ||
      (nItem == BASE_ITEM_WHIP)  ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_MAGICSTAFF) ||
      (nItem == BASE_ITEM_TRIDENT) )
   {
        return TRUE;
   }
   return FALSE;
}

//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE if oItem has any item property that classifies it as magical item
//------------------------------------------------------------------------------
int GetIsMagicalItem(object oItem)
{
    //Declare major variables
    int nProperty;

    if((GetItemHasItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_VULNERABILITY)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ABILITY_SCORE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_LIGHT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIND_BLANK)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MONSTER_DAMAGE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_NO_DAMAGE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_MONSTER_HIT)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_POISON)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_THIEVES_TOOLS)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRAP)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_TURN_RESISTANCE)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_UNLIMITED_AMMUNITION)) ||
      (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL))
      )
   {
        return TRUE;
   }
   return FALSE;
}


//::///////////////////////////////////////////////
//:: GetIsMagicStatBonus
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the modifier from the ability
    score that matters for this caster
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int GetIsMagicStatBonus(object oCaster)
{
    //Declare major variables
    int nClass;
    int nAbility;

    if(nClass = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_INTELLIGENCE;
        }
    }
    if(nClass = GetLevelByClass(CLASS_TYPE_BARD, oCaster) || GetLevelByClass(CLASS_TYPE_SORCERER, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_CHARISMA;
        }
    }
    else if(nClass = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) || GetLevelByClass(CLASS_TYPE_DRUID, oCaster)
         || GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) || GetLevelByClass(CLASS_TYPE_RANGER, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_WISDOM;
        }
    }

    return GetAbilityModifier(nAbility, oCaster);
}

//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Hub function for the epic barbarian feats that upgrade rage. Call from
// the end of the barbarian rage spellscript
//------------------------------------------------------------------------------
void CheckAndApplyEpicRageFeats(int nRounds)
{
    CheckAndApplyThunderingRage(nRounds);
    CheckAndApplyTerrifyingRage(nRounds);
}

//------------------------------------------------------------------------------
// GZ, 2003-07-09
// If the character calling this function from a spellscript has the thundering
// rage feat, his weapons are upgraded to deafen and cause 2d6 points of massive
// criticals
//------------------------------------------------------------------------------
void CheckAndApplyThunderingRage(int nRounds)
{
    if (GetHasFeat(988, OBJECT_SELF))
    {
        object oWeapon =  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        if (GetIsObjectValid(oWeapon))
        {
           IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
           IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
           IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        }

        oWeapon =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        if (GetIsObjectValid(oWeapon) )
        {
           IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
           IPSafeAddItemProperty(oWeapon,ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        }


     }
}

//------------------------------------------------------------------------------
// GZ, 2003-07-09
// If the character calling this function from a spellscript has the terrifying
// rage feat, he gets an aura of fear for the specified duration
// The saving throw against this fear is a check opposed to the character's
// intimidation skill
//------------------------------------------------------------------------------
void CheckAndApplyTerrifyingRage(int nRounds)
{
    if (GetHasFeat(989, OBJECT_SELF))
    {
        effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR,"x2_s2_terrage_A", "","");
        eAOE = ExtraordinaryEffect(eAOE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAOE,OBJECT_SELF,RoundsToSeconds(nRounds));
    }
}



//------------------------------------------------------------------------------
//Keith Warner
//   Do a mind blast
//   nHitDice - HitDice/Caster Level of the creator
//   nDC      - DC of the Save to resist
//   nRounds  - Rounds the stun effect holds
//   fRange   - Range of the EffectCone
//------------------------------------------------------------------------------
void DoMindBlast(int nDC, int nDuration, float fRange)
{
    int nStunTime;
    float fDelay;

    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eCone;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);

    while(GetIsObjectValid(oTarget))
    {
        int nApp = GetAppearanceType(oTarget);
        int bImmune = FALSE;
        //----------------------------------------------------------------------
        // Hack to make mind flayers immune to their psionic attacks...
        //----------------------------------------------------------------------
        if (nApp == 413 ||nApp== 414 || nApp == 415)
        {
            bImmune = TRUE;
        }

        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF && !bImmune )
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            // already stunned
            if (GetHasSpellEffect(GetSpellId(),oTarget))
            {
                 // only affects the targeted object
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
                int nDamage;
                if (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>0)
                {
                    nDamage = d6(GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)/3);
                }
                else
                {
                    nDamage = d6(GetHitDice(OBJECT_SELF)/2);
                }
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND), oTarget);
            }
            else if (WillSave(oTarget, nDC) < 1)
            {
                //Calculate the length of the stun
                nStunTime = nDuration;
                //Set stunned effect
                eCone = EffectStunned();
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, RoundsToSeconds(nStunTime)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);
    }
}


// * Gelatinous Cube Paralyze attack
int  DoCubeParalyze(object oTarget, object oSource, int nSaveDC = 16)
{
   if (GetIsImmune(oTarget,IMMUNITY_TYPE_PARALYSIS) )
   {
        return FALSE;
   }

    if (FortitudeSave(oTarget,nSaveDC, SAVING_THROW_TYPE_POISON,oSource) == 0)
    {
      effect ePara =  EffectParalyze();
      effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
      ePara = EffectLinkEffects(eDur,ePara);
      ePara = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),ePara);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePara,oTarget,RoundsToSeconds(3+d3())); // not 3 d6, thats not fun
      return TRUE;
    }
    else
    {
     effect eSave = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oTarget);
    }
    return FALSE;
}


// --------------------------------------------------------------------------------
// GZ: Gel. Cube special abilities
// --------------------------------------------------------------------------------
void EngulfAndDamage(object oTarget, object oSource)
{

  if (ReflexSave(oTarget, 13 + GetHitDice(oSource) - 4, SAVING_THROW_TYPE_NONE,oSource) == 0)
  {

      FloatingTextStrRefOnCreature(84610,oTarget); // * Engulfed
      int nDamage = d6(1);

      effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
      effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
      if (!GetIsImmune(oTarget,IMMUNITY_TYPE_PARALYSIS) )
      {
          if (DoCubeParalyze(oTarget,oSource,16))
          {
               FloatingTextStrRefOnCreature(84609,oTarget);
          }
       }

  } else
  {
      effect eSave = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oTarget);
  }


}
// --------------------------------------------------------------------------------
// Georg Zoeller, 2003-09-19
// Save DC against Epic Spells is the relevant ability score of the caster
// + 20. The hightest ability score of the casting relevants is 99.99% identical
// with the one that is used for casting, so we just take it.
// if used by a placeable, it is equal to the placeables WILL save field.
// --------------------------------------------------------------------------------
int GetEpicSpellSaveDC(object oCaster)
{

    // * Placeables use their WILL Save field as caster level
    if (GetObjectType(oCaster) == OBJECT_TYPE_PLACEABLE)
    {
        return GetWillSavingThrow(oCaster);
    }

    int nWis = GetAbilityModifier(ABILITY_WISDOM,oCaster);
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE,oCaster);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA,oCaster);

    int nHigh = nWis;
    if (nHigh < nInt)
    {
        nHigh = nInt;
    }
    if (nHigh < nCha)
    {
        nHigh = nCha;
    }
    int nRet = 20 + nHigh;
    return nRet;
}

// --------------------------------------------------------------------------------
// GZ: Sept 2003
// Determines the optimal behavior against AoESpell nSpellId for a NPC
// use in OnSpellCastAt
// --------------------------------------------------------------------------------
int GetBestAOEBehavior(int nSpellID)
{
        if (nSpellID == SPELL_GREASE)
        {
           if (spellsIsFlying(OBJECT_SELF))
           return X2_SPELL_AOEBEHAVIOR_IGNORE;
        }

//        if (GetHasSpell(SPELL_GUST_OF_WIND) == TRUE)
        if (GetHasSpell(SPELL_GUST_OF_WIND))
            return X2_SPELL_AOEBEHAVIOR_GUST;

        if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_AI_DISPEL_AOE) == 0 )
        {
            if (d100() > GetLocalInt(GetModule(),MODULE_VAR_AI_NO_DISPEL_AOE_CHANCE))
            {
//                if (GetHasSpell(SPELL_LESSER_DISPEL) == TRUE)
                if (GetHasSpell(SPELL_LESSER_DISPEL))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_L;
//                if (GetHasSpell(SPELL_DISPEL_MAGIC) == TRUE)
                if (GetHasSpell(SPELL_DISPEL_MAGIC))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_N;
//                if (GetHasSpell(SPELL_GREATER_DISPELLING) == TRUE)
                if (GetHasSpell(SPELL_GREATER_DISPELLING))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_G;
//                if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION) == TRUE)
                if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_M;
            }
        }

    return X2_SPELL_AOEBEHAVIOR_FLEE;
}


//--------------------------------------------------------------------------
// GZ: 2003-Oct-15
// Removes all effects from nID without paying attention to the caster as
// the spell can from only one caster anyway
// By default, it will only cancel magical effects
//--------------------------------------------------------------------------
void GZRemoveSpellEffects(int nID,object oTarget, int bMagicalEffectsOnly = TRUE)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectSpellId(eEff) == nID)
        {
            if (GetEffectSubType(eEff) != SUBTYPE_MAGICAL && bMagicalEffectsOnly)
            {
                // ignore
            }
            else
            {
                RemoveEffect(oTarget,eEff);
            }
        }
        eEff = GetNextEffect(oTarget);
    }
}

//------------------------------------------------------------------------------
// GZ: 2003-Oct-15
// A different approach for timing these spells that has the positive side
// effects of making the spell dispellable as well.
// I am using the VFX applied by the spell to track the remaining duration
// instead of adding the remaining runtime on the stack
//
// This function returns FALSE if a delayed Spell effect from nSpell_ID has
// expired. See x2_s0_bigby4.nss for details
//------------------------------------------------------------------------------
int GZGetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster)
{

    if (!GetHasSpellEffect(nSpell_ID,oTarget) )
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    //--------------------------------------------------------------------------
    // GZ: 2003-Oct-15
    // If the caster is dead or no longer there, cancel the spell, as it is
    // directed
    //--------------------------------------------------------------------------
    if( !GetIsObjectValid(oCaster))
    {
        GZRemoveSpellEffects(nSpell_ID, oTarget);
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    if (GetIsDead(oCaster))
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        GZRemoveSpellEffects(nSpell_ID, oTarget);
        return TRUE;
    }

    return FALSE;

}



