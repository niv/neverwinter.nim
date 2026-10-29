//::///////////////////////////////////////////////
//:: OnHit: Ruin Armor (Bebilith Ability)
//:: x2_s3_ruinarmor
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A bebilith claw can catch and tear an opponent's
    armor. If there is both armor and shield,
    it is randomly determined which item removed

    By default, the armor and shield just get
    unequipped, however by setting
    MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR
    to true via x2_inc_switches::SetModuleSwitch,
    the armor gets actually destroyed

    Chance to destroy armor is Bebilith BAB + StrengthMod + 8
    vs Disciple + Item AC value

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-26
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        = GetSpellCastItem();

   //Note that there needs to be no signal event in that scirpt, because this is not a spell ...



   if (GetIsObjectValid(oItem))
   {
        object oArmor =   GetItemInSlot(INVENTORY_SLOT_CHEST, oSpellTarget);
        object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
        object oDestroy;
        int nType = GetBaseItemType(oShield);
        // we actually have a shield here
        if (nType  == BASE_ITEM_LARGESHIELD || nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD)
        {
            //SpeakString("Shield")
        }
        else
        {
            oShield = OBJECT_INVALID;
        }
        int bShield = FALSE;
        // Determine which ite
        if (oArmor != OBJECT_INVALID && oShield != OBJECT_INVALID)
        {
            if (d4()<5)
            {
                oDestroy = oArmor;
            }
                else
            {
                oDestroy = oShield;
                bShield = TRUE;
            }
        }
            else if (oShield == OBJECT_INVALID)
        {
              oDestroy = oArmor;
        }
        else if (oArmor == OBJECT_INVALID)
        {
            oDestroy = oShield;
            bShield = TRUE;
        }

        if (oDestroy != OBJECT_INVALID)
        {
            int nDC = GetBaseAttackBonus(oSpellOrigin) + GetAbilityModifier(ABILITY_STRENGTH,oSpellOrigin) +  8   - GetItemACValue(oItem);
            if (nDC > 0)
            {
               if (!GetIsSkillSuccessful(oSpellTarget, SKILL_DISCIPLINE, nDC) )
                {

                    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR))
                    {
                          DestroyObject(oDestroy);
                         if (!bShield)
                         {
                             FloatingTextStrRefOnCreature(84428, oSpellTarget,FALSE);
                         }
                         else
                         {
                             FloatingTextStrRefOnCreature(84430, oSpellTarget,FALSE);
                         }
                    }
                    else
                    {
                         if (GetLocalInt(oDestroy,"X2_L_BEB_RUINED") == 1)
                         {
                            return;
                         }
                         CopyItem(oDestroy, oSpellTarget,TRUE);
                         SetLocalInt(oDestroy,"X2_L_BEB_RUINED",1);
                         DestroyObject(oDestroy);
                         if (!bShield)
                         {
                             FloatingTextStrRefOnCreature(84426, oSpellTarget,FALSE);
                         }
                         else
                         {
                             FloatingTextStrRefOnCreature(84429, oSpellTarget,FALSE);
                         }

                    }
                }
            }
        }
   }
}
