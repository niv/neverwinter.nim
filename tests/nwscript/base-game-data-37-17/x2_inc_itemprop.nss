//::///////////////////////////////////////////////
//:: Item Property Functions
//:: x2_inc_itemprop
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Holds item property and item modification
    specific code.

    If you look for anything specific to item
    properties, your chances are good to find it
    in here.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-05
//:: Last Update: 2003-10-07
//:://////////////////////////////////////////////

// *  The tag of the ip work container, a placeable which has to be set into each
// *  module that is using any of the crafting functions.
const string  X2_IP_WORK_CONTAINER_TAG = "x2_plc_ipbox";
// *  2da for the AddProperty ItemProperty
const string X2_IP_ADDRPOP_2DA = "des_crft_props" ;
// *  2da for the Poison Weapon Itemproperty
const string X2_IP_POISONWEAPON_2DA = "des_crft_poison" ;
// *  2da for armor appearance
const string X2_IP_ARMORPARTS_2DA = "des_crft_aparts" ;
// *  2da for armor appearance
const string X2_IP_ARMORAPPEARANCE_2DA = "des_crft_appear" ;

// * Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int    XP_IP_ITEMMODCONVERSATION_CTOKENBASE = 12220;
const int    X2_IP_ITEMMODCONVERSATION_MODE_TAILOR = 0;
const int    X2_IP_ITEMMODCONVERSATION_MODE_CRAFT = 1;

// * Number of maximum item properties allowed on most items
const int    X2_IP_MAX_ITEM_PROPERTIES = 8;

// *  Constants used with the armor modification system
const int    X2_IP_ARMORTYPE_NEXT = 0;
const int    X2_IP_ARMORTYPE_PREV = 1;
const int    X2_IP_ARMORTYPE_RANDOM = 2;
const int    X2_IP_WEAPONTYPE_NEXT = 0;
const int    X2_IP_WEAPONTYPE_PREV = 1;
const int    X2_IP_WEAPONTYPE_RANDOM = 2;

// *  Policy constants for IPSafeAddItemProperty()
const int    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING = 0;
const int    X2_IP_ADDPROP_POLICY_KEEP_EXISTING = 1;
const int    X2_IP_ADDPROP_POLICY_IGNORE_EXISTING =2;


// *  removes all itemproperties with matching nItemPropertyType and nItemPropertyDuration
void  IPRemoveMatchingItemProperties( object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY, int nItemPropertySubType = -1 );

// *  Removes ALL item properties from oItem matching nItemPropertyDuration
void  IPRemoveAllItemProperties( object oItem, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY );

// *  returns TRUE if item can be equipped.
// *  Uses Get2DAString, so do not use in a loop!
int   IPGetIsItemEquipable( object oItem );

// *  Changes the color of an item armor
// *  oItem        - The armor
// *  nColorType   - ITEM_APPR_ARMOR_COLOR_* constant
// *  nColor       - color from 0 to 63
// *  Since oItem is destroyed in the process, the function returns
// *  the item created with the color changed
object IPDyeArmor( object oItem, int nColorType, int nColor );

// *  Returns the container used for item property and appearance modifications in the
// *  module. If it does not exist, create it.
object IPGetIPWorkContainer( object oCaller = OBJECT_SELF );

// *  This function needs to be rather extensive and needs to be updated if there are new
// *  ip types we want to use, but it goes into the item property include anyway
itemproperty IPGetItemPropertyByID( int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0 );

// *  returns TRUE if oItem is a ranged weapon
int   IPGetIsRangedWeapon( object oItem );

// *  return TRUE if oItem is a melee weapon
int   IPGetIsMeleeWeapon( object oItem );

// *  return TRUE if oItem is a projectile (bolt, arrow, etc)
int   IPGetIsProjectile( object oItem );

// *  returns true if weapon is blugeoning (used for poison)
// *  This uses Get2DAstring, so it is slow. Avoid using in loops!
int   IPGetIsBludgeoningWeapon( object oItem );

// *  Return the IP_CONST_CASTSPELL_* ID matching to the SPELL_* constant given in nSPELL_ID
// *  This uses Get2DAstring, so it is slow. Avoid using in loops!
// *  returns -1 if there is no matching property for a spell
int   IPGetIPConstCastSpellFromSpellID( int nSpellID );

// *  Returns TRUE if an item has ITEM_PROPERTY_ON_HIT and the specified nSubType
// *  possible values for nSubType can be taken from IPRP_ONHIT.2da
// *  popular ones:
// *  5 - Daze   19 - ItemPoison   24 - Vorpal
int   IPGetItemHasItemOnHitPropertySubType( object oTarget, int nSubType );

// *  Returns the number of possible armor part variations for the specified part
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAstring, so do not use in loops
int   IPGetNumberOfAppearances( int nPart );


// *  Returns the next valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAstring, so do not use in loops
int   IPGetNextArmorAppearanceType(object oArmor, int nPart);

// *  Returns the previous valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAstring, so do not use in loops
int   IPGetPrevArmorAppearanceType(object oArmor, int nPart);

// *  Returns a random valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAstring, so do not use in loops
int   IPGetRandomArmorAppearanceType(object oArmor, int nPart);

// * Returns a new armor based of oArmor with nPartModified
// * nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// * nMode -
// *        X2_IP_ARMORTYPE_NEXT    - next valid appearance
// *        X2_IP_ARMORTYPE_PREV    - previous valid apperance;
// *        X2_IP_ARMORTYPE_RANDOM  - random valid appearance;
// *
// * bDestroyOldOnSuccess - Destroy oArmor in process?
// * Uses Get2DAstring, so do not use in loops
object IPGetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess);

// *  Add an item property in a safe fashion, preventing unwanted stacking
// *  Parameters:
// *   oItem     - the item to add the property to
// *   ip        - the itemproperty to add
// *   fDuration - set 0.0f to add the property permanent, anything else is temporary
// *   nAddItemPropertyPolicy - How to handle existing properties. Valid values are:
// *      X2_IP_ADDPROP_POLICY_REPLACE_EXISTING - remove any property of the same type, subtype, durationtype before adding;
// *      X2_IP_ADDPROP_POLICY_KEEP_EXISTING - do not add if any property with same type, subtype and durationtype already exists;
// *      X2_IP_ADDPROP_POLICY_IGNORE_EXISTING - add itemproperty in any case - Do not Use with OnHit or OnHitSpellCast props!
// *
// *  bIgnoreDurationType - If set to TRUE, an item property will be considered identical even if the DurationType is different. Be careful when using this
// *                        with X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, as this could lead to a temporary item property removing a permanent one
// *  bIgnoreSubType      - If set to TRUE an item property will be considered identical even if the SubType is different.
void  IPSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE);

// *  Wrapper for GetItemHasItemProperty that returns true if
// *  oItem has an itemproperty that matches ipCompareTo by Type AND DurationType AND SubType
// *  nDurationType = Valid DURATION_TYPE_* or -1 to ignore
// *  bIgnoreSubType - If set to TRUE an item property will be considered identical even if the SubType is different.
int   IPGetItemHasProperty(object oItem, itemproperty ipCompareTo, int nDurationType, int bIgnoreSubType = FALSE);

// *  returns FALSE it the item has no sequencer property
// *  returns number of spells that can be stored in any other case
int   IPGetItemSequencerProperty(object oItem);

// *  returns TRUE if the item has the OnHit:IntelligentWeapon property.
int   IPGetIsIntelligentWeapon(object oItem);

// *  Mapping between numbers and power constants for ITEM_PROPERTY_DAMAGE_BONUS
// *  returns the appropriate ITEM_PROPERTY_DAMAGE_POWER_* constant for nNumber
int   IPGetDamagePowerConstantFromNumber(int nNumber);

// *  returns the appropriate ITEM_PROPERTY_DAMAGE_BONUS_= constant for nNumber
// *  Do not pass in any number <1 ! Will return -1 on error
int   IPGetDamageBonusConstantFromNumber(int nNumber);

// *  Special Version of Copy Item Properties for use with greater wild shape
// *  oOld - Item equipped before polymorphing (source for item props)
// *  oNew - Item equipped after polymorphing  (target for item props)
// *  bWeapon - Must be set TRUE when oOld is a weapon.
void  IPWildShapeCopyItemProperties(object oOld, object oNew, int bWeapon = FALSE);

// *  Returns the current enhancement bonus of a weapon (+1 to +20), 0 if there is
// *  no enhancement bonus. You can test for a specific type of enhancement bonus
// *  by passing the appropritate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into
// *  nEnhancementBonusType
int   IPGetWeaponEnhancementBonus(object oWeapon, int nEnhancementBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS);

// *  Shortcut function to set the enhancement bonus of a weapon to a certain bonus
// *  Specifying bOnlyIfHigher as TRUE will prevent a bonus lower than the requested
// *  bonus from being applied. Valid values for nBonus are 1 to 20.
void  IPSetWeaponEnhancementBonus(object oWeapon, int nBonus, int bOnlyIfHigher = TRUE);

// *  Shortcut function to upgrade the enhancement bonus of a weapon by the
// *  number specified in nUpgradeBy. If the resulting new enhancement bonus
// *  would be out of bounds (>+20), it will be set to +20
void  IPUpgradeWeaponEnhancementBonus(object oWeapon, int nUpgradeBy);

// *  Returns TRUE if a character has any item equipped that has the itemproperty
// *  defined in nItemPropertyConst in it (ITEM_PROPERTY_* constant)
int   IPGetHasItemPropertyOnCharacter(object oPC, int nItemPropertyConst);

// *  Returns an integer with the number of properties present oItem
int   IPGetNumberOfItemProperties(object oItem);



//------------------------------------------------------------------------------
//                         I M P L E M E N T A T I O N
//------------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Removes all itemproperties with matching nItemPropertyType and
// nItemPropertyDuration (a DURATION_TYPE_* constant)
// ----------------------------------------------------------------------------
void IPRemoveMatchingItemProperties(object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY, int nItemPropertySubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    // valid ip?
    while (GetIsItemPropertyValid(ip))
    {
        // same property type?
        if ((GetItemPropertyType(ip) == nItemPropertyType))
        {
            // same duration or duration ignored?
            if (GetItemPropertyDurationType(ip) == nItemPropertyDuration || nItemPropertyDuration == -1)
            {
                 // same subtype or subtype ignored
                 if  (GetItemPropertySubType(ip) == nItemPropertySubType || nItemPropertySubType == -1)
                 {
                      // Put a warning into the logfile if someone tries to remove a permanent ip with a temporary one!
                      /*if (nItemPropertyDuration == DURATION_TYPE_TEMPORARY &&  GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
                      {
                         WriteTimestampedLogEntry("x2_inc_itemprop:: IPRemoveMatchingItemProperties() - WARNING: Permanent item property removed by temporary on "+GetTag(oItem));
                      }
                      */
                      RemoveItemProperty(oItem, ip);
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
}

// ----------------------------------------------------------------------------
// Removes ALL item properties from oItem matching nItemPropertyDuration
// ----------------------------------------------------------------------------
void IPRemoveAllItemProperties(object oItem, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == nItemPropertyDuration)
        {
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
}

// ----------------------------------------------------------------------------
// returns TRUE if item can be equipped. Uses Get2DAString, so do not use in a loop!
// ----------------------------------------------------------------------------
int IPGetIsItemEquipable(object oItem)
{
    int nBaseType =GetBaseItemType(oItem);

    // fix, if we get BASE_ITEM_INVALID (usually because oItem is invalid), we
    // need to make sure that this function returns FALSE
    if(nBaseType==BASE_ITEM_INVALID) return FALSE;

    string sResult = Get2DAString("baseitems","EquipableSlots",nBaseType);
    return  (sResult != "0x00000");
}

// ----------------------------------------------------------------------------
// Changes the color of an item armor
// oItem        - The armor
// nColorType   - ITEM_APPR_ARMOR_COLOR_* constant
// nColor       - color from 0 to 63
// Since oItem is destroyed in the process, the function returns
// the item created with the color changed
// ----------------------------------------------------------------------------
object IPDyeArmor(object oItem, int nColorType, int nColor)
{
        object oRet = CopyItemAndModify(oItem,ITEM_APPR_TYPE_ARMOR_COLOR,nColorType,nColor,TRUE);
        DestroyObject(oItem); // remove old item
        return oRet; //return new item
}

// ----------------------------------------------------------------------------
// Returns the container used for item property and appearance modifications in the
// module. If it does not exist, it is created
// ----------------------------------------------------------------------------
object IPGetIPWorkContainer(object oCaller = OBJECT_SELF)
{
    object oRet = GetObjectByTag(X2_IP_WORK_CONTAINER_TAG);
    if (oRet == OBJECT_INVALID)
    {
        oRet = CreateObject(OBJECT_TYPE_PLACEABLE,X2_IP_WORK_CONTAINER_TAG,GetLocation(oCaller));
        effect eInvis =  EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY);
        eInvis = ExtraordinaryEffect(eInvis);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oRet);
        if (oRet == OBJECT_INVALID)
        {
            WriteTimestampedLogEntry("x2_inc_itemprop - critical: Missing container with tag " +X2_IP_WORK_CONTAINER_TAG + "!!");
        }
    }


    return oRet;
}

// ----------------------------------------------------------------------------
// This function needs to be rather extensive and needs to be updated if there are new
// ip types we want to use, but it goes into the item property include anyway
// ----------------------------------------------------------------------------
itemproperty IPGetItemPropertyByID(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0)
{
   itemproperty ipRet;

   if (nPropID == ITEM_PROPERTY_ABILITY_BONUS)
   {
        ipRet = ItemPropertyAbilityBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS)
   {
        ipRet = ItemPropertyACBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)
   {
        ipRet = ItemPropertyACBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)
   {
        ipRet = ItemPropertyACBonusVsDmgType(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)
   {
        ipRet = ItemPropertyACBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)
   {
        ipRet = ItemPropertyACBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS)
   {
        ipRet = ItemPropertyAttackBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)
   {
        ipRet = ItemPropertyAttackBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
   {
        ipRet = ItemPropertyAttackBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
   {
        ipRet = ItemPropertyAttackBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION)
   {
        ipRet = ItemPropertyWeightReduction(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_FEAT)
   {
        ipRet = ItemPropertyBonusFeat(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
   {
        ipRet = ItemPropertyBonusLevelSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_CAST_SPELL)
   {
        ipRet = ItemPropertyCastSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS)
   {
        ipRet = ItemPropertyDamageBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
   {
        ipRet = ItemPropertyDamageBonusVsAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
   {
        ipRet = ItemPropertyDamageBonusVsRace(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
   {
        ipRet = ItemPropertyDamageBonusVsSAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_REDUCTION)
   {
        ipRet = ItemPropertyDamageReduction(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_RESISTANCE)
   {
        ipRet = ItemPropertyDamageResistance(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_VULNERABILITY)
   {
        ipRet = ItemPropertyDamageResistance(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DARKVISION)
   {
        ipRet = ItemPropertyDarkvision();
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ABILITY_SCORE)
   {
        ipRet = ItemPropertyDecreaseAbility(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_AC)
   {
        ipRet = ItemPropertyDecreaseAC(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
   {
        ipRet = ItemPropertyAttackPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)
   {
        ipRet = ItemPropertyEnhancementPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS)
   {
        ipRet = ItemPropertyReducedSavingThrow(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)
   {
        ipRet = ItemPropertyBonusSavingThrowVsX(nParam1, nParam2);
   }
    else if (nPropID == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)
   {
        ipRet = ItemPropertyDecreaseSkill(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT)
   {
        ipRet = ItemPropertyContainerReducedWeight(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS)
   {
        ipRet = ItemPropertyEnhancementBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)
   {
        ipRet = ItemPropertyEnhancementBonusVsAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)
   {
        ipRet = ItemPropertyEnhancementBonusVsSAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)
   {
        ipRet = ItemPropertyEnhancementBonusVsRace(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE)
   {
        ipRet = ItemPropertyExtraMeleeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE)
   {
        ipRet = ItemPropertyExtraRangeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_HASTE)
   {
        ipRet = ItemPropertyHaste();
   }
   else if (nPropID == ITEM_PROPERTY_KEEN)
   {
        ipRet = ItemPropertyKeen();
   }
   else if (nPropID == ITEM_PROPERTY_LIGHT)
   {
        ipRet = ItemPropertyLight(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_MASSIVE_CRITICALS)
   {
        ipRet = ItemPropertyMassiveCritical(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_NO_DAMAGE)
   {
        ipRet = ItemPropertyNoDamage();
   }
   else if (nPropID == ITEM_PROPERTY_ON_HIT_PROPERTIES)
   {
        ipRet = ItemPropertyOnHitProps(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_TRAP)
   {
        ipRet = ItemPropertyTrap(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_TRUE_SEEING)
   {
        ipRet = ItemPropertyTrueSeeing();
   }
   else if (nPropID == ITEM_PROPERTY_UNLIMITED_AMMUNITION)
   {
        ipRet = ItemPropertyUnlimitedAmmo(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ONHITCASTSPELL)
   {
        ipRet = ItemPropertyOnHitCastSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
   {
        ipRet = ItemPropertyArcaneSpellFailure(nParam1);
   }


   return ipRet;
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a projectile
// ----------------------------------------------------------------------------
int IPGetIsProjectile(object oItem)
{
  int nBT = GetBaseItemType(oItem);
  return (nBT == BASE_ITEM_ARROW || nBT == BASE_ITEM_BOLT || nBT == BASE_ITEM_BULLET);
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a ranged weapon
// ----------------------------------------------------------------------------
int IPGetIsRangedWeapon(object oItem)
{
    return GetWeaponRanged(oItem); // doh !
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a melee weapon
// ----------------------------------------------------------------------------
int IPGetIsMeleeWeapon(object oItem)
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
      (nItem == BASE_ITEM_MAGICSTAFF) ||
      (nItem == BASE_ITEM_RAPIER) ||
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == BASE_ITEM_SHORTSPEAR) ||
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_WARHAMMER)  ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_TRIDENT) )
   {
        return TRUE;
   }
   return FALSE;
}

// ----------------------------------------------------------------------------
// Returns TRUE if weapon is a blugeoning weapon
// Uses Get2DAString!
// ----------------------------------------------------------------------------
int IPGetIsBludgeoningWeapon(object oItem)
{
  int nBT = GetBaseItemType(oItem);
  int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType",nBT)));
  // 2 = bludgeoning
  return (nWeapon == 2);
}

// ----------------------------------------------------------------------------
// Return the IP_CONST_CASTSPELL_* ID matching to the SPELL_* constant given
// in nSPELL_ID.
// This uses Get2DAstring, so it is slow. Avoid using in loops!
// returns -1 if there is no matching property for a spell
// ----------------------------------------------------------------------------
int IPGetIPConstCastSpellFromSpellID(int nSpellID)
{
    // look up Spell Property Index
    string sTemp = Get2DAString("des_crft_spells","IPRP_SpellIndex",nSpellID);
    /*
    if (sTemp == "") // invalid nSpellID
    {
        PrintString("x2_inc_craft.nss::GetIPConstCastSpellFromSpellID called with invalid nSpellID" + IntToString(nSpellID));
        return -1;
    }
    */
    int nSpellPrpIdx = StringToInt(sTemp);
    return nSpellPrpIdx;
}
// ----------------------------------------------------------------------------
// Returns TRUE if an item has ITEM_PROPERTY_ON_HIT and the specified nSubType
// possible values for nSubType can be taken from IPRP_ONHIT.2da
// popular ones:
//       5 - Daze
//      19 - ItemPoison
//      24 - Vorpal
// ----------------------------------------------------------------------------
int IPGetItemHasItemOnHitPropertySubType(object oTarget, int nSubType)
{
    if (GetItemHasItemProperty(oTarget,ITEM_PROPERTY_ON_HIT_PROPERTIES))
    {
        itemproperty ipTest = GetFirstItemProperty(oTarget);

        // loop over item properties to see if there is already a poison effect
        while (GetIsItemPropertyValid(ipTest))
        {

            if (GetItemPropertySubType(ipTest) == nSubType)   //19 == onhit poison
            {
                return TRUE;
            }

          ipTest = GetNextItemProperty(oTarget);

         }
    }
    return FALSE;
}

// ----------------------------------------------------------------------------
// Returns the number of possible armor part variations for the specified part
// nPart - ITEM_APPR_ARMOR_MODEL_* constant
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetNumberOfArmorAppearances(int nPart)
{
    int nRet;
    //SpeakString(Get2DAString(X2_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    return nRet;
}

// ----------------------------------------------------------------------------
// (private)
// Returns the previous or next armor appearance type, depending on the specified
// mode (X2_IP_ARMORTYPE_NEXT || X2_IP_ARMORTYPE_PREV)
// ----------------------------------------------------------------------------
int IPGetArmorAppearanceType(object oArmor, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_ARMORTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_ARMORTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    int nRet;

    if (nPart ==ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        nRet = StringToInt(Get2DAString(X2_IP_ARMORAPPEARANCE_2DA ,sMode,nCurrApp));
        return nRet;
    }
    else
    {
        int nMax =  IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
        int nMin =  1; // this prevents part 0 from being chosen (naked)

        // return a random valid armor tpze
        if (nMode == X2_IP_ARMORTYPE_RANDOM)
        {
            return Random(nMax)+nMin;
        }

        else
        {
            if (nMode == X2_IP_ARMORTYPE_NEXT)
            {
                // current appearance is max, return min
                if (nCurrApp == nMax)
                {
                    return nMin;
                }
                // current appearance is min, return max  -1
                else if (nCurrApp == nMin)
                {
                    nRet = nMin+1;
                    return nRet;
                }

                //SpeakString("next");
                // next
                nRet = nCurrApp +1;
                return nRet;
            }
            else                // previous
            {
                // current appearance is max, return nMax-1
                if (nCurrApp == nMax)
                {
                    nRet = nMax--;
                    return nRet;
                }
                // current appearance is min, return max
                else if (nCurrApp == nMin)
                {
                    return nMax;
                }

                //SpeakString("prev");

                nRet = nCurrApp -1;
                return nRet;
            }
        }

     }

}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetNextArmorAppearanceType(object oArmor, int nPart)
{
    return IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_NEXT );

}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetPrevArmorAppearanceType(object oArmor, int nPart)
{
    return IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_PREV );
}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetRandomArmorAppearanceType(object oArmor, int nPart)
{
    return  IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_RANDOM );
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_ARMORTYPE_NEXT    - next valid appearance
//          X2_IP_ARMORTYPE_PREV    - previous valid apperance;
//          X2_IP_ARMORTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object IPGetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = IPGetArmorAppearanceType(oArmor, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));

    object oNew = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nNewApp,TRUE);

    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oArmor);
        }
        return oNew;
    }
    // Safety fallback, return old armor on failures
       return oArmor;
}

// ----------------------------------------------------------------------------
// Creates a special ring on oCreature that gives
// all weapon and armor proficiencies to the wearer
// Item is set non dropable
// ----------------------------------------------------------------------------
object IPCreateProficiencyFeatItemOnCreature(object oCreature)
{
    // create a simple golden ring
    object  oRing = CreateItemOnObject("nw_it_mring023",oCreature);

    // just in case
    SetDroppableFlag(oRing, FALSE);

    itemproperty ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_MEDIUM);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);

    return oRing;
}

// ----------------------------------------------------------------------------
// Add an item property in a safe fashion, preventing unwanted stacking
// Parameters:
//   oItem     - the item to add the property to
//   ip        - the itemproperty to add
//   fDuration - set 0.0f to add the property permanent, anything else is temporary
//   nAddItemPropertyPolicy - How to handle existing properties. Valid values are:
//     X2_IP_ADDPROP_POLICY_REPLACE_EXISTING - remove any property of the same type, subtype, durationtype before adding;
//     X2_IP_ADDPROP_POLICY_KEEP_EXISTING - do not add if any property with same type, subtype and durationtype already exists;
//     X2_IP_ADDPROP_POLICY_IGNORE_EXISTING - add itemproperty in any case - Do not Use with OnHit or OnHitSpellCast props!
//   bIgnoreDurationType  - If set to TRUE, an item property will be considered identical even if the DurationType is different. Be careful when using this
//                          with X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, as this could lead to a temporary item property removing a permanent one
//   bIgnoreSubType       - If set to TRUE an item property will be considered identical even if the SubType is different.
//
// * WARNING: This function is used all over the game. Touch it and break it and the wrath
//            of the gods will come down on you faster than you can saz "I didn't do it"
// ----------------------------------------------------------------------------
void IPSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE)
{
    int nType = GetItemPropertyType(ip);
    int nSubType = GetItemPropertySubType(ip);
    int nDuration;
    // if duration is 0.0f, make the item property permanent
    if (fDuration == 0.0f)
    {

        nDuration = DURATION_TYPE_PERMANENT;
    } else
    {

        nDuration = DURATION_TYPE_TEMPORARY;
    }

    int nDurationCompare = nDuration;
    if (bIgnoreDurationType)
    {
        nDurationCompare = -1;
    }

    if (nAddItemPropertyPolicy == X2_IP_ADDPROP_POLICY_REPLACE_EXISTING)
    {

        // remove any matching properties
        if (bIgnoreSubType)
        {
            nSubType = -1;
        }
        IPRemoveMatchingItemProperties(oItem, nType, nDurationCompare, nSubType );
    }
    else if (nAddItemPropertyPolicy == X2_IP_ADDPROP_POLICY_KEEP_EXISTING )
    {
         // do not replace existing properties
        if(IPGetItemHasProperty(oItem, ip, nDurationCompare, bIgnoreSubType))
        {
          return; // item already has property, return
        }
    }
    else //X2_IP_ADDPROP_POLICY_IGNORE_EXISTING
    {

    }

    if (nDuration == DURATION_TYPE_PERMANENT)
    {
        AddItemProperty(nDuration,ip, oItem);
    }
    else
    {
        AddItemProperty(nDuration,ip, oItem,fDuration);
    }
}

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
int IPGetItemHasProperty(object oItem, itemproperty ipCompareTo, int nDurationCompare, int bIgnoreSubType = FALSE)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    //PrintString ("Filter - T:" + IntToString(GetItemPropertyType(ipCompareTo))+ " S: " + IntToString(GetItemPropertySubType(ipCompareTo)) + " (Ignore: " + IntToString (bIgnoreSubType) + ") D:" + IntToString(nDurationCompare));
    while (GetIsItemPropertyValid(ip))
    {
        // PrintString ("Testing - T: " + IntToString(GetItemPropertyType(ip)));
        if ((GetItemPropertyType(ip) == GetItemPropertyType(ipCompareTo)))
        {
             //PrintString ("**Testing - S: " + IntToString(GetItemPropertySubType(ip)));
             if (GetItemPropertySubType(ip) == GetItemPropertySubType(ipCompareTo) || bIgnoreSubType)
             {
               // PrintString ("***Testing - d: " + IntToString(GetItemPropertyDurationType(ip)));
                if (GetItemPropertyDurationType(ip) == nDurationCompare || nDurationCompare == -1)
                {
                    //PrintString ("***FOUND");
                      return TRUE; // if duration is not ignored and durationtypes are equal, true
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    //PrintString ("Not Found");
    return FALSE;
}


object IPGetTargetedOrEquippedMeleeWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (IPGetIsMeleeWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  return OBJECT_INVALID;

}



object IPGetTargetedOrEquippedArmor(int bAllowShields = FALSE)
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (GetBaseItemType(oTarget) == BASE_ITEM_ARMOR)
    {
        return oTarget;
    }
    else
    {
        if ((bAllowShields) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
        {
            return oTarget;
        }
        else
        {
            return OBJECT_INVALID;
        }
    }

  }

  object oArmor1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
  if (GetIsObjectValid(oArmor1) && GetBaseItemType(oArmor1) == BASE_ITEM_ARMOR)
  {
    return oArmor1;
  }
  if (bAllowShields != FALSE)
  {
      oArmor1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      if (GetIsObjectValid(oArmor1) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
      {
        return oArmor1;
      }
    }



  return OBJECT_INVALID;

}

// ----------------------------------------------------------------------------
// Returns FALSE it the item has no sequencer property
// Returns number of spells that can be stored in any other case
// ----------------------------------------------------------------------------
int IPGetItemSequencerProperty(object oItem)
{
    if (!GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
    {
        return FALSE;
    }

    int nCnt;
    itemproperty ip;

    ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip) && nCnt ==0)
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
        {
            if(GetItemPropertySubType(ip) == 523) // sequencer 3
            {
                nCnt =  3;
            }
            else if(GetItemPropertySubType(ip) == 522) // sequencer 2
            {
                nCnt =  2;
            }
            else if(GetItemPropertySubType(ip) == 521) // sequencer 1
            {
                nCnt =  1;
            }
        }
        ip = GetNextItemProperty(oItem);
    }

    return nCnt;
}

void IPCopyItemProperties(object oSource, object oTarget, int bIgnoreCraftProps = TRUE)
{
    itemproperty ip = GetFirstItemProperty(oSource);
    int nSub;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            if (bIgnoreCraftProps)
            {
                if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
                {
                    nSub = GetItemPropertySubType(ip);
                    // filter crafting properties
                    if (nSub != 498 && nSub != 499 && nSub  != 526 && nSub != 527)
                    {
                        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                    }
                }
                else
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                }
            }
            else
            {
                AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
            }
        }
        ip = GetNextItemProperty(oSource);
    }
}

int IPGetIsIntelligentWeapon(object oItem)
{
    int bRet = FALSE ;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==  ITEM_PROPERTY_ONHITCASTSPELL)
        {
            if (GetItemPropertySubType(ip) == 135)
            {
                return TRUE;
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return bRet;
}

// ----------------------------------------------------------------------------
// (private)
// ----------------------------------------------------------------------------
int IPGetWeaponAppearanceType(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart);
    int nRet;

    int nMax =  9;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor tpze
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMax;
            }
            // current appearance is min, return max  -1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;
            return nRet;
        }
        else                // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax--;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMin;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;
            return nRet;
        }


     }
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_WEAPON_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_WEAPONTYPE_NEXT    - next valid appearance
//          X2_IP_WEAPONTYPE_PREV    - previous valid apperance;
//          X2_IP_WEAPONTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object IPGetModifiedWeapon(object oWeapon, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = IPGetWeaponAppearanceType(oWeapon, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));
    object oNew = CopyItemAndModify(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL, nPart, nNewApp,TRUE);
    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oWeapon);
        }
        return oNew;
    }
    // Safety fallback, return old weapon on failures
       return oWeapon;
}


object IPCreateAndModifyArmorRobe(object oArmor, int nRobeType)
{
    object oRet = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE,nRobeType+2,TRUE);
    if (GetIsObjectValid(oRet))
    {
        return oRet;
    }
    else // safety net
    {
        return oArmor;
    }
}

// ----------------------------------------------------------------------------
// Provide mapping between numbers and power constants for
// ITEM_PROPERTY_DAMAGE_BONUS
// ----------------------------------------------------------------------------
int IPGetDamagePowerConstantFromNumber(int nNumber)
{
    switch (nNumber)
    {
        case 0: return DAMAGE_POWER_NORMAL;
        case 1: return DAMAGE_POWER_PLUS_ONE;
        case 2: return  DAMAGE_POWER_PLUS_TWO;
        case 3: return DAMAGE_POWER_PLUS_THREE;
        case 4: return DAMAGE_POWER_PLUS_FOUR;
        case 5: return DAMAGE_POWER_PLUS_FIVE;
        case 6: return DAMAGE_POWER_PLUS_SIX;
        case 7: return DAMAGE_POWER_PLUS_SEVEN;
        case 8: return DAMAGE_POWER_PLUS_EIGHT;
        case 9: return DAMAGE_POWER_PLUS_NINE;
        case 10: return DAMAGE_POWER_PLUS_TEN;
        case 11: return DAMAGE_POWER_PLUS_ELEVEN;
        case 12: return DAMAGE_POWER_PLUS_TWELVE;
        case 13: return DAMAGE_POWER_PLUS_THIRTEEN;
        case 14: return DAMAGE_POWER_PLUS_FOURTEEN;
        case 15: return DAMAGE_POWER_PLUS_FIFTEEN;
        case 16: return DAMAGE_POWER_PLUS_SIXTEEN;
        case 17: return DAMAGE_POWER_PLUS_SEVENTEEN;
        case 18: return DAMAGE_POWER_PLUS_EIGHTEEN  ;
        case 19: return DAMAGE_POWER_PLUS_NINTEEN;
        case 20: return DAMAGE_POWER_PLUS_TWENTY;
    }

    if (nNumber>20)
    {
        return DAMAGE_POWER_PLUS_TWENTY;
    }
        else
    {
        return DAMAGE_POWER_NORMAL;
    }
}

// ----------------------------------------------------------------------------
// Provide mapping between numbers and bonus constants for ITEM_PROPERTY_DAMAGE_BONUS
// Note that nNumber should be > 0!
// ----------------------------------------------------------------------------
int IPGetDamageBonusConstantFromNumber(int nNumber)
{
    switch (nNumber)
    {
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11:  return DAMAGE_BONUS_11;
        case 12:  return DAMAGE_BONUS_12;
        case 13:  return DAMAGE_BONUS_13;
        case 14:  return DAMAGE_BONUS_14;
        case 15:  return DAMAGE_BONUS_15;
        case 16:  return DAMAGE_BONUS_16;
        case 17:  return DAMAGE_BONUS_17;
        case 18:  return DAMAGE_BONUS_18;
        case 19:  return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;

    }

    if (nNumber>20)
    {
        return DAMAGE_BONUS_20;
    }
        else
    {
        return -1;
    }
}

// ----------------------------------------------------------------------------
// GZ, Sept. 30 2003
// Special Version of Copy Item Properties for use with greater wild shape
// oOld - Item equipped before polymorphing (source for item props)
// oNew - Item equipped after polymorphing  (target for item props)
// bWeapon - Must be set TRUE when oOld is a weapon.
// ----------------------------------------------------------------------------
void IPWildShapeCopyItemProperties(object oOld, object oNew, int bWeapon = FALSE)
{
    if (GetIsObjectValid(oOld) && GetIsObjectValid(oNew))
    {
        itemproperty ip = GetFirstItemProperty(oOld);
        while (GetIsItemPropertyValid(ip))
        {
            if (bWeapon)
            {
                if (GetWeaponRanged(oOld) == GetWeaponRanged(oNew)   )
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
                }
            }
            else
            {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
            }
            ip = GetNextItemProperty(oOld);

        }
    }
}

// ----------------------------------------------------------------------------
// Returns the current enhancement bonus of a weapon (+1 to +20), 0 if there is
// no enhancement bonus. You can test for a specific type of enhancement bonus
// by passing the appropritate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into
// nEnhancementBonusType
// ----------------------------------------------------------------------------
int IPGetWeaponEnhancementBonus(object oWeapon, int nEnhancementBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    while (nFound == 0 && GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==nEnhancementBonusType)
        {
            nFound = GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound;
}

// ----------------------------------------------------------------------------
// Shortcut function to set the enhancement bonus of a weapon to a certain bonus
// Specifying bOnlyIfHigher as TRUE will prevent a bonus lower than the requested
// bonus from being applied. Valid values for nBonus are 1 to 20.
// ----------------------------------------------------------------------------
void IPSetWeaponEnhancementBonus(object oWeapon, int nBonus, int bOnlyIfHigher = TRUE)
{
    int nCurrent = IPGetWeaponEnhancementBonus(oWeapon);

    itemproperty ip = GetFirstItemProperty(oWeapon);

    if (bOnlyIfHigher && nCurrent > nBonus)
    {
        return;
    }

    if (nBonus <1 || nBonus > 20)
    {
        return;
    }

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nBonus);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);
}


// ----------------------------------------------------------------------------
// Shortcut function to upgrade the enhancement bonus of a weapon by the
// number specified in nUpgradeBy. If the resulting new enhancement bonus
// would be out of bounds (>+20), it will be set to +20
// ----------------------------------------------------------------------------
void IPUpgradeWeaponEnhancementBonus(object oWeapon, int nUpgradeBy)
{
    int nCurrent = IPGetWeaponEnhancementBonus(oWeapon);

    itemproperty ip = GetFirstItemProperty(oWeapon);

    int nNew = nCurrent + nUpgradeBy;
    if (nNew <1 )
    {
        nNew = 1;
    }
    else if (nNew >20)
    {
       nNew = 20;
    }

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nNew);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);

}

int IPGetHasItemPropertyByConst(int nItemProp, object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==nItemProp)
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}

// ----------------------------------------------------------------------------
// Returns TRUE if a use limitation of any kind is present on oItem
// ----------------------------------------------------------------------------
int IPGetHasUseLimitation(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nType;
    while (GetIsItemPropertyValid(ip))
    {
        nType = GetItemPropertyType(ip);
        if (
           nType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
           nType == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
           nType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
           nType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT  )
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}

//------------------------------------------------------------------------------
// GZ, Oct 2003
// Returns TRUE if a character has any item equipped that has the itemproperty
// defined in nItemPropertyConst in it (ITEM_PROPERTY_* constant)
//------------------------------------------------------------------------------
int IPGetHasItemPropertyOnCharacter(object oPC, int nItemPropertyConst)
{
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oLeftHand  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    int bHas =  IPGetHasItemPropertyByConst(nItemPropertyConst, oWeaponOld);
     bHas = bHas ||  IPGetHasItemPropertyByConst(nItemPropertyConst, oLeftHand);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oArmorOld);
    if (bHas)
        return TRUE;
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oRing1Old);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oRing2Old);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oAmuletOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oCloakOld);
    if (bHas)
        return TRUE;
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oBootsOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oBeltOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oHelmetOld);

    return bHas;

}

//------------------------------------------------------------------------------
// GZ, Oct 24, 2003
// Returns an integer with the number of properties present oItem
//------------------------------------------------------------------------------
int IPGetNumberOfItemProperties(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nCount = 0;
    while (GetIsItemPropertyValid(ip))
    {
        nCount++;
        ip = GetNextItemProperty(oItem);
    }
    return nCount;
}
