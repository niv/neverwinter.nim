//::///////////////////////////////////////////////
//:: Poison Weapon spellscript
//:: x2_s2_poisonwp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell allows to add temporary poison properties
    to a melee weapon or stack of arrows

    The exact details of the poison are loaded from
    a 2da defined in x2_inc_itemprop X2_IP_POSIONWEAPON_2DA
    taken from the row that matches the last three letters
    of GetTag(GetSpellCastItem())

    Example: if an item is given the poison weapon property
             and its tag ending on 004, the 4th row of the
             2da will be used (1d2IntDmg DC14 18 seconds)

             Rows 0 to 99 are bioware reserved

    Non Assassins have a chance of poisoning themselves
    when handling an item with this spell

    Restrictions
    ... only weapons and ammo can be poisoned
    ... restricted to piercing / slashing  damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-11
//:: Updated On: 2003-08-21
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
#include "X2_inc_switches"

void main()
{

  object oItem   = GetSpellCastItem();
  object oPC     = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  string sTag    = GetTag(oItem);

  if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }
  int nType = GetBaseItemType(oTarget);
  if (!IPGetIsMeleeWeapon(oTarget) &&
      !IPGetIsProjectile(oTarget)   &&
       nType != BASE_ITEM_SHURIKEN &&
       nType != BASE_ITEM_DART &&
       nType != BASE_ITEM_THROWINGAXE)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }

  if (IPGetIsBludgeoningWeapon(oTarget))
  {
       FloatingTextStrRefOnCreature(83367,oPC);         //"Weapon does not do slashing or piercing damage "
       return;
  }

  if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
  {
        FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
        return;
  }

  // Get the 2da row to lookup the poison from the last three letters of the tag
  int nRow = StringToInt(GetStringRight(sTag,3));

  if (nRow ==0)
  {
     FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
     WriteTimestampedLogEntry ("Error: Item with tag " +GetTag(oItem) + " has the PoisonWeapon spellscript attached but tag does not contain 3 letter receipe code at the end!");
     return;
  }

   int nSaveDC     =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"SaveDC",nRow));
   int nDuration   =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"Duration",nRow));
   int nPoisonType =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"PoisonType",nRow)) ;
   int nApplyDC    =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"ApplyCheckDC",nRow)) ;

   int bHasFeat = GetHasFeat(960, oPC);
   if (!bHasFeat) // without handle poison feat, do ability check
   {
       // * Force attacks of opportunity
       AssignCommand(oPC,ClearAllActions(TRUE));


       // Poison restricted to assassins and blackguards only?
       if (GetModuleSwitchValue(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT) == TRUE)
       {
            FloatingTextStrRefOnCreature(84420,oPC);               //"Failed"
            return;
       }

       int nDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC) ;
       int nCheck = d10(1)+10+nDex;
       if (nCheck < nApplyDC)
       {
           FloatingTextStrRefOnCreature(83368,oPC);               //"Failed"
           return;
       }
       else
       {
          FloatingTextStrRefOnCreature(83370,oPC);               //"Success"
       }
   }
   else
   {
       // some feedback to
       FloatingTextStrRefOnCreature(83369,oPC);         //"Auto success "
    }

    itemproperty ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON,nSaveDC,nPoisonType);
   IPSafeAddItemProperty(oTarget, ip,IntToFloat(nDuration),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
   //technically this is not 100% safe but since there is no way to retrieve the sub
   //properties of an item (i.e. itempoison), there is nothing we can do about it
   if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19))
   {
       FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
       IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID),IntToFloat(nDuration),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
   }
   else
   {
       FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
   }

}
