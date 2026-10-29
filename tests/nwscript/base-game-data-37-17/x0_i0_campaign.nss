//:://////////////////////////////////////////////////
//:: X0_I0_CAMPAIGN
/*

  NOTE: this file is included in x0_i0_partywide, which is included in
  x0_i0_common. Watch out for double-includes!

  Include library for setting variables solely for specific
  campaigns. These use the "Campaign" var functions. 

  General idea: check the module for a local string variable called
  "X0_CAMPAIGN_DB". Use the value of this variable as the database
  name. 

  ********     MODMAKERS     ********************************************
  *
  *  To give your module a custom database, just add a line like
  *  this to the "OnModuleLoad" event script for your module:
  *

    SetLocalString(GetModule(), "X0_CAMPAIGN_DB", "name_for_your_db_here");

  *
  *  You can then use all of the XP1 scripts with no other changes needed. 
  *
  *  Do NOT modify this library, as you would have to recompile ALL of the 
  *  scripts that use this include file either directly or indirectly for
  *  the changes to actually work. 
  *
  ***********************************************************************

  If no such variable is set, check to see if the module tag matches 
  a 'known module' tag (this is for official expansions only!) and 
  attempt to set the variable. If no known variable found, set it to a 
  default value. 

*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/04/2003
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

//******** Add new database names here (for official campaigns only!)
// Actual db name is arbitrary, but suggest sticking to the below model

string X0_DATABASE_DEFAULT = "nw_campaign_db_default";

string X0_DATABASE_XP1 = "nw_campaign_db_xp1";

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Return the name of the campaign database that should be used for
// this module (or a default value if none). 
string GetCampaignDBName();

// Set a campaign string on a PC in the default DB for this module
void SetCampaignDBString(object oPC, string sVarname, string value);

// Set a campaign string on a PC in the default DB for this module
string GetCampaignDBString(object oPC, string sVarname);

// Set a campaign int on a PC in the default DB for this module
void SetCampaignDBInt(object oPC, string sVarname, int value);

// Get a campaign int on a PC in the default DB for this module
int GetCampaignDBInt(object oPC, string sVarname);

// Set a campaign float on a PC in the default DB for this module
void SetCampaignDBFloat(object oPC, string sVarname, float value);

// Get a campaign float on a PC in the default DB for this module
float GetCampaignDBFloat(object oPC, string sVarname);

// Set a campaign vector on a PC in the default DB for this module
void SetCampaignDBVector(object oPC, string sVarname, vector value);

// Get a campaign vector on a PC in the default DB for this module
vector GetCampaignDBVector(object oPC, string sVarname);

// Set a campaign location on a PC in the default DB for this module
void SetCampaignDBLocation(object oPC, string sVarname, location value);

// Get a campaign location on a PC in the default DB for this module
location GetCampaignDBLocation(object oPC, string sVarname);

// Store a campaign object on a PC in the default DB for this module
// NOTE: this does not store a reference, it stores the entire actual object,
// including all of its inventory. Storing many objects can be highly resource-
// intensive! It should NOT be used like Set/GetLocalObject.
int StoreCampaignDBObject(object oPC, string sVarname, object value);

// Get a campaign object stored on a PC in the default DB for this module
// NOTE: this does not get a reference, it creates the actual object,
// either in the PC's inventory if possible or in the specified location
// if not. It should NOT be used like Set/GetLocalObject.
//
// If you pass in a valid object for oInventory, the object will be 
// retrieved in that object's inventory instead of the PC's.
//
// You should use DeleteCampaignDBVariable to remove the object once you
// are done retrieving it, or else the DB will bloat. 
object RetrieveCampaignDBObject(object oPC, string sVarname, location lLoc, object oInventory=OBJECT_INVALID);

// Delete a campaign variable
void DeleteCampaignDBVariable(object oPC, string sVarname);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Return the name of the campaign database that should be used for
// this module (or a default value if none). 
string GetCampaignDBName()
{
    object oModule = GetModule();

    // First just check if we've already set it
    string sDB = GetLocalString(oModule, "X0_CAMPAIGN_DB");
    if ( sDB != "") return sDB;

    // Look up the module tag
    string sModTag = GetTag(oModule);
    
    // Current 'known' modules: 
    //         XP1: x0_module1, x0_module2, x0_module3
    // 
    if (sModTag == "x0_module1" || sModTag == "x0_module2" || sModTag == "x0_module3"
        || sModTag == "x0_module3e")
        sDB = X0_DATABASE_XP1;
    else
        sDB = X0_DATABASE_DEFAULT;

    // Set the value we'll be using, then return it
    SetLocalString(oModule, "X0_CAMPAIGN_DB", sDB);
    return sDB;
}

// Set a campaign string on a PC in the default DB for this module
void SetCampaignDBString(object oPC, string sVarname, string value)
{
    SetCampaignString(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign string on a PC in the default DB for this module
string GetCampaignDBString(object oPC, string sVarname)
{
    return GetCampaignString(GetCampaignDBName(), sVarname, oPC);
}

// Set a campaign int on a PC in the default DB for this module
void SetCampaignDBInt(object oPC, string sVarname, int value)
{
    SetCampaignInt(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign int on a PC in the default DB for this module
int GetCampaignDBInt(object oPC, string sVarname)
{
    return GetCampaignInt(GetCampaignDBName(), sVarname, oPC);
}

// Set a campaign float on a PC in the default DB for this module
void SetCampaignDBFloat(object oPC, string sVarname, float value)
{
    SetCampaignFloat(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign float on a PC in the default DB for this module
float GetCampaignDBFloat(object oPC, string sVarname)
{
    return GetCampaignFloat(GetCampaignDBName(), sVarname, oPC);
}

// Set a campaign vector on a PC in the default DB for this module
void SetCampaignDBVector(object oPC, string sVarname, vector value)
{
    SetCampaignVector(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign vector on a PC in the default DB for this module
vector GetCampaignDBVector(object oPC, string sVarname)
{
    return GetCampaignVector(GetCampaignDBName(), sVarname, oPC);
}

// Set a campaign location on a PC in the default DB for this module
void SetCampaignDBLocation(object oPC, string sVarname, location value)
{
    SetCampaignLocation(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign location on a PC in the default DB for this module
location GetCampaignDBLocation(object oPC, string sVarname)
{
    return GetCampaignLocation(GetCampaignDBName(), sVarname, oPC);
}

// Set a campaign object on a PC in the default DB for this module
int StoreCampaignDBObject(object oPC, string sVarname, object value)
{
    return StoreCampaignObject(GetCampaignDBName(), sVarname, value, oPC);
}

// Get a campaign object stored on a PC in the default DB for this module
// NOTE: this does not get a reference, it creates the actual object,
// either in the PC's inventory if possible or in the specified location
// if not. It should NOT be used like Set/GetLocalObject.
//
// If you pass in a valid object for oInventory, the object will be 
// retrieved in that object's inventory instead of the PC's.
//
// You should use DeleteCampaignDBVariable to remove the object once you
// are done retrieving it, or else the DB will bloat. 
object RetrieveCampaignDBObject(object oPC, string sVarname, location lLoc, object oInventory=OBJECT_INVALID)
{
    object oOwner = oInventory;
    if (!GetIsObjectValid(oOwner))
        oOwner = oPC;

    return RetrieveCampaignObject(GetCampaignDBName(), 
                                  sVarname, 
                                  lLoc, 
                                  oOwner, 
                                  oPC);
}

// Delete a campaign variable
void DeleteCampaignDBVariable(object oPC, string sVarname)
{
    DeleteCampaignVariable(GetCampaignDBName(), sVarname, oPC);
}


// for compilation testing
/*  void main() {} /* */
