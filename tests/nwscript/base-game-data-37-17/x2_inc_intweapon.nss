//::///////////////////////////////////////////////
//:: Intelligent Weapon Include File
//:: x2_inc_intweapon
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Central include file for the intelligent weapon
    functionality in Hordes of the Underdark
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-04
//:: Modified  : 2003-10-11
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "x2_i0_spells"

// ----------------------------------------------------------------------------
// Configuration Constants
// ----------------------------------------------------------------------------
const int X2_IW_INTERJECTION_CHANCE_EQUIP = 25;
const int X2_IW_INTERJECTION_TYPE_EQUIP = 1;
const int X2_IW_INTERJECTION_EQUIP_COUNT = 5;

const int X2_IW_INTERJECTION_CHANCE_UNEQUIP = 25;
const int X2_IW_INTERJECTION_TYPE_UNEQUIP = 2;
const int X2_IW_INTERJECTION_UNEQUIP_COUNT = 5;

const int X2_IW_INTERJECTION_CHANCE_BATTLECRY = 8;
const int X2_IW_INTERJECTION_TYPE_BATTLECRY = 3;
const int X2_IW_INTERJECTION_BATTLECRY_COUNT = 20;

const int X2_IW_INTERJECTION_CHANCE_ONHIT_CRE = 20;
const int X2_IW_INTERJECTION_TYPE_ONHIT_CRE = 4;

const int X2_IW_INTERJECTION_TYPE_TRIGGER = 5;

const int X2_IW_CURSE_ENHANCEMENT_DURATION = 10;

// ----------------------------------------------------------------------------
// Prototypes
// ----------------------------------------------------------------------------

// *   Return the Dialog ResRef Name of the intelligent weapon passed in.
string IWGetWeaponDialogName(object oWeapon);

// *   Wrapper to use IWSpawnInWeaponCreature with Delaycommand
void   IWSWrapper(object oPlayer, object oWeapon);

// *   Spawns in a null human creature for oWeapon worn by oPlayer.
object IWSpawnInWeaponCreature(object oPlayer, object oWeapon, int bEquip = TRUE);

// *    Start a conversation with the intelligent weapon. This will make the
// *   weapon jump out of the players hands onto a null human and start the conv.
void   IWStartIntelligentWeaponConversation(object oPlayer,object oWeapon);

// *   End an intelligent weapon conversation, despawning the null human that wields
// *   the weapon and moving the weapon back into the players hands. This should be
// *   called on the OnEnd and OnAbort scripts of the weapon dialog
void   IWEndIntelligentWeaponConversation(object oWeaponCreature , object oPlayer);

// *   Returns TRUE if oPlayer is currently engaged in a conversation with his
// *   intelligent weapon
int    IWGetIsInIntelligentWeaponConversation(object oPlayer);

// *   Sets the starting conditions for the next intelligent weapon conversation
void   IWSetConversationCondition(object oPlayer,int nType, int nValue);

// *   Gets the starting conditions for current intelligent weapon conversation
int    IWGetConversationCondition(object oPlayer,int nType);

// *   Clear current intelligent weapon starting conditions
void   IWClearConversationConditions(object oPlayer);

void   IWSetCreatureHadOneLiner(object oCreature, int bValue);

void   IWPlayRandomEquipComment(object oPlayer,object oWeapon);

void   IWPlayRandomUnequipComment(object oPlayer,object oWeapon);

void   IWPlayRandomHitQuote(object oPlayer, object oWeapon, object oTarget);

object IWGetIntelligentWeaponEquipped(object oPlayer);

// * Transforms the weapon passed in oWeapon into an intelligent weapon, preserving
// * all item properties stored on the weapon.
// * nLevel - The power level of the weapon - unused at the moment (1 = default)
void IWCreateIntelligentWeapon(object oWeapon, int nLevel =1 );

void IWSetEnhancementAndDrainLevel(object oWeapon, int nAddition, int bRemove = FALSE);

int IWGetStaticEnhancementBonus(object oWeapon);

// * Sets the number of times a player has talked to the intelligent weapon
// * This information is stored on the player
void IWSetTalkedTo(object oPlayer, string sWeaponTag, int nNumTimes = 1);

// * Gets the number of times a player has talked to the intelligent weapon
// * This information is stored on the player
int IWGetTalkedTo(object oPlayer, string sWeaponTag);

// * Sets the asked flag for question no. nQuestion, in sWeaponTag's conversation
// * on the Player
void IWSetQuestionAsked(object oPlayer, string sWeaponTag,int nQuestion);

// * Returns the asked flag for question no. nQuestion, in sWeaponTag's conversation
// * on the Player
int IWGetQuestionAsked(object oPlayer, string sWeaponTag,int nQuestion);

// * Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// * Chapter 1
int IWGetIsHotUChapter1();

// * Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// * Chapter 2
int IWGetIsHotUChapter2();

// * Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// * Chapter 3
int IWGetIsHotUChapter3();

// -----------------------------------------------------------------------------
// Return the Dialog ResRef Name of the intelligent weapon passed in.
// -----------------------------------------------------------------------------
string IWGetWeaponDialogName(object oWeapon)
{
    return GetTag(oWeapon);
}

// -----------------------------------------------------------------------------
// Spawns in a null human creature for oWeapon worn by oPlayer.
// -----------------------------------------------------------------------------
object IWSpawnInWeaponCreature(object oPlayer, object oWeapon, int bEquip = TRUE)
{
    /*
    object oSummon = CreateObject(OBJECT_TYPE_CREATURE,"theintelligentwe",GetLocation(oPlayer));
    if (!GetIsObjectValid(oSummon))
    {
        // * Intentionally returning here
        return oSummon;
    }
    if (bEquip)
    {
        object oNew = CopyItem(oWeapon,oSummon,TRUE);
        SetDroppableFlag(oNew, FALSE);
        SetPlotFlag(oSummon,TRUE);
        if (GetIsInCombat(oPlayer))
        {
            //AssignCommand(oSummon,SpeakString("Not Now, we have to fight!"));
            return OBJECT_INVALID;
        }
        effect eInvis = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oSummon);
        DelayCommand(0.9f,AssignCommand(oSummon, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND)));
        DelayCommand(1.0f,ActionStartConversation(oSummon,IWGetWeaponDialogName(oWeapon),FALSE,FALSE));
    }
    SetLocalInt(oPlayer,"X2_L_IN_INTWEAPON_CONVERSATION",TRUE);
    SetLocalObject(oSummon,"CREATOR",oPlayer);
    SetLocalObject(oSummon,"BLADE",oWeapon);
    SetLocalObject(oPlayer,"X2_O_INTWEAPON_SPIRIT",oSummon);
    return oSummon;*/
    return OBJECT_INVALID;
}

// -----------------------------------------------------------------------------
// Wrapper to use IWSpawnInWeaponCreature with Delaycommand
// -----------------------------------------------------------------------------
void IWSWrapper(object oPlayer, object oWeapon)
{
    IWSpawnInWeaponCreature(oPlayer,oWeapon);
}

// -----------------------------------------------------------------------------
// Start a conversation with the intelligent weapon. This will make the
// weapon jump out of the players hands onto a null human and start the conv.
// -----------------------------------------------------------------------------
void IWStartIntelligentWeaponConversation(object oPlayer,object oWeapon)
{
    //SetLocalInt(oWeapon,"X2_L_INTWEAPON_EQUIP",1);
   // ActionUnequipItem(oWeapon);
    SetLocalInt(oPlayer,"X2_L_IN_INTWEAPON_CONVERSATION",TRUE);
    object oCreate = CreateObject(OBJECT_TYPE_PLACEABLE,"x2_plc_intwp",GetLocation(OBJECT_SELF));
    DelayCommand(0.9f,AssignCommand(oPlayer,ClearAllActions(TRUE)));
    DelayCommand(1.0,AssignCommand(oPlayer,ActionStartConversation(oCreate, IWGetWeaponDialogName(oWeapon))));
//    DelayCommand(1.0f,IWSWrapper(oPlayer,oWeapon));
//    ClearAllActions();
}

// -----------------------------------------------------------------------------
// End an intelligent weapon conversation,
// This should be called on the OnEnd and OnAbort scripts of the weapon dialog
// -----------------------------------------------------------------------------
void IWEndIntelligentWeaponConversation(object oWeaponCreature , object oPlayer)
{
/*   object oCreator =      GetLocalObject(oWeaponCreature,"CREATOR");
   object oBlade =    GetLocalObject(oWeaponCreature,"BLADE");
   effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
   AssignCommand(oCreator,ClearAllActions());
   DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oWeaponCreature));
   SetLocalInt(oBlade,"X2_L_INTWEAPON_EQUIP",1);
   DelayCommand(0.5f,AssignCommand(oCreator,ActionEquipItem(oBlade,INVENTORY_SLOT_RIGHTHAND)));
   effect eDis = EffectDisappear();
   ApplyEffectToObject(DURATION_TYPE_INSTANT,eDis,oWeaponCreature);
   DeleteLocalObject(oPlayer,"X2_O_INTWEAPON_SPIRIT");
   IWClearConversationConditions(oPlayer);*/
  DeleteLocalInt(oPlayer,"X2_L_IN_INTWEAPON_CONVERSATION");
}

// -----------------------------------------------------------------------------
// Returns TRUE if oPlayer is currently engaged in a conversation with his
// intelligent weapon
// -----------------------------------------------------------------------------
int IWGetIsInIntelligentWeaponConversation(object oPlayer)
{
    int nRet = GetLocalInt(oPlayer,"X2_L_IN_INTWEAPON_CONVERSATION");
    return nRet;

}

// -----------------------------------------------------------------------------
// Sets the starting conditions for the next intelligent weapon conversation
// -----------------------------------------------------------------------------
void IWSetConversationCondition(object oPlayer,int nType, int nValue)
{
    SetLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_TYPE", nType);
    SetLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_NUMBER", nValue);
}

// -----------------------------------------------------------------------------
// Clear current intelligent weapon starting conditions
// -----------------------------------------------------------------------------
void IWClearConversationConditions(object oPlayer)
{
    DeleteLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_TYPE");
    DeleteLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_NUMBER");
}

// -----------------------------------------------------------------------------
// Gets the starting conditions for current intelligent weapon conversation
// -----------------------------------------------------------------------------
int IWGetConversationCondition(object oPlayer,int nType)
{
    int nRet = FALSE;
    if (GetLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_TYPE") == nType && nType != 0)
    {
        nRet = GetLocalInt(oPlayer,"X2_L_INTWEAPON_CONV_NUMBER");
    }
    return nRet;
}


void  IWPlayRandomEquipComment(object oPlayer,object oWeapon)
{
    if (GetLocalInt(oWeapon,"X2_L_INTWEAPON_EQUIP") == 1)
    {
        DeleteLocalInt(oWeapon,"X2_L_INTWEAPON_EQUIP");
        return;
    }
   if (Random(100)+1 <X2_IW_INTERJECTION_CHANCE_EQUIP)
    {
       IWSetConversationCondition(oPlayer,X2_IW_INTERJECTION_TYPE_EQUIP,Random(X2_IW_INTERJECTION_EQUIP_COUNT)+1);
       AssignCommand(oPlayer,SpeakOneLinerConversation(IWGetWeaponDialogName(oWeapon),oPlayer));
   }
}

void  IWPlayRandomUnequipComment(object oPlayer,object oWeapon)
{
    if (GetLocalInt(oWeapon,"X2_L_INTWEAPON_EQUIP") == 1)
    {
        DeleteLocalInt(oWeapon,"X2_L_INTWEAPON_EQUIP");
        return;
    }
   if (Random(100)+1 <X2_IW_INTERJECTION_CHANCE_UNEQUIP)
   {
       IWSetConversationCondition(oPlayer,X2_IW_INTERJECTION_TYPE_UNEQUIP,Random(X2_IW_INTERJECTION_UNEQUIP_COUNT)+1);
       AssignCommand(oPlayer,SpeakOneLinerConversation(IWGetWeaponDialogName(oWeapon),oPlayer));
   }
}

void IWSetCreatureHadOneLiner(object oCreature, int bValue)
{
    SetLocalInt(oCreature,"X2_L_INTWEAPON_CONV_HAD_ONELINER",bValue);
}

int  IWGetCreatureHadOneLiner(object oCreature)
{
    return GetLocalInt(oCreature,"X2_L_INTWEAPON_CONV_HAD_ONELINER");
}



void IWPlayRandomHitQuote(object oPlayer, object oWeapon, object oTarget)
{

   if (!GetIsObjectValid(oTarget))
   {
        return;
   }

   if (GetIsDead(oTarget) || GetHasEffect( EFFECT_TYPE_PETRIFY,oTarget))
   {
        return;
   }

   if ( GetIsPC(oTarget ) )
   {
        return;
   }

   if ( GetObjectType(oTarget) != OBJECT_TYPE_CREATURE )
   {
        return;
   }

   IWClearConversationConditions(oPlayer);

   if (IWGetCreatureHadOneLiner(oTarget))
   {
       if (Random(100)+1 <X2_IW_INTERJECTION_CHANCE_BATTLECRY)
       {
           IWSetConversationCondition(oPlayer,X2_IW_INTERJECTION_TYPE_BATTLECRY,Random(X2_IW_INTERJECTION_BATTLECRY_COUNT)+1);
           AssignCommand(oPlayer,SpeakOneLinerConversation(IWGetWeaponDialogName(oWeapon),oPlayer));
       }
   }
   else
   {
       if (Random(100)+1 <X2_IW_INTERJECTION_CHANCE_ONHIT_CRE)
       {
           // * Storing the racial type offset by 1
           int nRacial = GetRacialType(oTarget);
           if (nRacial == 0)
           {
                nRacial = 250;
           }

           IWSetConversationCondition(oPlayer,X2_IW_INTERJECTION_TYPE_ONHIT_CRE,nRacial);
           AssignCommand(oPlayer,SpeakOneLinerConversation(IWGetWeaponDialogName(oWeapon),oPlayer));
           IWSetCreatureHadOneLiner(oTarget,TRUE);
       }
   }
}


// ----------------------------------------------------------------------------
// Play a Trigger Quote
// ----------------------------------------------------------------------------
void IWPlayTriggerQuote(object oPlayer, object oWeapon, int nID)
{
    IWSetConversationCondition(oPlayer,X2_IW_INTERJECTION_TYPE_TRIGGER,nID);
    AssignCommand(oPlayer,SpeakOneLinerConversation(IWGetWeaponDialogName(oWeapon),oPlayer));
}


void IWSetIntelligentWeaponEquipped(object oPlayer, object oWeapon)
{
    if (oWeapon == OBJECT_INVALID)
    {
        DeleteLocalInt(oPlayer,"X2_L_INTWEAPON_EQUIPPED");
    }
    else
    {
        SetLocalObject(oPlayer,"X2_L_INTWEAPON_EQUIPPED",oWeapon);
    }
}

object  IWGetIntelligentWeaponEquipped(object oPlayer)
{
    object oRet = GetLocalObject(oPlayer,"X2_L_INTWEAPON_EQUIPPED");
    return oRet;
}

// ----------------------------------------------------------------------------
// Transforms the weapon passed in oWeapon into an intelligent weapon, preserving
// all item properties stored on the weapon.
// nLevel - The power level of the weapon - unused at the moment (1 = default)
// ----------------------------------------------------------------------------
void IWCreateIntelligentWeapon(object oWeapon, int nLevel =1 )
{
  if (IPGetIsIntelligentWeapon(oWeapon))
  {
     return ;
  }
  itemproperty ipOnHit = ItemPropertyOnHitCastSpell(135,nLevel);
  IPSafeAddItemProperty(oWeapon, ipOnHit,0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,FALSE);
  itemproperty ipTalkTo = ItemPropertyCastSpell(536,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
  IPSafeAddItemProperty(oWeapon,ipTalkTo,0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,FALSE);
}

// ----------------------------------------------------------------------------
// Sets the number of times a player has talked to the intelligent weapon
// This information is stored on the player.
// ----------------------------------------------------------------------------
void IWSetTalkedTo(object oPlayer, string sWeaponTag, int nNumTimes = 1)
{
    SetLocalInt(GetModule(),"X2_L_INTWEAPON_NUMTALKS",nNumTimes);
}

// ----------------------------------------------------------------------------
// gets the number of times a player has talked to the intelligent weapon
// This information is stored on the player
// ----------------------------------------------------------------------------
int IWGetTalkedTo(object oPlayer, string sWeaponTag)
{
    int nRet = GetLocalInt(GetModule(),"X2_L_INTWEAPON_NUMTALKS");
    return nRet;
}

// ----------------------------------------------------------------------------
// Sets the asked flag for question no. nQuestion, in sWeaponTag's conversation
// on the Player
// ----------------------------------------------------------------------------
void IWSetQuestionAsked(object oPlayer, string sWeaponTag,int nQuestion)
{
    SetLocalInt(GetModule(),"X2_L_IW_ASKED_"+IntToString(nQuestion),TRUE);
}

// ----------------------------------------------------------------------------
// Returns the asked flag for question no. nQuestion, in sWeaponTag's conversation
// on the Player
// ----------------------------------------------------------------------------
int IWGetQuestionAsked(object oPlayer, string sWeaponTag,int nQuestion)
{
    int nRet = GetLocalInt(GetModule(),"X2_L_IW_ASKED_"+ IntToString(nQuestion));
    return nRet;
}

// ----------------------------------------------------------------------------
// Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// Chapter 1
// ----------------------------------------------------------------------------
int IWGetIsHotUChapter1()
{

    int bRet = (GetTag(GetModule()) == "x0_module1");
    return bRet;
}

// ----------------------------------------------------------------------------
// Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// Chapter 2
// ----------------------------------------------------------------------------
int IWGetIsHotUChapter2()
{

    int bRet = (GetTag(GetModule()) == "x0_module2");
    return bRet;
}

// ----------------------------------------------------------------------------
// Helper Function. Returns TRUE if we currently play Hordes of the Underdark
// Chapter 3
// ----------------------------------------------------------------------------
int IWGetIsHotUChapter3()
{
    int bRet = (GetTag(GetModule()) == "x0_module3");
    return bRet;
}

// ----------------------------------------------------------------------------
// Someone made a typo....
// ----------------------------------------------------------------------------
void IWClearConversationCondition(object oPlayer)
{
    IWClearConversationConditions(oPlayer);
}

// ----------------------------------------------------------------------------
// Returns the current permanent part of oWeapon's enhancement bonus
// ----------------------------------------------------------------------------
int IWGetStaticEnhancementBonus(object oWeapon)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    while (nFound == 0 && GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
            {
                nFound = GetItemPropertyCostTableValue(ip);
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound;
}

// ----------------------------------------------------------------------------
// Function to manage the intelligent sword's drain abilityin the
// official campaign.
// nAddition: The number to increase the enchantment bonus by
// The function will fail whenever any wrong value has been entered
// ----------------------------------------------------------------------------
void IWSetEnhancementAndDrainLevel(object oWeapon, int nAddition, int bRemove = FALSE)
{
    if (bRemove)
    {
        IPRemoveMatchingItemProperties(oWeapon,ITEM_PROPERTY_VISUALEFFECT,DURATION_TYPE_TEMPORARY);
        IPRemoveMatchingItemProperties(oWeapon,ITEM_PROPERTY_ENHANCEMENT_BONUS,DURATION_TYPE_TEMPORARY);
        IPRemoveMatchingItemProperties(oWeapon,ITEM_PROPERTY_DECREASED_ABILITY_SCORE,DURATION_TYPE_TEMPORARY);
        return;
    }
    int nCurse = nAddition*2;
    if (nAddition <1)
    {
        return;
    }
    if (nCurse > 10)
    {
        return;
    }
    itemproperty ip = ItemPropertyDecreaseAbility(ABILITY_CONSTITUTION,nCurse);
    int nEnhancement = IWGetStaticEnhancementBonus(oWeapon);
    nEnhancement += nAddition;
    if (nEnhancement>20)
    {
        nEnhancement = 20;
    }
    itemproperty ip2 = ItemPropertyEnhancementBonus(nEnhancement);
    itemproperty ip3 = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);

    float fTime = RoundsToSeconds(X2_IW_CURSE_ENHANCEMENT_DURATION);

    IPSafeAddItemProperty(oWeapon,ip3,fTime, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
    IPSafeAddItemProperty(oWeapon,ip2,fTime, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE,TRUE);
    IPSafeAddItemProperty(oWeapon,ip,fTime, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,FALSE);


}
