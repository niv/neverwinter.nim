//::///////////////////////////////////////////////
//:: x0_i0_db
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file is an include wrapper for all
    the database functions, to provide any
    additional uniqueness support that may be required.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


// * retrieve float
float    dbGetCampaignFloat(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);
int      dbGetCampaignInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);
location dbGetCampaignLocation(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);
string   dbGetCampaignString(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);
vector   dbGetCampaignVector(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Campaign variable table database control.
// Use the set functions to add/change a variable to a campaign database.
// Use the get functions to retrieve the variable from a campaign database
// Use the delete functions to remove the variable from a campaign database.
// The database name must be the same for both set and get functions. It IS case sensitive.
// The var name must be unique acrossed the entire database.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void dbSetCampaignFloat(string sCampaignName, string sVarName, float flFloat,    object oPlayer=OBJECT_INVALID);
void dbSetCampaignInt(string sCampaignName, string sVarName, int nInt,         object oPlayer=OBJECT_INVALID);
void dbSetCampaignLocation(string sCampaignName, string sVarName, location locLocation, object oPlayer=OBJECT_INVALID);
void dbSetCampaignString(string sCampaignName, string sVarName, string sString,   object oPlayer=OBJECT_INVALID);
void dbSetCampaignVector(string sCampaignName, string sVarName, vector vVector,   object oPlayer=OBJECT_INVALID);

// Stores an object with the given id.
// Returns 0 if it failled, 1 if it worked.
int    dbStoreCampaignObject(string sCampaignName, string sVarName, object oObject, object oPlayer=OBJECT_INVALID);
// Use RetrieveCampaign with the given id to restore it.
// If you specify an owner, the object will try to be created in their repository
// If the owner can't handle the item (or if it's a creature) it will be created on the ground.
object dbRetrieveCampaignObject(string sCampaignName, string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID);

// * definitions


float    dbGetCampaignFloat(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    return GetCampaignFloat(sCampaignName, sVarName, oPlayer);
}

int      dbGetCampaignInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    return GetCampaignInt(sCampaignName, sVarName, oPlayer);
}

location dbGetCampaignLocation(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    return GetCampaignLocation(sCampaignName, sVarName, oPlayer);
}
string   dbGetCampaignString(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    return GetCampaignString(sCampaignName, sVarName, oPlayer);
}
vector   dbGetCampaignVector(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    return GetCampaignVector(sCampaignName, sVarName, oPlayer);
}


void dbSetCampaignFloat(string sCampaignName, string sVarName, float flFloat,    object oPlayer=OBJECT_INVALID)
{
    SetCampaignFloat(sCampaignName, sVarName, flFloat, oPlayer);
}
void dbSetCampaignInt(string sCampaignName, string sVarName, int nInt,         object oPlayer=OBJECT_INVALID)
{
    SetCampaignInt(sCampaignName, sVarName, nInt, oPlayer);
}
void dbSetCampaignLocation(string sCampaignName, string sVarName, location locLocation, object oPlayer=OBJECT_INVALID)
{
    SetCampaignLocation(sCampaignName, sVarName, locLocation, oPlayer);
}
void dbSetCampaignString(string sCampaignName, string sVarName, string sString,   object oPlayer=OBJECT_INVALID)
{
    SetCampaignString(sCampaignName, sVarName, sString, oPlayer);
}
void dbSetCampaignVector(string sCampaignName, string sVarName, vector vVector,   object oPlayer=OBJECT_INVALID)
{
    SetCampaignVector(sCampaignName, sVarName, vVector, oPlayer);
}
// Use RetrieveCampaign with the given id to restore it.
// If you specify an owner, the object will try to be created in their repository
// If the owner can't handle the item (or if it's a creature) it will be created on the ground.
object dbRetrieveCampaignObject(string sCampaignName, string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID)
{
    return RetrieveCampaignObject(sCampaignName, sVarName, locLocation, oOwner, oPlayer);
}
// Stores an object with the given id.
// Returns 0 if it failled, 1 if it worked.
int    dbStoreCampaignObject(string sCampaignName, string sVarName, object oObject, object oPlayer=OBJECT_INVALID)
{
    return StoreCampaignObject(sCampaignName, sVarName, oObject, oPlayer);
}

