//:://////////////////////////////////////////////////
//:: X0_I0_MATCH
/*
  Library for 'matching' functions. These functions
  check to see whether a given value matches one of a long
  set of constants, so they're simple but big and ugly.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/21/2003
//:: Updated By: Georg Zoeller, 2003/10/20
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

//Talent Type Constants
const int NW_TALENT_PROTECT = 1;
const int NW_TALENT_ENHANCE = 2;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/


// Used to break protections into 3 categories:
// COMBAT, SPELL and ELEMENTAL.
// sClass should be one of: FIGHTER, CLERIC, MAGE, MONSTER
// nType should always be:  NW_TALENT_PROTECT
int GetMatchCompatibility(talent tUse, string sClass, int nType);

// * Do I have any effect on me that came from a mind affecting spell?
int MatchDoIHaveAMindAffectingSpellOnMe(object oTarget);

// * if the passed in spell is an area of effect spell of any kind
int MatchAreaOfEffectSpell(int nSpell);

// * Is this spell a combat protection spells?
int MatchCombatProtections(talent tUse);

// * Is this talent a protection against spells?
int MatchSpellProtections(talent tUse);

// * Is this talent a protection against elemental damage?
int MatchElementalProtections(talent tUse);

// * Is this item a single-handed weapon?
int MatchSingleHandedWeapon(object oItem);

// TRUE if the item is a double-handed weapon
int MatchDoubleHandedWeapon(object oItem);

// TRUE if the item is a melee weapon
int MatchMeleeWeapon(object oItem);

// TRUE if the item is a shield
int MatchShield(object oItem);

// True if the item is a crossbow
int MatchCrossbow(object oItem);

// True if the item is a longbow or shortbow
int MatchNormalBow(object oItem);

// * is this a mind affecting spell?
int MatchMindAffectingSpells(int iSpell);

// * is this a charm type spell?
int MatchPersonSpells(int iSpell);

// True if this spell is one of the Reverse Healing touch Attacks
int MatchInflictTouchAttack(int nSpell);
// True if the creature is an elemental, undead, or golem
int MatchNonliving(int nRacialType);


//    Checks that the melee talent being used
//    is Disarm and if so then if the target has a
//    weapon.
//
//    This should return TRUE if:
//    - we are not trying to use disarm
//    - we are using disarm appropriately
//
//    This should return FALSE if:
//    - we are trying to use disarm on an inappropriate target
//    - we are using disarm too frequently
//
//    If this returns FALSE, we will fall back to a standard
//    melee attack instead.
int VerifyDisarm(talent tUse, object oTarget);

//     Makes sure that certain talents are not used
//     on Elementals, Undead or Constructs
int VerifyCombatMeleeTalent(talent tUse, object oTarget);

// Checks the target for a specific EFFECT_TYPE constant value
int GetHasEffect(int nEffectType, object oTarget = OBJECT_SELF);

// Returns a potential removal spell that might be useful in
// this situation.
// This is not yet defined.
// int GetRemovalSpell();


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: Protection Matching Functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    These three functions break protections into
    3 categories COMBAT, SPELL and ELEMENTAL
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

int GetMatchCompatibility(talent tUse, string sClass, int nType)
{
    int bValid;
    if(nType == NW_TALENT_PROTECT)
    {
        if(sClass == "FIGHTER")
        {
            if(MatchCombatProtections(tUse))
            {
                bValid = TRUE;
            }
        }
        else if(sClass == "MAGE")
        {
            if(MatchSpellProtections(tUse))
            {
                bValid = TRUE;
            }
            else if(MatchElementalProtections(tUse))
            {
                bValid = TRUE;
            }
        }
        else if(sClass == "CLERIC" || sClass == "MONSTER")
        {
            if(MatchCombatProtections(tUse))
            {
                bValid = TRUE;
            }
            else if(MatchElementalProtections(tUse))
            {
                bValid = TRUE;
            }
        }
    }

    return bValid;
}

int MatchCombatProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_PREMONITION ||
       nIndex == SPELL_ELEMENTAL_SHIELD ||
       nIndex == SPELL_GREATER_STONESKIN ||
       nIndex == SPELL_SHADOW_SHIELD ||
       nIndex == SPELL_ETHEREAL_VISAGE ||
       nIndex == SPELL_STONESKIN ||
       nIndex == SPELL_GHOSTLY_VISAGE ||
       nIndex == SPELL_MESTILS_ACID_SHEATH ||
       nIndex == SPELL_DEATH_ARMOR||
       nIndex == 695 // epic warding

       )
    {
        return TRUE;
    }
    return FALSE;
}

int MatchSpellProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_GREATER_SPELL_MANTLE ||
       nIndex == SPELL_SPELL_MANTLE ||
       nIndex == SPELL_LESSER_SPELL_MANTLE ||
       nIndex == SPELL_SHADOW_SHIELD ||
       nIndex == SPELL_GLOBE_OF_INVULNERABILITY ||
       nIndex == SPELL_MINOR_GLOBE_OF_INVULNERABILITY ||
       nIndex == SPELL_ETHEREAL_VISAGE ||
       nIndex == SPELL_GHOSTLY_VISAGE ||
       nIndex == SPELL_SPELL_RESISTANCE ||
       nIndex == SPELL_PROTECTION_FROM_SPELLS ||
       nIndex == SPELL_NEGATIVE_ENERGY_PROTECTION   )
    {
        return TRUE;
    }
    return FALSE;
}

// * if the passed in spell is an area of effect spell of any kind
int MatchAreaOfEffectSpell(int nSpell)
{
    int nMatch = FALSE;

    switch (nSpell)
    {
        case SPELL_ACID_FOG          : nMatch = TRUE;break;
        case SPELL_MIND_FOG          : nMatch = TRUE; break;
        case SPELL_STORM_OF_VENGEANCE: nMatch = TRUE; break;
//      case SPELL_WEB               : nMatch = TRUE; break;
        case SPELL_GREASE            : nMatch = TRUE; break;
        case SPELL_CREEPING_DOOM     : nMatch = TRUE; break;
//      case SPELL_DARKNESS          : nMatch = TRUE; break;
        case SPELL_SILENCE           : nMatch = TRUE; break;
        case SPELL_BLADE_BARRIER     : nMatch = TRUE; break;
        case SPELL_CLOUDKILL         : nMatch = TRUE; break;
        case SPELL_STINKING_CLOUD    : nMatch = TRUE; break;
        case SPELL_WALL_OF_FIRE      : nMatch = TRUE; break;
        case SPELL_INCENDIARY_CLOUD  : nMatch = TRUE; break;
        case SPELL_ENTANGLE          : nMatch = TRUE; break;
        case SPELL_EVARDS_BLACK_TENTACLES: nMatch = TRUE; break;
        case SPELL_CLOUD_OF_BEWILDERMENT : nMatch = TRUE; break;
        case SPELL_STONEHOLD             : nMatch = TRUE; break;
        case SPELL_VINE_MINE             : nMatch = TRUE; break;
        case SPELL_SPIKE_GROWTH          : nMatch = TRUE; break;
        case SPELL_DIRGE                 : nMatch = TRUE; break;
        case 530                         : nMatch = TRUE; break;  // vine mine
        case 531                         : nMatch = TRUE; break;  // vine mine
        case 532                         : nMatch = TRUE; break;  // vine mine

    }
    return nMatch;
}

int MatchElementalProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_ENERGY_BUFFER ||
       nIndex == SPELL_PROTECTION_FROM_ELEMENTS ||
       nIndex == SPELL_RESIST_ELEMENTS ||
       nIndex == SPELL_ENDURE_ELEMENTS)
    {
        return TRUE;
    }
    return FALSE;
}

// * Returns a potential removal spell that might be useful in this situation
int GetRemovalSpell()
{
//   if (GetHasSpell(SPELL_DISPEL_MAGIC, OBJECT_SELF) == TRUE) return SPELL_DISPEL_MAGIC;
//   if (GetHasSpell(SPELL_LESSER_DISPEL, OBJECT_SELF) == TRUE) return SPELL_LESSER_DISPEL;
//   if (GetHasSpell(SPELL_GREATER_DISPELLING, OBJECT_SELF) == TRUE) return SPELL_GREATER_DISPELLING;
//   if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, OBJECT_SELF) == TRUE) return SPELL_MORDENKAINENS_DISJUNCTION;
   if (GetHasSpell(SPELL_DISPEL_MAGIC, OBJECT_SELF)) return SPELL_DISPEL_MAGIC;
   if (GetHasSpell(SPELL_LESSER_DISPEL, OBJECT_SELF)) return SPELL_LESSER_DISPEL;
   if (GetHasSpell(SPELL_GREATER_DISPELLING, OBJECT_SELF)) return SPELL_GREATER_DISPELLING;
   if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, OBJECT_SELF)) return SPELL_MORDENKAINENS_DISJUNCTION;
   return -1;
}

// * Do I have any effect on me that came from a mind affecting spell?
int MatchDoIHaveAMindAffectingSpellOnMe(object oTarget)
{
    if  (
        GetHasSpellEffect(SPELL_SLEEP, oTarget) ||
        GetHasSpellEffect(SPELL_DAZE, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CONFUSION, oTarget)  ||
        GetHasSpellEffect(SPELL_MIND_FOG, oTarget)   ||
        GetHasSpellEffect(SPELL_CLOUD_OF_BEWILDERMENT, oTarget)   ||
        GetHasSpellEffect(SPELLABILITY_BOLT_DOMINATE,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_CHARM,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_CONFUSE,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_DAZE,oTarget)
        )
        return TRUE;
    return FALSE;
}

// Paus
int MatchMindAffectingSpells(int iSpell)
{
    switch (iSpell) {
        case SPELL_SLEEP:
        case SPELL_DAZE:
        case SPELL_HOLD_ANIMAL:
        case SPELL_HOLD_MONSTER:
        case SPELL_HOLD_PERSON:
        case SPELL_CHARM_MONSTER:
        case SPELL_CHARM_PERSON:
        case SPELL_CHARM_PERSON_OR_ANIMAL:
        case SPELL_MASS_CHARM:
        case SPELL_DOMINATE_ANIMAL:
        case SPELL_DOMINATE_MONSTER:
        case SPELL_DOMINATE_PERSON:
        case SPELL_CONFUSION:
        case SPELL_SPHERE_OF_CHAOS:
        case SPELL_CLOAK_OF_CHAOS:
        case SPELL_MIND_FOG:
        case SPELL_CLOUD_OF_BEWILDERMENT:
            return TRUE; break;

        default: break;
    }

    return FALSE;
}
// Paus
int MatchPersonSpells(int iSpell) {

   switch (iSpell) {
        case SPELL_HOLD_PERSON:
        case SPELL_CHARM_PERSON:
        case SPELL_DOMINATE_PERSON:
            return TRUE; break;

        default: break;
    }

    return FALSE;
}


int MatchSingleHandedWeapon(object oItem)
{
    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_WARHAMMER: return TRUE;
        break;

        default: break;
     }
     return FALSE;
}

// TRUE if the item is a double-handed weapon
int MatchDoubleHandedWeapon(object oItem)
{
    switch (GetBaseItemType(oItem)) {
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_TRIDENT:
        return TRUE;
    }
    return FALSE;
}

// TRUE if the item is a melee weapon
int MatchMeleeWeapon(object oItem)
{
    return (MatchSingleHandedWeapon(oItem) || MatchDoubleHandedWeapon(oItem));
}

// TRUE if the item is a shield
int MatchShield(object oItem)
{
    switch (GetBaseItemType(oItem)) {
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_TOWERSHIELD:
        return TRUE;
    }
    return FALSE;
}

// True if the item is a crossbow
int MatchCrossbow(object oItem)
{
    switch (GetBaseItemType(oItem)) {
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
        return TRUE;
    }
    return FALSE;
}

// True if the item is a longbow or shortbow
int MatchNormalBow(object oItem)
{
    switch (GetBaseItemType(oItem)) {
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_SHORTBOW:
        return TRUE;
    }
    return FALSE;
}

// True if this spell is one of the Reverse Healing touch Attacks
int MatchInflictTouchAttack(int nSpell)
{
    int nMatch = FALSE;

    switch (nSpell)
    {
        case SPELL_INFLICT_CRITICAL_WOUNDS:
        case SPELL_INFLICT_LIGHT_WOUNDS:
        case SPELL_INFLICT_MINOR_WOUNDS:
        case SPELL_INFLICT_MODERATE_WOUNDS:
        case SPELL_INFLICT_SERIOUS_WOUNDS:
        case SPELL_HARM: nMatch = TRUE; break;
   }
   return nMatch;
}

// True if the creature is an elemental, undead, or golem
int MatchNonliving(int nRacialType)
{
    int nMatch = FALSE;

    switch (nRacialType)
    {
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD: nMatch = TRUE; break;
   }
   return nMatch;

}

//::///////////////////////////////////////////////
//:: Verify Disarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//    Checks that the melee talent being used
//    is Disarm and if so then if the target has a
//    weapon.
//
//    This should return TRUE if:
//    - we are not trying to use disarm
//    - we are using disarm appropriately
//
//    This should return FALSE if:
//    - we are trying to use disarm on an inappropriate target
//    - we are using disarm too frequently
//
//    If this returns FALSE, we will fall back to a standard
//    melee attack instead.
int VerifyDisarm(talent tUse, object oTarget)
{
    if(GetTypeFromTalent(tUse) == TALENT_TYPE_FEAT
       && GetIdFromTalent(tUse) == FEAT_DISARM)
    {

        // * If the creature is not capable of being disarmed
        // * don't waste time trying to do so
        // * October 3, Brent
        if (GetIsCreatureDisarmable(oTarget) == FALSE)
        {
            return FALSE;
        }

        // * the associates given Disarm were given it intentionally
        // * they try to use this ability as often as possible
        int bIsAssociate = FALSE;
        if (GetIsObjectValid(GetMaster()) == TRUE)
        {
            bIsAssociate = TRUE;
        }
        // * disarm happens infrequently
        if (d10() > 4 && bIsAssociate == FALSE) return FALSE;

        object oSlot1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        object oSlot2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        if(GetIsObjectValid(oSlot1) || GetIsObjectValid(oSlot2))
        {
            if(GetIsObjectValid(oWeapon) && !GetWeaponRanged(oWeapon))
            {
                // Enemy has a weapon and so do we
                return TRUE;
            }
            else if (GetIsObjectValid(oWeapon2) && !GetWeaponRanged(oWeapon2))
            {
                // ditto
                return TRUE;
            } else {
                // they've got something, but we don't!
                // BK Changed this to return true. Creatures that do not
                // carry weapons should still be capable of disarming
                // people. If you don't want an unarmed creature to attempt
                // a disarm, then don't give it the disarm feat in the first place.
                return TRUE;
            }
        } else {
            // they don't have anything to disarm!
            return FALSE;
        }
    }

    // We're not trying to use disarm, everything's OK
    return TRUE;
}

//::///////////////////////////////////////////////
//:: Verify Melee Talent Use
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes sure that certain talents are not used
    on Elementals, Undead or Constructs

    - December 18 2002: Do not use smite evil on good people
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 23, 2002
//:://////////////////////////////////////////////
int VerifyCombatMeleeTalent(talent tUse, object oTarget)
{
    int nFeatID = GetIdFromTalent(tUse);
    if(nFeatID == FEAT_SAP ||
       nFeatID == FEAT_STUNNING_FIST)
    {
        int nRacial = GetRacialType(oTarget);
        if(nRacial == RACIAL_TYPE_CONSTRUCT ||
           nRacial == RACIAL_TYPE_UNDEAD ||
           nRacial == RACIAL_TYPE_ELEMENTAL ||
           nRacial == RACIAL_TYPE_VERMIN)
        {
            return FALSE;
        }
    } else if (nFeatID = FEAT_SMITE_EVIL) {
        int nAlign = GetAlignmentGoodEvil(oTarget);
        if (nAlign == ALIGNMENT_GOOD)
            return FALSE;
    } else if (nFeatID = FEAT_SMITE_GOOD) {
        int nAlign = GetAlignmentGoodEvil(oTarget);
        if (nAlign == ALIGNMENT_EVIL)
            return FALSE;
    }

    return TRUE;
}

//::///////////////////////////////////////////////
//:: Get Has Effect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the target has a given
    spell effect
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
int GetHasEffect(int nEffectType, object oTarget = OBJECT_SELF)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffectType)
        {
             return TRUE;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}


/* void main() {} /* */
