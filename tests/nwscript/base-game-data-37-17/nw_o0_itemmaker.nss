//::///////////////////////////////////////////////
//:: Smith Script
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 General Magic Item + Reagent smith
 system.
 Uses CustomToken #777
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 17, 2001
//:://////////////////////////////////////////////


#include "nw_i0_plot"

// * Array Functions

void SetLocalArrayString(object oidObject, string sVarName, int nVarNum, string nValue);
string GetLocalArrayString(object oidObject, string sVarName, int nVarNum);
void SetLocalArrayInt(object oidObject, string sVarName, int nVarNum, int nValue);
int GetLocalArrayInt(object oidObject, string sVarName, int nVarNum);

// * Lab Functions
void dbSpeak(string s)
{
    //SpeakString(s);
}
void CreateForgeItem();


 /*

     RULES
     -----

     Only one type of basetype can create one type of item
     EXCEPTION:
       armor can make multiple items (but only one type per Armor Class!!!!!)
       NOTE: this makes making armor a little annoying.

     - Reagents must be of one of the MISC type or GEM categories
     - The Misc categorie cannot be used for the basetypes


     THE LOCALS
     ----------
     M3Q1_VALIDITEM - Store Last valid item that could be made
     M3Q1_VALIDITEMCOST - Store last item cost

     THE ARRAYS
     -----------

     NW_COMBO_BASETYPE = magical basetype required
     NW_COMBO_REAGENT_1  = nth positions is the nth combination Reagent #3
     NW_COMBO_REWARD = nth position is the nth combination reward
     NW_COMBO_REWARD_COST = the additional cost of making this item (paid to Smith)
     NW_COMBO_AC = If item is armor the armor value of the item required is needed
     For example, index 1 of the above would be the first valid combination

  */



    /*
      COMBOs
    */


//::///////////////////////////////////////////////
//:: Returns number of possible combos
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int nNumberOfCombos()
{
    return GetLocalInt(OBJECT_SELF,"NW_L_COMBOS");
}

//::///////////////////////////////////////////////
//:: PlaySuccessVisual
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Put whatever you want to happen in addition
   to the item being made in here.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
void PlaySuccessVisual(object oVisual)
{
  effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oVisual);
}


//::///////////////////////////////////////////////
//:: IsMisc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if the basetype of the item
   is one of the Misc. types of basetype
*/
//:://////////////////////////////////////////////
//:: Created By:      Brent
//:: Created On:      November 2001
//:://////////////////////////////////////////////

int IsMisc(object oItem)
{
    int nBaseType = GetBaseItemType(oItem);
    if  (
        (nBaseType == BASE_ITEM_GEM)    ||
        (nBaseType == BASE_ITEM_MISCLARGE) ||  (nBaseType == BASE_ITEM_MISCMEDIUM) ||
        (nBaseType == BASE_ITEM_MISCTALL) ||  (nBaseType == BASE_ITEM_MISCSMALL)  ||  (nBaseType == BASE_ITEM_MISCTHIN)
        )
    {
    return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetItemPosition
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns the index into the array
     for the matching BASEITEM type
     If no match is found, returns -1
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetItemPosition(object oMagicalItem)
{
  int i;
  int nMatch = -1;


  
  for (i = 1; i <= nNumberOfCombos(); i++)
  {
    if (GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE", i) == GetBaseItemType(oMagicalItem))
    {
        // * if item is armor than the armor class needs to match as well
        if ((GetBaseItemType(oMagicalItem) != BASE_ITEM_ARMOR) ||
        (
        (GetBaseItemType(oMagicalItem) == BASE_ITEM_ARMOR) &&
        (GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_AC", i) == GetItemACValue(oMagicalItem)))
        )
        {
            nMatch = i;
        }
    }
  }
  return nMatch;
}


//::///////////////////////////////////////////////
//:: GetIsMagical
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns True if item has 'magical' properties
    
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int GetIsMagical(object oItem)
{
    return   ( (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS) == TRUE)    ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP) == TRUE) ||
              (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT) == TRUE) ||
             (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS) == TRUE ));
}
//::///////////////////////////////////////////////
//:: IsValidBaseItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  Checks to see if the baseitem type matches
    the one in the array AND if the item
    is "magical"

  NOTE: must also check for the uniqueness of armor
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: November 2001
//:://////////////////////////////////////////////
int IsValidBaseItem(object oItem, int nIndex)
{
    //dbSpeak("BASE IN ARRAY: " + IntToString(GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE", nIndex)));
    //dbSpeak("Base Type : " + IntToString(GetBaseItemType(oItem)));
    if (
       (GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE", nIndex) == GetBaseItemType(oItem))
       && (GetIsMagical(oItem) == TRUE)

       )
    {
        // with armor I need to check
        // to see if the armor class matches as well >=
        if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            if (GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_AC", nIndex) == GetItemACValue(oItem))
            {
                return TRUE;
            }
            else
            {
                return FALSE;
            }
        }
        else
        return TRUE;
    }
    return FALSE;
}

void SetValidItem(int nPos)
{
   SetLocalString(OBJECT_SELF, "M3Q1_VALIDITEM",GetLocalArrayString(OBJECT_SELF,"NW_COMBO_REWARD",nPos));
}
void    SetValidItemCost(int nPos)
{
   SetLocalInt(OBJECT_SELF, "M3Q1_VALIDITEMCOST",GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_REWARD_GOLD",nPos));
}
void  SetValidItemCostToken(int nPos)
{
   SetCustomToken(777, IntToString(GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_REWARD_GOLD",nPos)));
}

string GetValidItem()
{
   return GetLocalString(OBJECT_SELF, "M3Q1_VALIDITEM");
}
int GetValidItemCost()
{
   return GetLocalInt(OBJECT_SELF, "M3Q1_VALIDITEMCOST");
}
//::///////////////////////////////////////////////
//:: CanAfford
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns True if the player can afford the item
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CanAfford(object oBuyer)
{
    return HasGold(GetValidItemCost(), oBuyer);
}


//::///////////////////////////////////////////////
//:: GetForgeMatch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Checks to see if the nPos item matches the current
   reward
   USE: For the conversation scripts that tell you
   *which* item can succesfully be made from the forge
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int GetForgeMatch(int nPos)
{
    return GetValidItem() == GetLocalArrayString(OBJECT_SELF,"NW_COMBO_REWARD",nPos);
}




//::///////////////////////////////////////////////
//:: HasAnyItemOfBaseType
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
      Returns true if the basetype (and if basetype
      is armor, the AC) matches.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int HasAnyItemOfBaseType(int nBaseType, int nAC,object oPC)
{
    // * needs to cycle through all inventory items
    // * and compare basetype with AC
    // * will ignore equipped items -- I think
    object oItem =  GetFirstItemInInventory(oPC);
    int bReturnValue = FALSE;
    int bValid = GetIsObjectValid(oItem);

    while (bValid == TRUE)
    {
        // * A base type match!
       if ((GetBaseItemType(oItem) == nBaseType) && (GetIsMagical(oItem)))
       {
          //dbSpeak("318: here");
          if (nBaseType == BASE_ITEM_ARMOR)
          {
            // * does AC match?
            if (nAC == GetItemACValue(oItem))
            {
                bReturnValue = TRUE;
            }
          }
          else
          {
            bReturnValue = TRUE;
          }
       }
           oItem =  GetNextItemInInventory(oPC);
           bValid = GetIsObjectValid(oItem);
    }
    return bReturnValue;
}
//::///////////////////////////////////////////////
//:: GetBackpackMatch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if Combo nPos can be made.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int GetBackpackMatch(int nPos, object oPC)
{
    string sReagentTag =  GetLocalArrayString(OBJECT_SELF,"NW_COMBO_REAGENT_1",nPos);
    // * does pc carry a valid reagent for this combination
    if (GetIsObjectValid(GetItemPossessedBy(oPC, sReagentTag)) == TRUE)
    {
    dbSpeak("backpack Reagent Tag Was valid = " + sReagentTag);
        // * there is a matching basetype
        int nArmorValue = GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_AC",nPos);
        int nBaseType =   GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE",nPos);
        dbSpeak("360 Made it here");
        dbSpeak("345 AC Value " + IntToString(nArmorValue));
        dbSpeak("Base " + IntToString(nBaseType));
        if (HasAnyItemOfBaseType(nBaseType, nArmorValue, oPC) == TRUE)
        {
            dbSpeak("Had backpackMatch");
            return TRUE;
        }
    }
   dbSpeak("Did not have backpack match");
   return FALSE;
}
//::///////////////////////////////////////////////
//:: GetCombo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns -1 if an invalid combination otherwise
    returns the index into the array

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int GetIsValidCombination(int bDeleteItem, object oContainer=OBJECT_INVALID)
{
    string sReagent1, sReagent2;
    // * if not container specified then assume the
    // * forge
    if (GetIsObjectValid(oContainer) == FALSE)
    {
        oContainer = GetObjectByTag(GetLocalString(OBJECT_SELF,"NW_L_MYFORGE"));
    }

    object oItem =  GetFirstItemInInventory(oContainer);
    int bValid = GetIsObjectValid(oItem);
    int i = 0;
    int nArrayPosition = -1;
    object oDeleteItem1, oDeleteItem2;

    while (bValid == TRUE)
    {
       i = i + 1;
       if (i == 1)
       {
        sReagent1 = GetTag(oItem);
        oDeleteItem1 = oItem;
       }
       if (i == 2)
       {
        sReagent2 = GetTag(oItem);
        oDeleteItem2 = oItem;
       }
       oItem =  GetNextItemInInventory(oContainer);
       bValid = GetIsObjectValid(oItem);
       if (i > 2)
         bValid = FALSE;

    }

     object oMagicalItem = OBJECT_INVALID;
     object oReagent = OBJECT_INVALID;


     if (IsMisc(oDeleteItem1) == TRUE)
     {
        // * assume other item must be 'magical item'
        oMagicalItem = oDeleteItem2;
        oReagent = oDeleteItem1;
     }
     else
     {
        // * assume first item is the magical item
        oMagicalItem = oDeleteItem1;
        oReagent = oDeleteItem2;
     }

        dbSpeak("reagent " + GetTag(oReagent));
        dbSpeak("magicitem " + GetTag(oMagicalItem));

    // * not enough or too many items
    if ( (i <=0) || (i >= 3) )
    {
        nArrayPosition = -1;
    }
    else
    {
        nArrayPosition = GetItemPosition(oMagicalItem);
       // dbSpeak("armor value : " + IntToString(GetItemACValue(oMagicalItem)));

       // dbSpeak("224 : " + IntToString(nArrayPosition));
        if (nArrayPosition != -1)
        {
            string sArrayReagent1 = GetLocalArrayString(OBJECT_SELF,"NW_COMBO_REAGENT_1", nArrayPosition);
           dbSpeak("Array Reagent1 = " + sArrayReagent1);

            // * Is one of the items the proper BaseItemType
            // * Is one of the items the proper reagent
            if ( (sArrayReagent1 == GetTag(oReagent)) && (IsValidBaseItem(oMagicalItem, nArrayPosition)) )
            {
               // * set the VALIDITEM local
               SetValidItem(nArrayPosition);
               SetValidItemCost(nArrayPosition);
               SetValidItemCostToken(nArrayPosition);


               if (bDeleteItem == TRUE)
               {
                // * blanks out the reward
                    SetLocalArrayString(OBJECT_SELF,"NW_COMBO_REWARD",nArrayPosition,"");
                    // * clear the basetype as well
                    SetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE",nArrayPosition,BASE_ITEM_INVALID);
                    //dbSpeak("AFTER DELETE BASE IN ARRAY: " + IntToString(GetLocalArrayInt(OBJECT_SELF,"NW_COMBO_BASETYPE", nArrayPosition)));
                    // * found a match
                    DestroyObject(oDeleteItem1);
                    DestroyObject(oDeleteItem2);
               }
               return TRUE;
            }
            else
            {
                nArrayPosition = -1;
                dbSpeak("DEBUG: Reagent + Basetype not a match");
            }
        }
    }


    // * if there is a valid item then return true
    if (nArrayPosition != -1)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

//::///////////////////////////////////////////////
//:: CreateForgeItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Called by the OnSpelLCast Event of a container
   and will create the item or cause a bad effect
*/
//:://////////////////////////////////////////////
//:: Created By:    Brent
//:: Created On:    November 2001
//:://////////////////////////////////////////////


void CreateForgeItem()
{
    object oContainer = GetObjectByTag(GetLocalString(OBJECT_SELF,"NW_L_MYFORGE"));
    if (GetIsValidCombination(TRUE) == TRUE)
    {   dbSpeak("starting to make it");
        CreateItemOnObject(GetValidItem(), oContainer);
        TakeGold(GetValidItemCost(), GetPCSpeaker());
        // * Item made, clear valid item string
        SetLocalString(OBJECT_SELF, "M3Q1_VALIDITEM","");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION),oContainer);
        PlaySuccessVisual(OBJECT_SELF);
    }
    else
      dbSpeak("Something happened, cannot make item");
}




/*
 *
 * Noel's Array stuff
 *
 *
*/

//::///////////////////////////////////////////////
//:: GetLocalArrayInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns an integer, from nVarNum in the array
*/
//:://////////////////////////////////////////////
//:: Created By: Noel
//:: Created On:
//:://////////////////////////////////////////////

    string GetLocalArrayString(object oidObject, string sVarName, int nVarNum)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        return GetLocalString(oidObject, sFullVarName);
    }

//::///////////////////////////////////////////////
//:: SetLocalArrayInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the integer at nVarNum position
*/
//:://////////////////////////////////////////////
//:: Created By: Noel
//:: Created On:
//:://////////////////////////////////////////////

    void SetLocalArrayString(object oidObject, string sVarName, int nVarNum, string nValue)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        SetLocalString(oidObject, sFullVarName, nValue);
    }


//::///////////////////////////////////////////////
//:: GetLocalArrayInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns an integer, from nVarNum in the array
*/
//:://////////////////////////////////////////////
//:: Created By: Noel
//:: Created On:
//:://////////////////////////////////////////////

    int GetLocalArrayInt(object oidObject, string sVarName, int nVarNum)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        return GetLocalInt(oidObject, sFullVarName);
    }

//::///////////////////////////////////////////////
//:: SetLocalArrayInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the integer at nVarNum position
*/
//:://////////////////////////////////////////////
//:: Created By: Noel
//:: Created On:
//:://////////////////////////////////////////////

    void SetLocalArrayInt(object oidObject, string sVarName, int nVarNum, int nValue)
    {
        string sFullVarName = sVarName + IntToString(nVarNum) ;
        SetLocalInt(oidObject, sFullVarName, nValue);
    }

