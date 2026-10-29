//::///////////////////////////////////////////////
//:: XP2 Disposeable Treasure System
//:: x2_inc_treasure
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-03
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
const int X2_DTS_CLASS_LOW     = 0;       //Treasure Class Low
const int X2_DTS_CLASS_MEDIUM  = 1;       //Treasure Clas Medium
const int X2_DTS_CLASS_HIGH    = 2;       //Treasure Class High

const int X2_DTS_TYPE_DISP =1;
const int X2_DTS_TYPE_AMMO=2;
const int X2_DTS_TYPE_GOLD=4;             // actually gold and gems
const int X2_DTS_TYPE_ITEM=8;            // char specific Item


// These are the system default values
const int X2_DTS_BASECHANCE_TREAS = 50;// Basic chance for treasure
const int X2_DTS_MAXITEMS = 2;
const int X2_DTS_STACKVAR = 50; // Stack variation is 50-100 percent of the number listed in the 2da

// These are the names of the default 2das.
const string X2_DTS_2DA_DISP        =  "des_treas_disp";  // 2da for disposeable class treasure
const string X2_DTS_2DA_AMMO        =  "des_treas_ammo";         // 2da for ammo class treasure
const string X2_DTS_2DA_GOLD        =  "des_treas_gold";         // 2da for gold n gems
const string X2_DTS_2DA_ITEM        =  "des_treas_items";         // 2da for specific items

const string X2_DTS_2DA_ENHANCEMENTS = "des_treas_enh";

const string X2_DTS_2DA_CONF = "des_conf_treas";          // 2da with configuration

// ***    P R O T O T Y P E S      ***


// Generate random, disposeable treasure on the container
// oContainer - Valid object with inventory
// oOpener    - The one who opened the container
// nClass - Treasure Class (X2_DTS_CLASS_*)
// nType  - Treasure Type  (X2_DTS_TYPE_*), default = X2_DTS_TYPE_DISPOSEABLE | X2_DTS_TYPE_GOLD
//          Values: X2_DTS_TYPE_DISPOSEABLE - Potions, Kits, etc
//                  X2_DTS_TYPE_AMMO        - Ammunition
//                  X2_DTS_TYPE_GOLD        - Gold and Gems
//                  X2_DTS_TYPE_ITEM    - Character Optimized treasure (ignores treasure class)
// Example:
//     Generate Low Class Ammo and Gold+Gems
//     DTSGenerateTreasureOnContainer (oChest, X2_DTS_CLASS_LOW, X2_DTS_TYPE_AMMO | X2_DTS_TYPE_GOLD);
void DTSGenerateTreasureOnContainer (object oContainer, object oOpener, int nClass, int nType = 5);

// Generates one random, character specific item on container
// Treasure is optimized to suit a characters needs
// if bIgnoreFeats is set TRUE, the system will not use Feats (i.e. Weapon Focus)
// to determine a baseitem to spawn
object DTSGenerateCharSpecificTreasure (object oContainer, object oAdventurer, int bIgnoreFeats = FALSE);


// Initializes the treasure system by loading x2_conf_tras.2da
// nConfigIndex - RowIndex of the configuration to load
void DTSInitialize( int nConfigIndex = 0);

// Sets the area wide chance for treasure Generation ...
// if bDisable = TRUE, then no random treasure is generated at all
void DTSSetAreaTreasureProbability(object oArea, int nBaseChance, int bDisabled = FALSE);

// Enchantes the weapon passed in oItem with a scaled enhancement bonus
// nLevel should be the level of the player who is going to receive
// the item. Lookup is done via  des_treas_enh.2da.
// returns TRUE on success
int DTSGrantCharSpecificWeaponEnhancement(int nLevel, object oItem);


// *** I M P L E M E N T A T I O N ***


/* ----------------------------------------------------------
   Private Functions - Do not call from outside
   ---------------------------------------------------------- */

void DTSDebug(string s)
{
    //SendMessageToPC(GetFirstPC(),"***DTS-Debug: " +s);
    WriteTimestampedLogEntry("***DTS-Debug: " +s);
}


// Get a 2da String or the supplied default if string is empty
string DTSGet2DAStringOrDefault(string s2DA, string sColumn, int nRow, string sDefault)
{
    string sRet;
    sRet =Get2DAString(s2DA, sColumn, nRow);
    if (sRet == "****" || sRet == "")
    {
        sRet = sDefault;
    }
    return sRet;

}

// Maps the X2_DTS_TYPE_* value given in nType to a 2da name
string DTSGet2DANameByType(int nType)
{
    string sLookUp;
    string sDefault;
    if (nType == X2_DTS_TYPE_DISP)
    {
        sLookUp =  "X2_DTS_2DA_DISP";
        sDefault = X2_DTS_2DA_DISP;
    }
    else if (nType == X2_DTS_TYPE_AMMO)
    {
        sLookUp =  "X2_DTS_2DA_AMMO";
        sDefault = X2_DTS_2DA_AMMO;
    }

    else if (nType == X2_DTS_TYPE_ITEM)
    {
        sLookUp =  "X2_DTS_2DA_ITEM";
        sDefault = X2_DTS_2DA_ITEM;
    }
    else
    {
        sLookUp =  "X2_DTS_2DA_GOLD";
        sDefault = X2_DTS_2DA_GOLD;
    }

    string sRet = GetLocalString(GetModule(),sLookUp);
    if (sRet == "")
    {
        sRet = sDefault;
    }
    return sRet;

}

// Maps the X2_DTS_CLASS_* value given in nType to row name in the 2da
string DTSGet2DAColNameByClass(int nClass)
{
    if (nClass == X2_DTS_CLASS_MEDIUM)
        return "TMed";
    else if (nClass == X2_DTS_CLASS_HIGH)
        return "THigh";
    //  if (nClass == X2_DTS_CLASS_LOW)
    // Default to low
    return "TLow";
}

// Returns the number of entries available for random treasure of a given type and class
// nType   - X2_DTS_TYPE_*
// nClass  - X2_DTS_CLASS_* (default = X2_DTS_CLASS_LOW)
// sCol    - used when X2_DTS_TYPE_ITEM is specified
int DTSGetNoOfRowsInTreasureTable(int nType, int nClass = 1, string sCol = "")
{
    string s2DA = DTSGet2DANameByType(nType);
    int nRet;
    if (nType == X2_DTS_TYPE_ITEM)
    {
        nRet = StringToInt(Get2DAString(s2DA ,sCol,0));
    }
    else
    {
        string sColName = DTSGet2DAColNameByClass(nClass);
        nRet =GetLocalInt(GetModule(),"X2_DTS_CACHE_"+s2DA+sColName);
        if (nRet !=0)
        {
            return nRet;
        }
        // Row 0 always holds the total number of entries.
        nRet = StringToInt(Get2DAString(s2DA,sColName,0));
        SetLocalInt(GetModule(),"X2_DTS_CACHE_"+s2DA+sColName,nRet);
    }
    return nRet;
}


int DTSGetBaseChance(object oArea)
{

   // Check for override on area
   int nChance = GetLocalInt(oArea,"X2_DTS_BASECHANCE");
   if (nChance == 0) //check configuration
   {
       nChance = GetLocalInt(GetModule(),"X2_DTS_BASECHANCE");
       if (nChance == 0) //take default
       {
           //DTSDebug("++WARNING++ not initialized, using defaults");
           nChance  = X2_DTS_BASECHANCE_TREAS;
       }
       else if (nChance == -1)          // -1 = no treasure
           nChance = 0;
   }
   else if (nChance == -1)          // -1 = no treasure
       nChance = 0;
   return nChance;
}

// Returns the maximum number of items to generate according to the configuration
// If no configuration is used, default is X2_DTS_MAXITEMS (2)
int DTSGetMaxItems()
{
   int nItems= GetLocalInt(GetModule(),"X2_DTS_MAXITEMS");
   if (nItems == 0)
   {
       //DTSDebug("++WARNING++ not initialized, using defaults");
       nItems  = X2_DTS_MAXITEMS;
   }
   return nItems;
}

// Returns the stack variation to use when generation stacked items
// If no configuration is used, default is X2_DTS_STACKVAR (0.5)
// Stacks are calculated (Stack* X2_DTS_STACKVAR) + Random (Stack *X2_DTS_STACKVAR)
float DTSGetStackVariation()
{
   float fStackV = GetLocalFloat(GetModule(),"X2_DTS_STACKVAR");
   if (fStackV == 0.0f)
   {
       //DTSDebug("++WARNING++ not initialized, using defaults");
       fStackV  =X2_DTS_STACKVAR / 100.0f;
   }
   return fStackV;
}

// Enchantes the weapon passed in oItem with a scaled enhancement bonus
// nLevel should be the level of the player who is going to receive
// the item. Lookup is done via  des_treas_enh.2da.
// returns TRUE on success
int DTSGrantCharSpecificWeaponEnhancement(int nLevel, object oItem)
{
    if (! IPGetIsRangedWeapon(oItem) && !IPGetIsMeleeWeapon(oItem))
    {
        return FALSE;
    }
    //int nBT = GetBaseItemType(oItem);
    // RangedWeapon column  != 0 we assume its a ranged weapon

    int bRanged = IPGetIsRangedWeapon(oItem);
    string sCol;
    if (bRanged)
    {
        sCol = "Ranged" ;
    }
    else
    {
        sCol = "Melee";
    }

    int nBonus = StringToInt(Get2DAString(X2_DTS_2DA_ENHANCEMENTS,sCol, nLevel));
    // remove existing enhancement properties from weapon

    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
          RemoveItemProperty (oItem,ip);
        }
        ip = GetNextItemProperty(oItem);
    }

    if (nBonus > 0 && nBonus < 21)
    {
        ip = ItemPropertyEnhancementBonus(nBonus);
        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oItem);
        return TRUE;
    }
    //else
    //{
    //    DTSDebug("x2_inc_treasure()::DTSGrantCharSpecificWeaponEnhancement() - invalid bonus generated: " + IntToString(nBonus));
    //}
    return FALSE;

}

//This is a wrapper for CreateItemOnObject which can handle the stack number
//given on
object DTSCreateItemOnObject(string sItemTemplate, object oTarget)
{
    if (sItemTemplate == "")
        return OBJECT_INVALID;
    int nStack = FindSubString(sItemTemplate,":");
    int nStackSize =1 ;
    object oItem;
    if (nStack>0)
    {
       string sNum = GetSubString(sItemTemplate,nStack+1,GetStringLength(sItemTemplate)-nStack);
       sItemTemplate = GetSubString(sItemTemplate,0,nStack);
       int nMaxStackSize = StringToInt(sNum);

       // Random part of stacksize
       int nRandom =    FloatToInt(DTSGetStackVariation() * nMaxStackSize);
       // fixed part of stacksize
       int nStackSize = nMaxStackSize - nRandom;
       nStackSize  +=Random(nRandom);

       oItem = CreateItemOnObject(sItemTemplate,oTarget,nStackSize);
    }
    else
    {
        oItem = CreateItemOnObject(sItemTemplate,oTarget);
    }
    //if (oItem == OBJECT_INVALID)
    //{
    //   DTSDebug(" +++2da ERROR +++ Invalid Entry:" + sItemTemplate);
    //}
    return oItem;
}


// Returns a single random item resref from the approriate 2da
// nType   - X2_DTS_TYPE_*  - Type of Treasure (i.e. disposeable, ammo)
// nClass  - X2_DTS_CLASS_* - Class of Treasure (i.e. high, medium, low)
string DTSGetRandomItemResRef(int nType, int nClass)
{
    string s2DA = DTSGet2DANameByType(nType);

    string sRowName = DTSGet2DAColNameByClass(nClass);

    // Retrieve the number of items in treasure table
    int nMax = DTSGetNoOfRowsInTreasureTable(nType,nClass);
    if (nMax == 0)
        return "";
    int nRand = Random(nMax)+1; // select a row from 1.. nMax
    string sRet = Get2DAString(s2DA,sRowName,nRand);

    return sRet;
}

string DTSGetFeatSpecificItemResRef(int nFeatID)
{
    string sCol =  Get2DAString("des_feat2item","TreasureCol",nFeatID);
    int nRand =DTSGetNoOfRowsInTreasureTable(X2_DTS_TYPE_ITEM,1,sCol);
    nRand = Random(nRand)+1;
    string sItem =  Get2DAString(DTSGet2DANameByType(X2_DTS_TYPE_ITEM),sCol,nRand);
    return sItem;
}




// Returns the Highest class of a creature
int DTSGetHighestClass(object oCreature)
{
    int nClass1 = GetLevelByPosition(1, oCreature);
    int nClass2 = GetLevelByPosition(2, oCreature);
    int nClass3 = GetLevelByPosition(3, oCreature);
    if ((nClass1>=nClass2) && (nClass1>=nClass3))
    {
        return GetClassByPosition(1, oCreature);
    }
    else if((nClass2>=nClass1) && (nClass2>=nClass3))
    {
        return GetClassByPosition(2, oCreature);
    }
    else
    {
        return GetClassByPosition(3, oCreature);\
    }
}


// Returns the FEAT_ID of the feat to use for treasure generation
//
// This code tries to figure out what kind of weapon a player would want to use
// it will examine the players feats in the following order
//
// 1. Weapon Master: Weapon of Choise
// 2. Fighter: Weapon Specialication
// 3. All: Improved Critical
// 4. All: Weapon Focus
// 5. Highest class (will map to class specific feats like FEAT_WEAPON_PROFICIENCY_WIZARD)
//
// if you specify bUseNoFeats to be TRUE, the system will decide which item table to use
// based on the characters class alone (skipping step 1-4). Useful for generating things
// that are not weapons

int DTSDetermineFeatToUse(object oAdventurer, int bDontUseFeats = FALSE)
{
    //Ok this is not the most beautiful code, but it works since 2da row indices
    //are not allowed to change...
    int nRangeStart;
    int nRangeStop;
    int i;

    // only run this if feat specific items are requestd
    if (!bDontUseFeats)
    {
        // Weapon Master : Weapon of choise
        // ---------------------------------------------------
        if (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)>0)
        {
            if (GetHasFeat(959,oAdventurer))
            {
                return 959; // special treatment for dwarven waraxe
            }
            if (GetHasFeat(1000,oAdventurer))
            {
                return 1000; // special treatment for whip
            }
            nRangeStart =943;
            nRangeStop = 919;
            for (i=nRangeStart; i>=nRangeStop;i--)
            {
                if (GetHasFeat(i,oAdventurer))
                    return i;
            }
        }
        // ---------------------------------------------------

        // Checking for Weapon focus and specialications


        // Include Weapon Specialication in search range if we have 4+ levels of fighter
        // ---------------------------------------------------
        if (GetLevelByClass(CLASS_TYPE_FIGHTER)>3)
        {
            if (GetHasFeat(953,oAdventurer))
            {
                return 953; // special treatment for dwarven waraxe
            }

        if (GetHasFeat(994,oAdventurer))
            {
              return 994; // special treatment whip
            }

            nRangeStart =165; // Weapon Specializations
            nRangeStop = 90; // WeaponFoci Start here
            for (i=nRangeStart; i>=nRangeStop;i--)
            {
                if (GetHasFeat(i,oAdventurer))
                    return i;
            }
        }
       // ---------------------------------------------------

        // Examine Improved Critical
        // ---------------------------------------------------
        if (GetHasFeat(954,oAdventurer))
        {
            return 954; // special treatment for dwarven waraxe
        }
        if (GetHasFeat(995,oAdventurer))
        {
            return 995; // special treatment whip
        }

        nRangeStart = 89; // Improved
        nRangeStop = 52; // WeaponFoci end here
        for (i=nRangeStart; i>=nRangeStop;i--)
        {
            if (GetHasFeat(i,oAdventurer))
                return i;
        }
        // ---------------------------------------------------


        // Examine Weapon Foci
        // ---------------------------------------------------
        if (GetHasFeat(952,oAdventurer))
        {
            return 952; // special treatment for dwarven waraxe
        }
        if (GetHasFeat(993,oAdventurer))
        {
            return 993; // special treatment for whip
        }

        nRangeStart = 127; // End of weapon foci
        nRangeStop = 90; // WeaponFoci Start here
        for (i=nRangeStart; i>=nRangeStop;i--)
        {
            if (GetHasFeat(i,oAdventurer))
                return i;
        }
       // ---------------------------------------------------

   }

    // highest class code
    int nHighest = DTSGetHighestClass(oAdventurer);

    //Note that the order of the cases in this statement is IMPORTANT!
    switch (nHighest)
    {
        case CLASS_TYPE_WIZARD:   //no break is intentional
        case CLASS_TYPE_SORCERER:
                    return FEAT_WEAPON_PROFICIENCY_WIZARD;
                    break;
        case CLASS_TYPE_ROGUE:
                    return FEAT_WEAPON_PROFICIENCY_ROGUE;
                    break;
        case CLASS_TYPE_MONK:
                    return FEAT_WEAPON_PROFICIENCY_MONK;
                    break;
        case CLASS_TYPE_SHIFTER:    // no break intentional, we assume shifter == druid
        case CLASS_TYPE_DRUID:
                    return FEAT_WEAPON_PROFICIENCY_DRUID;
                    break;
        case CLASS_TYPE_PALADIN:
                    return 299; // lay on hands
                    break;
        case CLASS_TYPE_CLERIC:
                    return 294; //  turn undead
                    break;
        case CLASS_TYPE_SHADOWDANCER:
                    return 433;  // hide in plain sight
                    break;
        case CLASS_TYPE_BARD:
                    return 257;  // bard songs
                    break;
        case CLASS_TYPE_FIGHTER:
                    return 657;  // some epic weapon spec
                    break;
        case CLASS_TYPE_BARBARIAN:
                    return 293;   // barb rage
                    break;
        case CLASS_TYPE_PALEMASTER:
                    return 892;  // undead graft
                    break;
        case CLASS_TYPE_ASSASSIN:
                    return 455 ; // death attack
                    break;
       case CLASS_TYPE_ARCANE_ARCHER:
                    return 445 ; // enchant arrow
                    break;
       case CLASS_TYPE_WEAPON_MASTER:
                    return 885 ; // ki crit
                    break;
       case CLASS_TYPE_BLACKGUARD:
                    return 460 ; // bg sneak attack
                    break;
       case CLASS_TYPE_DWARVENDEFENDER:
                    return 947 ; // defensive stance
                    break;
       case CLASS_TYPE_DIVINECHAMPION:
                    return 904 ; // sacred defense
                    break;
    }
      return 455 ; // class_any

}


void DTSGenerateTreasureItems(object oContainer, object oOpener, int nClass, int nType)
{
   string sItem;
   int nChance = DTSGetBaseChance(GetArea(oContainer));

   if (nChance == 0)
        return ;     // no point in running further code

   if ((nType & X2_DTS_TYPE_ITEM) && nChance > d100())
   {
          // regardless how often this function is called, only one char
          // specific treasure item will be created ... ever
          if (!GetLocalInt(oContainer, "X2_DTS_HAS_CHAR_SPECIFIC_TREASURE"))
          {
              DTSGenerateCharSpecificTreasure(oContainer, oOpener);
              SetLocalInt(oContainer, "X2_DTS_HAS_CHAR_SPECIFIC_TREASURE", TRUE);
          }
    }
   if ((nType & X2_DTS_TYPE_GOLD) && nChance > d100())
   {
          if (!GetLocalInt(oContainer, "X2_DTS_HAS_GOLD"))
          {
              sItem = DTSGetRandomItemResRef(X2_DTS_TYPE_GOLD, nClass);
              DTSCreateItemOnObject(sItem, oContainer);
              SetLocalInt(oContainer, "X2_DTS_HAS_GOLD", TRUE);
         }
   }
   if ((nType & X2_DTS_TYPE_DISP) && nChance > d100())
   {
          sItem = DTSGetRandomItemResRef(X2_DTS_TYPE_DISP, nClass);
          DTSCreateItemOnObject(sItem, oContainer);
   }
   if ((nType & X2_DTS_TYPE_AMMO) && nChance > d100())
   {
          sItem = DTSGetRandomItemResRef(X2_DTS_TYPE_AMMO, nClass);
          DTSCreateItemOnObject(sItem, oContainer);
   }

  return;

}

int DTSGetNumberofPartyMembers(object oPC)
{
    object oCount = GetFirstFactionMember(oPC,TRUE);
    int nCount;
    while (oCount !=OBJECT_INVALID)
    {
        nCount++;
        oCount = GetNextFactionMember(oPC,TRUE);
    }
    return nCount ;
}



// +++ PUBLIC FUNCTIONS +++



//::///////////////////////////////////////////////
//:: DTSGenerateTreasureOnContainer
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Generate random, disposeable treasure on the container
 oContainer - Valid object with inventory
 nClass - Treasure Class (X2_DTS_CLASS_*)
 nType  - Treasure Type  (X2_DTS_TYPE_*), default = X2_DTS_TYPE_DISPOSEABLE (1) | X2_DTS_TYPE_GOLD (4)
 Example
     Generate Low Class Ammo and Gold+Gems
     DTSGenerateTreasureOnContainer (oChest, X2_DTS_CLASS_LOW, X2_DTS_TYPE_AMMO | X2_DTS_TYPE_GOLD);
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-03
//:://////////////////////////////////////////////
void DTSGenerateTreasureOnContainer (object oContainer, object oOpener, int nClass, int nType = 5)
{
    int nCount;
    int nMax = Random(DTSGetMaxItems())+1;

    // Add one more item per two partymembers
    // nMax += (DTSGetNumberofPartyMembers(oOpener) /2) ;

    for (nCount = 0; nCount <= nMax; nCount++)
    {
        DTSGenerateTreasureItems(oContainer, oOpener,  nClass, nType);
    }

    // Remove flags set within DTSGenerateTreasureItems
    DeleteLocalInt(oContainer, "X2_DTS_HAS_CHAR_SPECIFIC_TREASURE");
    DeleteLocalInt(oContainer, "X2_DTS_HAS_GOLD");
}


//::///////////////////////////////////////////////
//:: DTSGenerateCharSpecificTreasure
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Generate random, disposeable treasure on the container
 oContainer - Valid object with inventory
 nClass - Treasure Class (X2_DTS_CLASS_*)
 nType  - Treasure Type  (X2_DTS_TYPE_*), default = X2_DTS_TYPE_DISPOSEABLE (1) | X2_DTS_TYPE_GOLD (4)
 bIgnoreFeat - do not examine weapon feats when creating items, instead use class only
 Example
     Generate Low Class Ammo and Gold+Gems
     DTSGenerateTreasureOnContainer (oChest, X2_DTS_CLASS_LOW, X2_DTS_TYPE_AMMO | X2_DTS_TYPE_GOLD);
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-04
//:://////////////////////////////////////////////
object DTSGenerateCharSpecificTreasure (object oContainer, object oAdventurer, int bIgnoreFeats = FALSE)
{

    int nFeat = DTSDetermineFeatToUse(oAdventurer,bIgnoreFeats);
    string sItem ;
    object oRet;
    if (nFeat == -1)  // did not find a feat, try class specific code
    {
        DTSDebug("Did not find a feat for specific treasure for "+ GetName(oAdventurer));
    }
    else
    {
        sItem = DTSGetFeatSpecificItemResRef(nFeat);
        oRet = DTSCreateItemOnObject(sItem, oContainer);
    }

    return oRet;
}



void DTSInitialize( int nConfigIndex = 0)
{
    int nBaseChance = StringToInt(DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "BaseTreasureChance", nConfigIndex, IntToString(X2_DTS_BASECHANCE_TREAS)));
    int nMaxItems = StringToInt(DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "MaxItems", nConfigIndex, IntToString(X2_DTS_MAXITEMS)));
     // using int because Get2DAString does not work well with floats
    int nStackVariation = StringToInt(DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "StackVariation", nConfigIndex, IntToString(X2_DTS_STACKVAR)));
    float fStackVariation = nStackVariation / 100.0f;
    if (fStackVariation == 0.0f)
    {
        fStackVariation = X2_DTS_STACKVAR / 100.0f    ;
    }

    string s2DA = DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "Gold2da", nConfigIndex,X2_DTS_2DA_GOLD );
    SetLocalString(GetModule(),"X2_DTS_2DA_GOLD", s2DA);
    s2DA = DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "Item2DA",nConfigIndex,X2_DTS_2DA_ITEM );
    SetLocalString(GetModule(),"X2_DTS_2DA_ITEM", s2DA);
    s2DA = DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "Ammo2DA", nConfigIndex,X2_DTS_2DA_AMMO );
    SetLocalString(GetModule(),"X2_DTS_2DA_AMMO", s2DA);
    s2DA = DTSGet2DAStringOrDefault(X2_DTS_2DA_CONF, "Disp2DA", nConfigIndex,X2_DTS_2DA_DISP );
    SetLocalString(GetModule(),"X2_DTS_2DA_DISP", s2DA);

    SetLocalInt(GetModule(),"X2_DTS_BASECHANCE",nBaseChance);
    SetLocalFloat(GetModule(),"X2_DTS_STACKVAR",fStackVariation);
    SetLocalInt(GetModule(),"X2_DTS_MAXITEMS",nMaxItems);

    //DTSDebug("DTS Initialized - BaseChance: " + IntToString(nBaseChance) + " StackVar: " + FloatToString(fStackVariation) + " MaxItems: " + IntToString(nMaxItems));
}

// Sets the area wide chance for treasure Generation ...
// if bDisable = TRUE, then no random treasure is generated at all
void DTSSetAreaTreasureProbability(object oArea, int nBaseChance, int bDisabled = FALSE)
{
    if (bDisabled)
        SetLocalInt(oArea,"X2_DTS_BASECHANCE",-1); // -1 = no treasure
    else
        SetLocalInt(oArea,"X2_DTS_BASECHANCE",nBaseChance);

}

