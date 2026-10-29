//::///////////////////////////////////////////////
//:: Dye Item Spellscript
//:: x2_s2_dyearmor
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spellscript for all Dye: Material Spells

    Some Notes:

    The color of the dye is taken from the
    last two letters of the item's tag

    The colortype which to change (cloth1, cloth2,
    leather1, ...) is determined by the spell ID

    Restrictions:
    - you cannot dye armor in combat
    - you can only dye armor && helmets
    - you can only dye items in your inventory
    - you can now dye cloaks as well

    - the IPWork container (see x2_inc_itemprop)
      must be set up for this to work properly

*/
//:://////////////////////////////////////////////
//:: Modified: Georg Zoeller, 24/03/2006 - Cloaks
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-10
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
const int DYE_MAX_COLOR_INDEX = 175;

// Maps the Spell ID to the appropriate ITEM_APPR_ARMOR_COLOR_* constant
int GetApprArmorColorFromSpellID(int nID)
{
    switch (nID)
    {
        case 648 : return ITEM_APPR_ARMOR_COLOR_CLOTH1;
        case 649 : return ITEM_APPR_ARMOR_COLOR_CLOTH2;
        case 650 : return ITEM_APPR_ARMOR_COLOR_LEATHER1;
        case 651 : return ITEM_APPR_ARMOR_COLOR_LEATHER2;
        case 652 : return ITEM_APPR_ARMOR_COLOR_METAL1;
        case 653 : return ITEM_APPR_ARMOR_COLOR_METAL2;
    }
    return 0;
}


void FinishDyeScript(object oPC, object oTarget, int bEquipped, int nSlot)
{
  // Move the armor back from the IP Container
  object oNew = CopyItem(oTarget, oPC);
  DestroyObject(oTarget);
  //----------------------------------------------------------------------------
  // We need to remove all temporary item properties here
  //----------------------------------------------------------------------------

  IPRemoveAllItemProperties(oNew,DURATION_TYPE_TEMPORARY);
  // Reequip armor if it was equipped before
  if (bEquipped)
  {
    AssignCommand(oPC,ClearAllActions(TRUE));
    AssignCommand(oPC,ActionEquipItem(oNew,nSlot));
  }
}

void main()
{

  // declare major variables
  object oItem   = GetSpellCastItem();                  // The "dye" item that cast the spell
  object oPC     = OBJECT_SELF;                         // the user of the item
  object oTarget = GetSpellTargetObject();
  string sTag    = GetStringLowerCase(GetTag(oItem));
  // Determine the color to edit from the spell ID
  int nColorType =  GetApprArmorColorFromSpellID(GetSpellId());

  if (GetIsInCombat(oPC)) // abort if in combat
  {
        FloatingTextStrRefOnCreature(83352,oPC);         //"This item cannot be used in combat"
        return;
  }

  if ( GetObjectType(oTarget) != OBJECT_TYPE_ITEM || oTarget == OBJECT_INVALID)
  {
    FloatingTextStrRefOnCreature(83353,oPC);         //"Invalid Target, must select armor or helmet"
    return;
  }

  int nBase = GetBaseItemType(oTarget);

  // GZ@2006/03/26: Added cloak support
  if (  nBase != BASE_ITEM_ARMOR  && nBase != BASE_ITEM_HELMET && nBase != BASE_ITEM_CLOAK  )
  {
    FloatingTextStrRefOnCreature(83353,oPC);    //"Invalid Target, must select armor or helmet"
    return;
  }

  if (GetItemPossessor(oTarget) != oPC)
  {
       FloatingTextStrRefOnCreature(83354,oPC);    //"target must be in inventory"
       return;
  }


  // save if the item was equipped before the process
  int bEquipped;
  int nSlot;
  if (nBase == BASE_ITEM_HELMET )
  {
      nSlot = INVENTORY_SLOT_HEAD;
      bEquipped = (GetItemInSlot(nSlot,oPC) == oTarget);
  }
  // GZ@2006/03/26: Added cloak support
  else if (nBase == BASE_ITEM_CLOAK )
  {
      nSlot = INVENTORY_SLOT_CLOAK;
      bEquipped = (GetItemInSlot(nSlot,oPC) == oTarget);
  }
  else
  {
      nSlot = INVENTORY_SLOT_CHEST;
      bEquipped = (GetItemInSlot(nSlot,oPC) == oTarget);

  }




  // GZ@2006/03/26: Added new color palette support. Note: Will only work
  //                if craig updates the in engine functions as well.
  int nColor     =  0;

  // See if we find a valid int between 0 and 127 in the last three letters
  // of the tag, use it as color
  int nTest      =  StringToInt(GetStringRight(GetTag(oItem),3));
  if (nTest > 0 && nTest <= DYE_MAX_COLOR_INDEX )
  {
        nColor = nTest;
  }
  else //otherwise, use last two letters, as per legacy HotU
  {

        nColor = StringToInt(GetStringRight(GetTag(oItem),2));
  }


  // move the item into the IP work container
  object oNew = CopyItem(oTarget, IPGetIPWorkContainer());


  DestroyObject(oTarget);

  // Dye the armor
  oTarget = IPDyeArmor(oNew,nColorType, nColor);

  DelayCommand(0.01f,FinishDyeScript(oPC,oTarget,bEquipped,nSlot));

}


