//::///////////////////////////////////////////////
//:: Add Itemproperty Spellscript
//:: x2_s2_addprop
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a rather generic spellscript which
    allows adding of any item property to an item
    it is used on.

    The possible target itemtypes are defined by
    the SpellId which fired the spell

    The property which is added to the item and
    its parameters (i.e. temporary or permanent)
    is read from a 2da. The row in the 2da is
    taken from the last 3 letters of the items
    tag.

    The 2da used is defined in x2_inc_itemprop
    X2_IP_ADDRPOP_2DA


    Note that not all item properties work with
    this system.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-11
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"



void main()
{
  object oItem   = GetSpellCastItem();
  object oUser   = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  string sTag    = GetTag(oItem);
  int nRow = -1;
  if ( GetObjectType(oTarget) != OBJECT_TYPE_ITEM || oTarget == OBJECT_INVALID)
  {
     FloatingTextStrRefOnCreature(83384,oUser);         //"Not an item
     return;
  }

  nRow = StringToInt(GetStringRight(sTag,3));

  if (nRow == 0) // row 0 = dummy row
  {
     FloatingTextStrRefOnCreature(83360,oUser);         //"Nothing happens
     WriteTimestampedLogEntry ("Error: Item with tag " +GetTag(oItem) + " has the AddItemProperty spellscript attached but tag does not contain 3 letter receipe code at the end!");
     return;
  }

  // load all necessary values from the 2da
  int nPropID = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"PropertyType",nRow));
  int nDuration = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"Duration",nRow));
  int nParam1 = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"Param1",nRow));
  int nParam2 = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"Param2",nRow));
  int nParam3 = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"Param3",nRow));
  int nParam4 = StringToInt(Get2DAString(X2_IP_ADDRPOP_2DA,"Param4",nRow));

  // read success text
  string sSuccess = Get2DAString(X2_IP_ADDRPOP_2DA,"SuccessText",nRow);

  int nStrRef = StringToInt(sSuccess);

  if (sSuccess == "")
  {
    nStrRef = 83386;
  }

  if (nStrRef != 0)  // Handle bioware StrRefs
  {
     sSuccess = GetStringByStrRef(nStrRef);
  }


  if (GetItemHasItemProperty(oTarget,nPropID))
  {
       FloatingTextStrRefOnCreature(83385,oUser);         //"Item already has property
       return;
  }

  itemproperty ip = IPGetItemPropertyByID(nPropID, nParam1, nParam2, nParam3, nParam4);

  float fDuration;
  int   nDurationType;
  if (nDuration == 0)
  {
    nDurationType = DURATION_TYPE_PERMANENT;
  }
  else
  {
    nDurationType = DURATION_TYPE_TEMPORARY;
    fDuration = IntToFloat(nDuration);
  }

  if ( GetIsItemPropertyValid(ip))
  {
      IPSafeAddItemProperty(oTarget, ip, fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,TRUE);
      if (GetItemHasItemProperty(oTarget,nPropID))
      {
         FloatingTextStringOnCreature(sSuccess,oUser);
         effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
         ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oUser);
      }
      else
      {
         FloatingTextStrRefOnCreature(83360,oUser);         //"Nothing happens"
         effect eFail = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
         ApplyEffectToObject(DURATION_TYPE_INSTANT,eFail,oUser);
      }
    }
    else
    {
        FloatingTextStrRefOnCreature(83360,oUser);         //"Nothing happens"
    }

}
