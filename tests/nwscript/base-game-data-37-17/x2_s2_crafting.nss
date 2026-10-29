//::///////////////////////////////////////////////
//:: Item Crafting Tool Scripts
//:: x2_s2_crafting
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This code runs when the PC uses the Craft
    Weapon or Craft Armor tools

    baseitems.2da - 109 = CraftWeapon = BASE_ITEM_CRAFTMED
    baseitems.2da - 110 = CraftWeapon = BASE_ITEM_CRAFTSMALL
    skills.2da - 25 = Craft Armor = SKILL_CRAFT_ARMOR
    skills.2da - 26 = Craft Weapon = SKILL_CRAFT_WEAPON

    You can limit the number of times a player can craft
    by putting a usage limit on the crafting item
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-12
//:: LastUpdate: 2003-07-14
//:://////////////////////////////////////////////



#include "x2_inc_craft"






void main()
{

  // declare major variables
  object oItem      = GetSpellCastItem();
  object oPC        = OBJECT_SELF;
  object oTarget    = GetSpellTargetObject();
  object oMajor;
  object oMinor;
  int nMode;

  string sTag       = GetStringLowerCase(GetTag(oTarget));
  int    nSpellID   = GetSpellId();

  //SpawnScriptDebugger();

  // Check if item was fired on itself
  if (!GetIsObjectValid(oTarget))
  {
      return;
  }

  // capture the craft component spells
  if (oTarget == OBJECT_SELF)
  {
    oTarget = oItem;
  }
  if ( GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
    return;  // should never happen due to targeting restrictions
  }

  //----------------------------------------------------------------------------
  // GZ: Fix for being able to use wrong items on each other
  //----------------------------------------------------------------------------
  if (GetBaseItemType(oItem) == 110 ) // small
  {
        if (GetBaseItemType(oTarget) != 109)  // large
        {
            FloatingTextStrRefOnCreature(84201,oPC);
            return;
        }
  }


  if (GetIsInCombat(oPC))
  {
        FloatingTextStrRefOnCreature(83352,oPC);    //"not in combat"
        return;
  }


  string s2DA;
  int nSkill;
  if (nSpellID == 656 || nSpellID == 742 ) // craft weapon
  {
        nSkill = 26;
        s2DA = X2_CI_CRAFTING_WP_2DA;
  }
  else if (nSpellID == 657 || nSpellID == 743 ) // craft weapon
  {
        nSkill = 25;
        s2DA = X2_CI_CRAFTING_AR_2DA;
  }


  int nMatRow;
  struct craft_receipe_struct stStruct =   CIGetCraftingModeFromTarget(oPC, oTarget, oItem);

  nMode = stStruct.nMode;

  if (nMode == X2_CI_CRAFTMODE_BASE_ITEM)
  {
      oMajor = stStruct.oMajor;
      nMatRow = CIGetCraftingReceipeRow(nMode, oMajor, OBJECT_INVALID, nSkill);
  }
  else if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE)
  {
      oMajor = stStruct.oMajor;
      oMinor = stStruct.oMinor;
      nMatRow = CIGetCraftingReceipeRow(nMode, oMajor, oMinor, nSkill);
  }
  else
  {
      return;
  }

  string sItem;
  int bBreak = FALSE;
  int nCount;
  int nNumber = 0;
  struct craft_struct stItem;



  // loop over the 2da (ouch!) to get all available crafting choises for an item.
  // even if it is a loop its a small one so maybe I won't end up in hell for doing this
  for (nCount = 0; (nCount < X2_CI_CRAFTING_ITEMS_PER_ROW) && (!bBreak); nCount++ )
  {
    stItem  =  CIGetCraftItemStructFrom2DA(s2DA,nMatRow,nCount);
    if (stItem.sLabel != "")
    {
        SetCustomToken(X2_CI_CRAFTINGSKILL_CTOKENBASE+nCount,stItem.sLabel);
        SetCustomToken(X2_CI_CRAFTINGSKILL_DC_CTOKENBASE+nCount,IntToString(stItem.nDC));
        SetCustomToken(X2_CI_CRAFTINGSKILL_GP_CTOKENBASE+nCount,IntToString(stItem.nCost));
        nNumber++;
     }
     else
     {
        bBreak = TRUE;
     }
  }


  // set conditions for the conversation
  CISetupCraftingConversation(oPC, nNumber, nSkill, nMatRow, oMajor, oMinor,nMode);

  // clear actions
  AssignCommand(oPC,ClearAllActions());
  // Fire up the crafting conversation
  AssignCommand(oPC, ActionStartConversation(oPC,X2_CI_CRAFTSKILL_CONV ,TRUE,FALSE));
}
