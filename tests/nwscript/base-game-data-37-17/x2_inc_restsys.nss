//::///////////////////////////////////////////////
//:: Hordes of the Underdark RestSystem
//:: x2_inc_restsys
//::
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Wandering Monster Restsystem Include
    ------------------------------------

    Please refer to Wandering Monster System.doc n XP2 VSS

    Please see wandering monster test.mod for implementation
    examples / test cases.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-29
//:: LastUpdate: 2003-10-20 v1.4
//:://////////////////////////////////////////////

// * Default 2DA Name to look data up. Can be overwritten with a global variable
// * named X2_WM_2DA_NAME on the module to point to a different 2da
const string X2_WM_2DA_NAME = "des_restsystem";

// * If an object with this tag is found, monsters will spawn from there
// * if they cannot find a door or the door system is disabled
const string X2_WM_SPAWNSPOT_TAG = "x2_restsys_spawn";

// * This event is sent to the spawnspot placeable to allow it to play a
// * certain animation when monsters spawn in
const int X2_WM_SPAWNSPOT_EVENTID = 2011;

// * Minimum time between spawns in seconds (default = 60.0f)
const float X2_WM_FLOOD_PROTECTION_PERIOD = 10.0f;

const int X2_WMT_INVALID_TABLE = 0;                  // Row number of NO_TABLE_SETTable

const int X2_WMT_DEFAULT_FEEDBACK_FAIL = 83306;      // Default StrRef when failing listen check check
const int X2_WMT_DEFAULT_FEEDBACK_SUCCESS = 83307;   // Default StrRef when succeeding listen check

struct wm_struct
{
    string sTable;
    string sMonsterNight1;
    string sMonsterNight2;
    string sMonsterNight3;
    string sMonsterDay1;
    string sMonsterDay2;
    string sMonsterDay3;
    int    nProbNight1;
    int    nProbNight2;
    int    nProbDay1;
    int    nProbDay2;
    int    nListenCheckDC;
    int    nFeedBackStrRefSuccess;
    int    nFeedBackStrRefFail;
    int    nProbabilityDay;
    int    nProbabilityNight;
    int    nRowNumber;
};
//------------------------------------------------------------------------------
//                    * * *   P R O T O T Y P E S * * *
//------------------------------------------------------------------------------


// * Change the probability of encountering a wandering monster for an area
//   oArea - the Area
//   sTableName - The name of the encounter table (TableName Column in 2da)
//
// * NOTE: You can call WMSetAreaProbability later to change the probability
//       of having an encounter
void WMSetAreaProbability(object oArea, int nDayPercent, int nNightPercent);

// *  Call this to define the encounter table to use with the wandering monster
// *  system.
//  oArea - the Area
//  sTableName - The name of the encounter table (TableName Column in 2da)
//  bUseDoors -  Monsters will spawn behind the next not-locked door, open them
//               and move onto the pc (default = TRUE )
//  nListenCheckDC - The DC to beat in an listen check in order to wake up early.
//                  (default = -1, use value in 2da)
//
// *  NOTE: You can call WMSetAreaProbability later to change the probability
//    of having an encounter
void WMSetAreaTable(object oArea, string sTableName, int bUseDoors = FALSE, int nListenCheckDC = -1);

// * Returns TRUE if oArea has a wandering monster table set. Use WMSetAreaTable to
// * set a wandering monster table on an area
int WMGetAreaHasTable(object oArea);

// * Returns TRUE if a X2_L_WM_USE_APPEAR_ANIMATIONS has been set to TRUE on the area
// * making all creatures appearing within use their appear animations
int WMGetUseAppearAnimation(object oArea);

// * Returns TRUE if oArea has the Wandering Monster System disabled
int WMGetWanderingMonstersDisabled(object oArea);

// * Sets if oArea has the Wandering Monster System disabled
void WMSetWanderingMonstersDisabled(object oArea, int bDisabled = FALSE );

// * Wandering Monster System, Check for wandering
// * monster
//   oPC - the player who triggered the check
//
// * This will check if the player has triggered a wandering monster
// * and return TRUE if yes.
//
// * To be used in the OnRest event handler.  It will also setup the
// * encounter so if ExecuteScript (DoWanderingMonster) is called on
// * a PC, the encounter will start.
int WMCheckForWanderingMonster(object oPC);


// *  Reads all encounter tables from 2da
// *  specified in X2_WM_2DA_NAME and caches them
// *  to LocalVariables to speed up access to them.
// *  This function is intended to be used
// *  in an OnModuleLoad event script
void WMBuild2DACache();

// * Setup the necessary variables for the x2_restsys_ambus script
// * You probably won't ever need this function as it is used internally by the system, but you could
// * use it to build your own monster ambush (just call WMRunAmbush() to execute)
//     oPC - The player to be ambushed
//     sMonsters - one or more monster ResRefs, comma seperated with no whitespaces in between
// * Examples:
//     WMSetupAmbush(GetEnteringObject(), "nw_dog,nw_dog") for multiple enemies
//     WMSetupAmbush(GetEnteringObject(), "nw_badger") for a single enemy
void WMSetupAmbush(object oPC, string sMonsters);

// * This command runs the actual wandering monster ambush on the pc, using the data stored
// * by WMSetupAmbush. It is called by x2_restsys_ambus.nss.
void WMRunAmbush(object oPC);

// * Placeholder at the moment - handles sleep and multiplayer code
// * If an ambush is in progress it will return FALSE so resting can be disabled
// * Fades Screen to Black for PC
int WMStartPlayerRest(object oPC);

// * Removes the cutscene blackness, etc
// * Called after a rest is done from OnPlayerRest Event
void WMFinishPlayerRest(object oPC, int bRestCanceled = FALSE)   ;

// * Returns the DC to beat in a listen check to wake up. Its defined in the 2da
// * but can be overwritten in WMSetAreaTable)
int WMGetAreaListenCheck(object oArea);

// * Do a listen check against the designer defined DC for waking up in that area
// * See WMSetAreaTable() on how to set the DC.
// * Returns TRUE if check was successful
int WMDoListenCheck(object oPC);

//------------------------------------------------------------------------------
//                  * * *   I M P L E M E N T A T I O N * * *
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//                           Private Functions
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Get a 2da String or the supplied default if string is empty
//------------------------------------------------------------------------------
string Get2DAStringOrDefault(string s2DA, string sColumn, int nRow, string sDefault)
{
    string sRet;
    sRet =Get2DAString(s2DA, sColumn, nRow);
    if (sRet == "****" || sRet == "")
    {
        sRet = sDefault;
    }
    return sRet;

}

//------------------------------------------------------------------------------
// Debug Output, remove all calls to this for version
//------------------------------------------------------------------------------
void WMDebug (string sWrite)
{
   // WriteTimestampedLogEntry("***WM Debug: "+sWrite);
}

//------------------------------------------------------------------------------
// Retrieve the 2da to use for the system
//------------------------------------------------------------------------------
string WMGet2DAToUse()
{
    //Check if the user has overwritten the 2da to use
    string s2DA = GetLocalString(GetModule(),"X2_WM_2DA_NAME");
    if (s2DA == "")
    {
       s2DA = X2_WM_2DA_NAME;     // Not overwritten, take default (defined in the header of this file)
    }
    return s2DA;
}

//------------------------------------------------------------------------------
// This function returns a wm_struct of the row number currently set in LocalInt
// X2_WM_ROWSCANPTR
// on the Module. if bAllData is true, it will read all columns of the 2da, if not,
// it will just return the RowNumber and Probability columns.
// This is the place where data gets read from the 2da... the only place
//
// Use after GetFirstWMTableEntry until wm_struct.nRowNumber = -1
//------------------------------------------------------------------------------
struct wm_struct GetNextWMTableEntry(int bAllData = FALSE)
{
    //--------------------------------------------------------------------------
    // Determine which 2da to load
    //--------------------------------------------------------------------------
    string s2DA = WMGet2DAToUse();

    //--------------------------------------------------------------------------
    // Which row to start from...
    //--------------------------------------------------------------------------
    int nCurRow = GetLocalInt(GetModule(),"X2_WM_ROWSCANPTR");
    struct wm_struct stRet;

    stRet.sTable = GetStringLowerCase(Get2DAString(s2DA, "TableName", nCurRow));

    if (stRet.sTable == "") // last record, end
    {
        stRet.nRowNumber = -1 ;
        return stRet;
    }
    stRet.nProbabilityDay = StringToInt(Get2DAString(s2DA, "DayBaseProbability", nCurRow));
    stRet.nProbabilityNight = StringToInt(Get2DAString(s2DA, "NightBaseProbability", nCurRow));
    stRet.nListenCheckDC = StringToInt(Get2DAString(s2DA, "ListenCheckDC", nCurRow));
    if (bAllData) // if requested, return all other lines in the struct as well ... slooow
    {
        stRet.sMonsterDay1 = Get2DAString(s2DA, "DAY_ResRef1", nCurRow);
        stRet.sMonsterDay2 = Get2DAString(s2DA, "DAY_ResRef2", nCurRow);
        stRet.sMonsterDay3 = Get2DAString(s2DA, "DAY_ResRef3", nCurRow);
        stRet.sMonsterNight1 = Get2DAString(s2DA, "NIGHT_ResRef1", nCurRow);
        stRet.sMonsterNight2 = Get2DAString(s2DA, "NIGHT_ResRef2", nCurRow);
        stRet.sMonsterNight3 = Get2DAString(s2DA, "NIGHT_ResRef3", nCurRow);

        //----------------------------------------------------------------------
        // Get the probability for monster type 1 and 2, if not supplied take 33%
        //----------------------------------------------------------------------
        stRet.nProbNight1 = StringToInt(Get2DAStringOrDefault(s2DA, "NIGHT_Prob1", nCurRow,"33"));
        stRet.nProbNight2 = StringToInt(Get2DAStringOrDefault(s2DA, "NIGHT_Prob2", nCurRow,"33"));
        stRet.nProbDay1= StringToInt(Get2DAStringOrDefault(s2DA, "DAY_Prob1", nCurRow,"33"));
        stRet.nProbDay2= StringToInt(Get2DAStringOrDefault(s2DA, "DAY_Prob2", nCurRow,"33"));

        //----------------------------------------------------------------------
        // Listen Check Notices
        //----------------------------------------------------------------------
        stRet.nFeedBackStrRefSuccess = StringToInt(Get2DAStringOrDefault(s2DA, "FeedBackStrRefSuccess", nCurRow,IntToString(X2_WMT_DEFAULT_FEEDBACK_SUCCESS))); ;
        stRet.nFeedBackStrRefFail = StringToInt(Get2DAStringOrDefault(s2DA, "FeedBackStrRefFail", nCurRow,IntToString(X2_WMT_DEFAULT_FEEDBACK_FAIL))); ;

    }
    stRet.nRowNumber = nCurRow;
    nCurRow++;
    SetLocalInt(GetModule(),"X2_WM_ROWSCANPTR",nCurRow); // point to the next row
    return stRet;
}

struct wm_struct GetFirstWMTableEntry(int bAllData = FALSE)
{
  SetLocalInt(GetModule(),"X2_WM_ROWSCANPTR",0); // set the pointer to the first row
  return  GetNextWMTableEntry(bAllData);
}

//------------------------------------------------------------------------------
// returns a FULL Data wm_struct of row nNo from the wandering monster 2da file
//------------------------------------------------------------------------------
struct wm_struct GetWMTableEntryByIndex(int nNo)
{
  SetLocalInt(GetModule(),"X2_WM_ROWSCANPTR",nNo);
  return  GetNextWMTableEntry(TRUE);
}

//------------------------------------------------------------------------------
// return a wm_struct of the data in the row with TableName sName in the 2da
//------------------------------------------------------------------------------
struct wm_struct GetWMStructByName(string sName, int bAllData = FALSE)
{
    struct wm_struct stRet;
    sName = GetStringLowerCase(sName);
    // check if there is a cached 2da row with this name
    if (GetLocalInt(GetModule(),"X2_WM_TABLE_" + sName + "_ROWNR") != X2_WMT_INVALID_TABLE)
    {
        stRet.nRowNumber = GetLocalInt(GetModule(),"X2_WM_TABLE_" + sName+ "_ROWNR");
        stRet.nProbabilityDay = GetLocalInt(GetModule(),"X2_WM_TABLE_" + sName+ "_PROBDAY");
        stRet.nProbabilityNight = GetLocalInt(GetModule(),"X2_WM_TABLE_" + sName+ "_PROBNIGHT");

        // in case all data is requested, read them from the 2da
        if (bAllData)
        {
            int nRow = stRet.nRowNumber;
            stRet = GetWMTableEntryByIndex(nRow); // fetch full data from 2da
        }

        return stRet;
    }
    else
    {
        stRet.nRowNumber = X2_WMT_INVALID_TABLE;
        stRet.nProbabilityDay = 0;
        stRet.nProbabilityNight = 0;
        return stRet;
    }
}

//------------------------------------------------------------------------------
// Georg Zoeller, 2003-05-29
// Reads all encounter tables from 2da specified in X2_WM_2DA_NAME and caches
// them to LocalVariables to speed up access to them.
// This function is intended to be used an OnModuleLoad event script
//------------------------------------------------------------------------------
void WMBuild2DACache()
{
    struct wm_struct stEntry = GetFirstWMTableEntry();
    object oArea;
    int nCount;
    while (stEntry.nRowNumber != -1) // while there are still records matching
    {

        SetLocalInt(GetModule(),"X2_WM_TABLE_" + stEntry.sTable+ "_ROWNR", stEntry.nRowNumber );
        SetLocalInt(GetModule(),"X2_WM_TABLE_" + stEntry.sTable+ "_PROBDAY",stEntry.nProbabilityDay);
        SetLocalInt(GetModule(),"X2_WM_TABLE_" + stEntry.sTable+ "_PROBNIGHT",stEntry.nProbabilityNight);
        nCount++;
        stEntry = GetNextWMTableEntry();
    }

    //WMDebug("WMBuild2DACache() cached " + IntToString(nCount)+ " area names ");

}

//------------------------------------------------------------------------------
// Returns a wm_struct containing the full wandering monster table
// for the selected area.
//------------------------------------------------------------------------------
struct wm_struct WMGetAreaMonsterTable(object oArea)
{
    struct wm_struct stTable;
    int nTable =     GetLocalInt(oArea,"X2_WM_AREA_TABLE");
    stTable = GetWMTableEntryByIndex(nTable);
    return stTable;
}

//------------------------------------------------------------------------------
// Returns a string containing or more wandering monsters
// from the encounter table currently active for oPC's area
//------------------------------------------------------------------------------
string WMGetWanderingMonsterFrom2DA(object oPC)
{
    struct wm_struct stTable;
    stTable = WMGetAreaMonsterTable(GetArea(oPC));
    string sMonster;
    int nProb1;
    int nProb2;

    if (GetIsDay())
    {

        nProb1     = stTable.nProbDay1;
        nProb2     = stTable.nProbDay2;

        // determine which monster to spawn based on the probablility
        if(d100() < nProb1)
            sMonster = stTable.sMonsterDay1;
        else if (d100() < nProb2)
            sMonster = stTable.sMonsterDay2;
        else
            sMonster = stTable.sMonsterDay3;

    }
    else
    {
        nProb1     = stTable.nProbNight1;
        nProb2     = stTable.nProbNight2;

        // determine which monster to spawn based on the probablility
        if(d100() < nProb1)
            sMonster = stTable.sMonsterNight1;
        else if (d100() < nProb2)
            sMonster = stTable.sMonsterNight2;
        else
            sMonster = stTable.sMonsterNight3;
    }

    return sMonster;
}

//------------------------------------------------------------------------------
// Calulates the best ambush spot for the monster's using the area preset values
// If a placeable/waypoint is found, it will be stored as object in
// X2_WM_AMBUSH_SPOT for later retrival
// If a door is used as spawnspot, it will be stored in X2_WM_AMBUSH_DOOR
// for later retrieval
//------------------------------------------------------------------------------
location WMGetAmbushSpot(object oPC)
{

   //---------------------------------------------------------------------------
   // Check for designer marked spawnspots
   //---------------------------------------------------------------------------
   object oSpot = GetNearestObjectByTag(X2_WM_SPAWNSPOT_TAG, oPC);

   //---------------------------------------------------------------------------
   // Found a spot and is that spot near enough?
   //---------------------------------------------------------------------------
   if (oSpot != OBJECT_INVALID && GetDistanceBetween(oSpot,oPC) < 25.0f )
   {
        SetLocalObject(oPC,"X2_WM_AMBUSH_SPOT",oSpot);
        return GetLocation(oSpot);
   }

    //--------------------------------------------------------------------------
    // check if the designer has enabled the use of doors
    //--------------------------------------------------------------------------

    int bUseDoors = GetLocalInt(GetArea(oPC),"X2_WM_AREA_USEDOORS");
    if (bUseDoors)
    {
        //----------------------------------------------------------------------
        // this tries to get the nearest door to the PC which is in line of sight.
        //----------------------------------------------------------------------
        object oDoor = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC), TRUE, OBJECT_TYPE_DOOR );
        object oDoor2 = GetNextObjectInShape(SHAPE_SPHERE, 20.0f,GetLocation(oPC),TRUE,OBJECT_TYPE_DOOR);

        if (oDoor2 != OBJECT_INVALID) // just see if the second door is better suited for an ambush
        {
            if (GetDistanceBetween(oDoor,oPC)> GetDistanceBetween(oDoor2,oPC) || GetLocked(oDoor) || GetPlotFlag(oDoor) )
                oDoor= oDoor2;
        }

        //----------------------------------------------------------------------
        // Check if the selected door
        //----------------------------------------------------------------------
        if (GetIsObjectValid(oDoor) /* && LineOfSightObject(oPC, oDoor)*/)
        {
            if ( !GetLocked(oDoor) && !GetPlotFlag(oDoor))
            {
                vector vDoor = GetPositionFromLocation(GetLocation(oDoor));
                vector vPC =  GetPositionFromLocation(GetLocation(oPC));
                vector vNew = vDoor;

                //--------------------------------------------------------------
                // Try to calculate a spot right behind the door on the opposite
                // side of the player
                //--------------------------------------------------------------
                if (vPC.x > vDoor.x)
                    vNew.x -= 0.8;
                else
                     vNew.x +=0.8;

                if (vPC.y> vDoor.y)
                    vNew.y -= 0.8;
                else
                    vNew.y += 0.8;

                location lLoc = Location(GetArea(oDoor),vNew,GetFacing(oDoor));
                SetLocalObject(oPC, "X2_WM_AMBUSH_DOOR", oDoor);
                location lRet = lLoc;
                return lRet;
           }
        }
    }

   //---------------------------------------------------------------------------
   // everything failed, so we just report the location of the PC
   //---------------------------------------------------------------------------

   SetLocalInt(oPC, "X2_WM_AMBUSH_ON_TOP_OF_PLAYER", TRUE);
   //SendMessageToPC(oPC,"**WM-Debug: Ambush will use player location");
   return GetLocation(oPC);

}

// -----------------------------------------------------------------------------
// External Functions
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Setup the necessary variables for the x2_restsys_ambus script
// You probably won't ever need this function as it is used internally by the
// system, but you could use it to build your own monster ambush
// (just call WMRunAmbush() to execute)
// oPC - The player to be ambushed
// sMonsters - one or more monster ResRefs, comma seperated with no whitespaces in between
// Examples:
//   WMSetupAmbush(GetEnteringObject(), "nw_dog,nw_dog") for multiple enemies
//   WMSetupAmbush(GetEnteringObject(), "nw_badger") for a single enemy
//------------------------------------------------------------------------------

void WMSetupAmbush(object oPC, string sMonsters)
{
    SetLocalString(oPC,"X2_WM_AMBUSH",sMonsters);

    //--------------------------------------------------------------------------
    // Prevent Player to rest while ambush is running
    // This is cleared in WMRunAmbush()!
    //--------------------------------------------------------------------------
    SetLocalInt(oPC,"X2_WM_AMBUSH_IN_PROGRESS",TRUE);
}

//------------------------------------------------------------------------------
// I had to make this a seperate function in order to delay it
// It is just called from inside WMRunAmbush
//------------------------------------------------------------------------------
void WMSpawnAmbushMonsters(object oPC, location lSpot)
{
    string sMonsters =  GetLocalString(oPC,"X2_WM_AMBUSH");
    DeleteLocalString(oPC,"X2_WM_AMBUSH");

    //--------------------------------------------------------------------------
    // Check if this ambush is occuring on top of the player's head
    //--------------------------------------------------------------------------
    int bOnTop =   GetLocalInt(oPC, "X2_WM_AMBUSH_ON_TOP_OF_PLAYER");
    DeleteLocalInt(oPC, "X2_WM_AMBUSH_ON_TOP_OF_PLAYER");

    string sTemp;
    object oMonster;
    int nMonsterCount =0;

    //--------------------------------------------------------------------------
    // since sMonsters can contain comma seperated monsters, we are going to
    // explode the list here....
    //--------------------------------------------------------------------------
    int nPos = FindSubString(sMonsters,",");
    object oDoor = GetLocalObject(oPC, "X2_WM_AMBUSH_DOOR");
     int bSpawnAnimation = FALSE;
     if (bOnTop)
     {
        if (WMGetUseAppearAnimation(GetArea(oPC)))
        {
            bSpawnAnimation = TRUE;
        }
    }

    //--------------------------------------------------------------------------
    // Create all creatures but the first
    //--------------------------------------------------------------------------
    while (nPos!= -1) // comma in remaining sMonster?
    {
        sTemp = GetSubString(sMonsters,0,nPos);
        sMonsters = GetSubString(sMonsters,nPos+1, GetStringLength(sMonsters) - GetStringLength(sTemp)-1);
        oMonster = CreateObject(OBJECT_TYPE_CREATURE,sTemp,lSpot,bSpawnAnimation);
        AssignCommand(oMonster, SetFacing(GetFacing(oPC)));
        nPos = FindSubString(sMonsters,",");

        //----------------------------------------------------------------------
        // If there is a door to open, have the last monster do it ...
        // this may trigger a trap the pc has set to secure his resting place
        //----------------------------------------------------------------------
        if (oDoor != OBJECT_INVALID)
        {
            AssignCommand(oMonster,ActionOpenDoor(oDoor));
            DeleteLocalObject(oPC,"X2_WM_AMBUSH_DOOR");
        }
        AssignCommand(oMonster, ActionMoveToObject(oPC,TRUE));
    }
    //--------------------------------------------------------------------------
    // Create the first Creature
    //--------------------------------------------------------------------------
    oMonster = CreateObject(OBJECT_TYPE_CREATURE,sMonsters,lSpot,bSpawnAnimation);
    if (oDoor != OBJECT_INVALID)
    {
        AssignCommand(oMonster,ActionOpenDoor(oDoor));
        DeleteLocalObject(oPC,"X2_WM_AMBUSH_DOOR");
    }
    AssignCommand(oMonster, ActionMoveToObject(oPC,TRUE));

    //--------------------------------------------------------------------------
    // Allow Resting again
    //--------------------------------------------------------------------------
    DeleteLocalInt(oPC,"X2_WM_AMBUSH_IN_PROGRESS");
}

//------------------------------------------------------------------------------
// This runs the actual wandering monster ambush on the pc, using the data stored
// by WMSetupAmbush.
//------------------------------------------------------------------------------
void WMRunAmbush(object oPC)
{
    //--------------------------------------------------------------------------
    // Get the best location from which to attack the player
    //--------------------------------------------------------------------------
    location lSpot = WMGetAmbushSpot(oPC);

    object oSpot = GetLocalObject(oPC,"X2_WM_AMBUSH_SPOT");
    if (GetIsObjectValid(oSpot))
    {
        event eUser = EventUserDefined(X2_WM_SPAWNSPOT_EVENTID);
        SignalEvent(oSpot,eUser);
        DeleteLocalObject(oPC, "X2_WM_AMBUSH_SPOT");
    }
    //--------------------------------------------------------------------------
    // Brent: Removed Delay
    // DelayCommand(2.5f,WMSpawnAmbushMonsters(oPC, lSpot));
    //--------------------------------------------------------------------------
    // * remove ddelay (brent) from

    //--------------------------------------------------------------------------
    // Do the ambush
    //--------------------------------------------------------------------------
    WMSpawnAmbushMonsters(oPC, lSpot);
}


//------------------------------------------------------------------------------
// Georg Zoeller,  2003-05-29
// Wandering Monster System, Check for wandering
// monster
//   oPC - the player who triggered the check
//
// This will check if the player has triggered a
// wandering monster and return TRUE if yes.
//
// To be used in the OnRest event handler.
// It will also setup the encounter so if
// ExecuteScript (DoWanderingMonster) is called on
// a PC, the encounter will start.
//
// Has integrated flood protection to prevent
// more than one encounter in X2_WM_FLOODPROTPERIOD
// seconds (see header)
//------------------------------------------------------------------------------
int WMCheckForWanderingMonster(object oPC)
{

    if (WMGetWanderingMonstersDisabled(GetArea(oPC)))
    {
        return FALSE;
    }
    //--------------------------------------------------------------------------
    // we just had one encounter, we dont want another right now!
    //--------------------------------------------------------------------------
    if (GetLocalInt(GetArea(oPC),"X2_WM_AREA_FLOODPROTECTION"))
    {
        return FALSE;
    }

    int nProb;

    //--------------------------------------------------------------------------
    // Get the probability for a wandering monster depending on the time of day
    //--------------------------------------------------------------------------
    if (GetIsDay())
    {
        nProb = GetLocalInt(GetArea(oPC),"X2_WM_AREA_PROBDAY");
    }
    else
    {
        nProb = GetLocalInt(GetArea(oPC),"X2_WM_AREA_PROBNIGHT");
    }

    if (nProb > d100())
    {
       string sMonster = WMGetWanderingMonsterFrom2DA(oPC);
       WMSetupAmbush (oPC,sMonster);

       //-----------------------------------------------------------------------
       // Flood Protection to prevent lots of spawns
       //-----------------------------------------------------------------------
       SetLocalInt(GetArea(oPC),"X2_WM_AREA_FLOODPROTECTION",TRUE);
       DelayCommand(X2_WM_FLOOD_PROTECTION_PERIOD,DeleteLocalInt(GetArea(oPC),"X2_WM_AREA_FLOODPROTECTION"));
       return TRUE;
    }

   return FALSE;

}

//------------------------------------------------------------------------------
// Wandering Monster System, Set the Wandering Monster Table for an Area
//  oArea         - the Area
//  sTableName    - The name of the encounter table (TableName Column in 2da)
//  bUseDoors     - Monsters will spawn behind the next not-locked door, open them
//                  and move onto the pc (default = TRUE )
// nListenCheckDC - The DC to beat in an listen check in order to wake up early.
//                  (default = -1, use value in 2da)
//
// NOTE: You can call WMSetAreaProbability later to change the probability
//       of having an encounter
//------------------------------------------------------------------------------
void WMSetAreaTable(object oArea, string sTableName, int bUseDoors = FALSE, int nListenCheckDC = 0)
{
    struct wm_struct stTbl = GetWMStructByName(sTableName);
    SetLocalInt(oArea,"X2_WM_AREA_TABLE",stTbl.nRowNumber);
    SetLocalInt(oArea,"X2_WM_AREA_PROBDAY",stTbl.nProbabilityDay);
    SetLocalInt(oArea,"X2_WM_AREA_PROBNIGHT",stTbl.nProbabilityNight);
    SetLocalInt(oArea,"X2_WM_AREA_USEDOORS",bUseDoors);

    // get 2da defined listen check...
    if (nListenCheckDC == 0)
    {
        nListenCheckDC = stTbl.nListenCheckDC;
    }

    SetLocalInt(oArea,"X2_WM_AREA_LISTENCHECK", nListenCheckDC);


    //WMDebug("Set encounter table " + sTableName + "(" + IntToString(stTbl.nRowNumber) + ") on area " +GetName(oArea) );
}

//------------------------------------------------------------------------------
// Wandering Monster System, set area probability for encountering wandering monsters on rest
//   oArea - Self Explaining
//   nDayPercent, nNightPercent - Percentage chance for encounter on resting
//   NOTE: If you change the encounter Table via WMSetAreaTable, probabilities for the area
//         are reset to their default values specified in the 2da.
//------------------------------------------------------------------------------
void WMSetAreaProbability(object oArea, int nDayPercent, int nNightPercent)
{
    if (WMGetAreaHasTable(oArea)) // if there is an encounter table set....
    {
        SetLocalInt(oArea,"X2_WM_AREA_PROBDAY", nDayPercent);
        SetLocalInt(oArea,"X2_WM_AREA_PROBNIGHT", nNightPercent);
    }
}

//------------------------------------------------------------------------------
// Returns TRUE if oArea has an encounter table set
//------------------------------------------------------------------------------
int WMGetAreaHasTable(object oArea)
{
    return (GetLocalInt(oArea,"X2_WM_AREA_TABLE"));
}

//------------------------------------------------------------------------------
// Returns TRUE if oArea has the Wandering Monster System disabled
//------------------------------------------------------------------------------
int WMGetWanderingMonstersDisabled(object oArea)
{
    return (GetLocalInt(oArea,"X2_WM_DISABLED"));
}

//------------------------------------------------------------------------------
// Sets if oArea has the Wandering Monster System disabled
//------------------------------------------------------------------------------
void WMSetWanderingMonstersDisabled(object oArea, int bDisabled = FALSE )
{
    SetLocalInt(oArea,"X2_WM_DISABLED",bDisabled);
}

//------------------------------------------------------------------------------
// Will make the party of the character rest as long as everyone is in the
// same area currently not useds
//------------------------------------------------------------------------------
void WMMakePartyRest(object oPC)
{
        object oMember = GetFirstFactionMember(oPC, TRUE);
        {
            if (GetArea(oPC) == GetArea(oMember))
            {
                AssignCommand(oMember,ActionRest());
            }
        }
}

//------------------------------------------------------------------------------
// Player Rest code
// Fades Screen to Black for PC, applies sleep vfx
// If an ambush is in progress it will return FALSE so resting can be disabled
//------------------------------------------------------------------------------
int WMStartPlayerRest(object oPC)
{
    if  (GetLocalInt(oPC,"X2_WM_AMBUSH_IN_PROGRESS"))
    {
        // do not allow to sleep when an ambush is already in progress
        return FALSE;
    }
    effect eSleep = EffectVisualEffect(VFX_IMP_SLEEP);
     ApplyEffectToObject(DURATION_TYPE_INSTANT,eSleep, oPC);
    DelayCommand(0.1,FadeToBlack(oPC,FADE_SPEED_FAST));
    DelayCommand(2.6, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
    return TRUE;
}

//------------------------------------------------------------------------------
// Remove the cutscene blackness, etc
// Called after a rest is done from OnPlayerRest Event
//------------------------------------------------------------------------------
void WMFinishPlayerRest(object oPC, int bRestCanceled = FALSE)
{
    FadeFromBlack(oPC,FADE_SPEED_MEDIUM);  // Finish Resting (canceled)
}

//------------------------------------------------------------------------------
// Returns the DC to beat in a listen check to wake up. Its defined in the 2da
// but can be overwritten in WMSetAreaTable)
//------------------------------------------------------------------------------
int WMGetAreaListenCheck(object oArea)
{
    if (!GetIsObjectValid(oArea))
    {
        return 15; // return default
    }
    int nDC = GetLocalInt(oArea,"X2_WM_AREA_LISTENCHECK");    // this int is stored by WMSetAreaTable
    return nDC;
}

//------------------------------------------------------------------------------
// Do a listen check against the designer defined DC for waking up in that area
// See WMSetAreaTable() on how to set the DC.
//------------------------------------------------------------------------------
int WMDoListenCheck(object oPC)
{
    object oArea = GetArea(oPC);
    int nDC = WMGetAreaListenCheck(oArea);

    // some sanity checks
    if (nDC < 1 || nDC > 255 )
    {
        nDC = 15;  // return default
    }
    int nRet = (GetIsSkillSuccessful(oPC,SKILL_LISTEN,nDC) == TRUE);
    return nRet;
}

//------------------------------------------------------------------------------
// Returns TRUE if appear animations are used when monsters are spawned by
// the system.
//------------------------------------------------------------------------------
int WMGetUseAppearAnimation(object oArea)
{
    return GetLocalInt(oArea,"X2_L_WM_USE_APPEAR_ANIMATIONS");
}
