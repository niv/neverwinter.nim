//::///////////////////////////////////////////////
//:: NW_I0_HENCHMAN
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This is the include file for the
   henchmen who can join the player.

   ASSUMPTION: All these functions
   are meant to be ran by the henchman.
   OBJECT_SELF is assumed to be the henchman.

   RULES: Henchman are dialog controlled only!
   No locals/globals should be set outside of the
   henchman's own dialog file!
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  February 2002
//:://////////////////////////////////////////////

// * ---------
// * CONSTANTS
// * ---------

     // * CHAPTER INDEX
     /*
        0 = Prelude
        1 = Chapter 1
        2 = Chapter 2
        3 = Chapter 3
        4 = Chapter 4
        5 = Chapter 1 End, if necessary
        6 = Chapter 2 End, if necessary
     */

    //  * Tag Declaration
    const string sDaelinTag = "NW_HEN_DAE";
        // * Personal Item Named = NW_HEN_DAEPERS
        // * Chapter 1 Quest Item =  NW_HEN_DAE1QT  ; reward NW_HEN_DAE1RW
        // * Chapter 2 Quest Item =  NW_HEN_DAE2QT  ; reward NW_HEN_DAE2RW
        // * Chapter 3 Quest Item =  NW_HEN_DAE3QT  ; reward NW_HEN_DAE3RW
    const string sSharwynTag = "NW_HEN_SHA";
    const string sLinuTag  =  "NW_HEN_LIN" ;
    const string sGallowTag =  "NW_HEN_GAL" ;
    const string sGrimTag    =   "NW_HEN_GRI";
    const string sBoddyTag    =  "NW_HEN_BOD";

    // * Integers
    const int INT_NUM_HENCHMEN = 6;
    const int INT_FUDGE = 3; // * used to help with figuring
                       // * out the filename to use
                       // * since the numbering for files
                       // * begins at 1 but the numbering
                       // * for levels begins at 4.

// * debug function for displaying strings. Returns the first pc in the area
object PC()
{
    return GetPCLevellingUp();
}
//::///////////////////////////////////////////////
//:: GetDidDie
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Returns true if the player has died.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
// * this is turned off again when the player talks to
// * his henchman after finding him again.
void SetDidDie(int bDie)
{
   SetLocalInt(OBJECT_SELF, "NW_L_HEN_I_DIED", bDie);
}
int GetDidDie()
{
    int oDied = GetLocalInt(OBJECT_SELF, "NW_L_HEN_I_DIED");
    if (oDied == 1)
    {
        SetLocalInt(OBJECT_SELF,  "NW_L_HEN_I_DIED", 0);
        return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: Set/GetBeenHired
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Henchmen can only be hired once, ever.
  This checks or sets the local on the henchmen
  that keeps track whether they've ever been hired.
  STORED: On Henchman
  RETURNS: Boolean
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
void SetBeenHired(int bHired=TRUE, object oTarget=OBJECT_SELF)
{
    SetLocalInt(oTarget,"NW_L_HENHIRED",10);
}
int GetBeenHired(object oTarget=OBJECT_SELF)
{
    return GetLocalInt(oTarget,"NW_L_HENHIRED") == 10;
}
// * This local is on the player
// * it is true if this particular henchman
// * is working for the player
void SetWorkingForPlayer(object oPC)
{
    SetLocalInt(oPC,"NW_L_HIRED" + GetTag(OBJECT_SELF),10);
}
int GetWorkingForPlayer(object oPC)
{
    return GetLocalInt(oPC,"NW_L_HIRED" + GetTag(OBJECT_SELF)) == 10;
}
// * Had to fix NW_CH_CHECK_37 so that it checks
// * to see if the player is the former master of the henchman

object GetFormerMaster(object oHench = OBJECT_SELF)
{
   return GetLocalObject(oHench,"NW_L_FORMERMASTER");
}
void SetFormerMaster(object oPC, object oHench)
{
   SetLocalObject(oHench,"NW_L_FORMERMASTER", oPC);
}

//::///////////////////////////////////////////////
//:: Set/GetStoryVar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  This variable keeps track of where in the 'chapter'
  story the player has made it so far.
  Since a henchman can only ever be hired by one player
  this is a local stored on the henchman.
  STORED: On Henchman
  RETURNS: Value
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
void SetStoryVar(int nChapter, int nVal, object oTarget=OBJECT_SELF)
{
    SetLocalInt(oTarget, "NW_L_HENSTORYC" + IntToString(nChapter), nVal);
}

int GetStoryVar(int nChapter, object oTarget=OBJECT_SELF)
{
    return GetLocalInt(oTarget, "NW_L_HENSTORYC" + IntToString(nChapter));
}

//::///////////////////////////////////////////////
//:: Set/GetGreetingVar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This variable keeps track of whether or
    not the player has talked to.
    STORED: On Player
    RETURNS: Boolean
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
void SetGreetingVar(int nChapter, object oPC)
{
  SetLocalInt(oPC, "NW_L_HEN"+GetTag(OBJECT_SELF) + IntToString(nChapter), 10);
}
int GetGreetingVar(int nChapter, object oPC)
{
  return GetLocalInt(oPC, "NW_L_HEN"+GetTag(OBJECT_SELF) + IntToString(nChapter)) == 10;
}

//::///////////////////////////////////////////////
//:: String Generation Functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   These functions return the various names
   of objects and stuff used by and checked by
   the henchman.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
string STR_PersonalItem(object oThing=OBJECT_SELF)
{
    return GetTag(oThing) + "PERS";
}
string STR_QuestItem(int nChapter, object oThing=OBJECT_SELF)
{
    return GetTag(oThing) + IntToString(nChapter) + "QT";
}
string STR_RewardItem(int nChapter, object oThing=OBJECT_SELF)
{
    return GetTag(oThing) + IntToString(nChapter) + "RW";
}
//::///////////////////////////////////////////////
//:: DestroyAllPersonalItems
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Will destroy any personal items that the player
  may be carrying.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
void DestroyAllPersonalItems(object oPC)
{
    string sItem = "" ;
    int i=0;
    for (i=1; i<=INT_NUM_HENCHMEN; i++)
    {
        switch (i)
        {
            case 1: sItem = sDaelinTag; break;
            case 2: sItem = sSharwynTag; break;
            case 3: sItem = sLinuTag; break;
            case 4: sItem = sGallowTag; break;
            case 5: sItem = sGrimTag; break;
            case 6: sItem = sBoddyTag; break;
        }
        object oItem = GetItemPossessedBy(oPC, sItem + "PERS");
        if (GetIsObjectValid(oItem) == TRUE)
        {
            DestroyObject(oItem);
        }
    }
}



//::///////////////////////////////////////////////
//:: Give/HasPersonalItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Every Henchman has a personal item that they
   use to recognize their previous master from other
   chapters (since no data can be transferred between
   modules).
   Will only give the item if the player does not
   already have it.

   NAMING: Personal Items must have the name
      <TAG OF HENCHMAN> + PERS
      i.e, Daelin's Personal item is
      NW_HEN_DAEPERS
   STORED: n/a
   RETURNS: Has returns BOOLEAN


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
void GivePersonalItem(object oPC, object oHench=OBJECT_SELF)
{
  //DestroyAllPersonalItems(oPC); NOW DOING THIS ON CHAPTER END (APRIL 9 2002)
  if (GetIsObjectValid(GetItemPossessedBy(oPC, STR_PersonalItem(oHench))) == FALSE)
      CreateItemOnObject(STR_PersonalItem(oHench), oPC);
}

//   JUNE 1 2002: it will now return true if you have either the personal
//   item or the chapter2 or chapter3 reward items.


int HasPersonalItem(object oPC)
{
  object oItem = GetItemPossessedBy(oPC, STR_PersonalItem());
  object oChapter1Reward = GetItemPossessedBy(oPC, STR_RewardItem(1));
  object oChapter2Reward = GetItemPossessedBy(oPC, STR_RewardItem(2));
  int iResult = FALSE;

  if (GetIsObjectValid(oItem) == TRUE || GetIsObjectValid(oChapter1Reward) == TRUE || GetIsObjectValid(oChapter2Reward) == TRUE)
  {
    iResult = TRUE;
  }

  return iResult;
}
//::///////////////////////////////////////////////
//:: StripAllPersonalItemsFromEveryone()
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Goes through all players in all areas and strips
   all personal henchmen items from them.
   It then adds the appropriate henchmen item back to them
   if they have a henchman, so that henchman can rejoin them
   in the 'end' modules.
   Where used: Chapter 1, Chapter 2, Chapter 3
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: April 9 2002
//:://////////////////////////////////////////////
void StripAllPersonalItemsFromEveryone()
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC) == TRUE)
    {
        // * Destroy all the personal items
        DestroyAllPersonalItems(oPC);
        // * create the personal item if appropriate
        // * for the henchman still with you
        object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);
        if (GetIsObjectValid(oHench) == TRUE)
        {
            DelayCommand(0.1, GivePersonalItem(oPC, oHench));
        }
        oPC = GetNextPC();
    }
}
//::///////////////////////////////////////////////
//:: Level Up Functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  These functions check if henchmen is 'capable'
  of levelling up and also can level him up
  by swapping him with a different file (always
  one level less than the player).
  Can only level up if player is 2 or more levels
  higher than henchman.
  MIN = Level 4
  MAX = Level 14
  RETURNS: Boolean
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetCanLevelUp(object oPC, object meLevel = OBJECT_SELF)
{
    int nMasterLevel = GetHitDice(oPC);
    int nMyLevel = GetHitDice(meLevel);
// * April 9 2002
// * Removed this so that if you are very high level
// * you can still ask your henchman to level up
//    if (nMasterLevel <=5 || nMasterLevel >= 16)
//    {
//        return FALSE;
//    }
    if (nMasterLevel >=  (nMyLevel + 2))
    {
        return TRUE;
    }
    return FALSE;
}
//::///////////////////////////////////////////////
//:: CopyLocals
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Copies locals from the 'earlier'
    level henchmen to the newer henchman.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////
void CopyLocals(object oSource, object oTarget)
{
//    AssignCommand(PC(), SpeakString("in here"));
//    AssignCommand(oTarget, SpeakString("I exist"));
//don't want these speakstrings, so might as well comment the whole thing out
/*
    if (GetIsObjectValid(oTarget) == FALSE)
    {
        AssignCommand(PC(), SpeakString("Target invalid"));
    }
    else
    if (GetIsObjectValid(oSource) == FALSE)
    {
        AssignCommand(PC(), SpeakString("Source invalid"));
    }
*/
  SetBeenHired(GetBeenHired(oSource), oTarget);
  SetStoryVar(1, GetStoryVar(1, oSource), oTarget);
  SetStoryVar(2, GetStoryVar(2, oSource), oTarget);
  SetStoryVar(3, GetStoryVar(3, oSource), oTarget);
  SetLocalInt(oTarget, "NW_ASSOCIATE_MASTER", GetLocalInt(oSource, "NW_ASSOCIATE_MASTER"));
//  AssignCommand(PC(),SpeakString(IntToString(GetLocalInt(oSource, "NW_ASSOCIATE_MASTER"))));
//  AssignCommand(PC(),SpeakString(IntToString(GetLocalInt(oTarget, "NW_ASSOCIATE_MASTER"))));


}
// * assumes that a succesful GetCanLevelUp has already
// * been tested.    Will level up character to one level
// * less than player.
// * meLevel defaults to object self unless another object is passed in
// * returns the new creature
object DoLevelUp(object oPC, object MeLevel = OBJECT_SELF)
{
   int nMasterLevel = GetHitDice(oPC);
   int nLevel =  nMasterLevel -1 - INT_FUDGE;


   // * Copy variables to the PC for 'safekeeping'
   CopyLocals(MeLevel, oPC);

   // * will not spawn henchmen higher than this
   // * level + INT_FUDGE (i.e., 14)
   if (nLevel > 11)
     nLevel = 11;

   // * if already the highest level henchmen
   // * then do nothing.
   if (GetHitDice(MeLevel) >= nLevel + INT_FUDGE)
   {
    return OBJECT_INVALID;
   }

   string sLevel = IntToString(nLevel);
   // * add a 0 if necessary
   if (GetStringLength(sLevel) == 1)
   {
    sLevel = "0" + sLevel;
   }
   object oMaster = GetMaster(MeLevel);
   RemoveHenchman(oMaster, MeLevel);
   string sNewFile = GetTag(MeLevel) + "_" + sLevel;
   AssignCommand(MeLevel, ClearAllActions());
   AssignCommand(MeLevel, PlayAnimation(ANIMATION_LOOPING_MEDITATE));
//   SpeakString(sNewFile);
   object oNew = CreateObject(OBJECT_TYPE_CREATURE, sNewFile, GetLocation(MeLevel), FALSE);


   AssignCommand(MeLevel, AddHenchman(oMaster, oNew));
   DestroyObject(MeLevel, 0.5);
   DelayCommand(0.4, CopyLocals(oPC, oNew));
   DelayCommand(0.4, SetFormerMaster(oPC, oNew));
   return oNew;

}




//::///////////////////////////////////////////////
//:: Has/DestroyChapterQuestItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Checks if player has the chapter quest item
     The other function will destroy this item from
     the player.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int HasChapterQuestItem(int nChapter, object oPC)
{
    object oItem =    GetItemPossessedBy(oPC, STR_QuestItem(nChapter));
    if (GetIsObjectValid(oItem) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}

void DestroyChapterQuestItem(int nChapter, object oPC)
{
    object oItem =    GetItemPossessedBy(oPC, STR_QuestItem(nChapter));
    if (GetIsObjectValid(oItem) == TRUE)
    {
        DestroyObject(oItem);
    }
}

void DestroyChapterRewardItem(int nChapter, object oPC)
{
    object oItem =    GetItemPossessedBy(oPC, STR_RewardItem(nChapter));
    if (GetIsObjectValid(oItem) == TRUE)
    {
        DestroyObject(oItem);
    }

}
//* Change March 27 2002
// * Change February 14 2002:
// *  - Destroying Previous Chapter Reward Items
void GiveChapterRewardItem(int nChapter, object oPC)
{
    int nReward = 50;
    switch(nChapter)
    {
        case 1: nReward = 100; break;
        case 2: nReward = 200; break;
        case 3: nReward = 300; break;
    }
    GiveXPToCreature(oPC, nReward);

    int nOldChapter = nChapter;
    if (nOldChapter > 1)
     nOldChapter = nOldChapter - 1;

    DestroyChapterRewardItem(nOldChapter, oPC);
    CreateItemOnObject(STR_RewardItem(nChapter), oPC);
}

int HasChapterRewardItem(int nChapter, object oPC)
{
    object oItem =    GetItemPossessedBy(oPC, STR_RewardItem(nChapter));
    if (GetIsObjectValid(oItem) == TRUE)
    {
        return TRUE;
    }
    return FALSE;

}

//::///////////////////////////////////////////////
//:: GetChapter/Area Functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Return integer for chapter (see key, above)
    Return 'tag' of area
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetChapter()
{
    string sChapter =  GetTag(GetModule());

  // * Just for testing
 //  string sChapter = GetLocalString(GetModule(),"CHAPTER");
    int nChapter = 1;

    if (sChapter == "Prelude")
    {
        nChapter = 0;
    }
    else
    if (sChapter == "Chapter1")
    {
        nChapter = 1;
    }
    else
    if (sChapter == "Chapter2")
    {
        nChapter = 2;
    }
    else
    if (sChapter == "Chapter3")
    {
            nChapter = 3;
    }
    else
    if (sChapter == "ENDMODULE3") // * chapter 4
    {
        nChapter = 4;
    }
    else
    if (sChapter == "ENDMODULE1") // * chapter 1 end
    {
        nChapter = 5;
    }
    else
    if (sChapter == "ENDMODULE2") // * Chapter 2 end
    {
        nChapter = 6;
    }
    return nChapter;
}
string GetMyArea(object oThing=OBJECT_SELF)
{
   return GetTag(GetArea(oThing));
}
// * returns true if this is an end module
int EndModule()
{   string sTag = GetTag(GetModule());
    return (sTag == "ENDMODULE") || (sTag == "ENDMODULE1") || (sTag == "ENDMODULE2") ||(sTag == "ENDMODULE3");
}
// * Spawns appropriate henchman into C1e, C2e, or C4
void SpawnHenchman()
{
    object oPC = GetEnteringObject();
    string sLevel = "03";
    // * override level of henchman for chapters 2e and 4
    if (GetTag(GetModule()) == "ENDMODULE2")
    {
        sLevel = "07";
    }
   if (GetTag(GetModule()) == "ENDMODULE3")
    {
        sLevel = "10";
    }

    if (GetLocalInt(oPC, "NW_L_SPAWNCHAPTERENDHENCHMENONCE") == 0)
    if (GetIsPC(oPC) == TRUE)
    {
        string sTestHench = "";

        // * May 28 2002: Testing to see if the henchman already exists
        // * there can only be one in the world at a time
        object oItem = GetItemPossessedBy(oPC, "NW_HEN_DAEPERS");
        object oHen = OBJECT_INVALID;
        if (GetIsObjectValid(oItem) == TRUE)
        {
            sTestHench = "NW_HEN_DAE";
            if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
            {
                oHen = CreateObject(OBJECT_TYPE_CREATURE, sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
            }
        }
        else
        {
            oItem = GetItemPossessedBy(oPC, "NW_HEN_SHAPERS");
            if (GetIsObjectValid(oItem) == TRUE)
            {
                sTestHench = "NW_HEN_SHA" ;
                if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
                {
                    oHen = CreateObject(OBJECT_TYPE_CREATURE, sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
                }
            }
            else
            {
                oItem = GetItemPossessedBy(oPC, "NW_HEN_GALPERS");
                if (GetIsObjectValid(oItem) == TRUE)
                {
                    sTestHench = "NW_HEN_GAL" ;
                    if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
                    {
                        oHen = CreateObject(OBJECT_TYPE_CREATURE, sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
                    }
                }
                else
                {
                    oItem = GetItemPossessedBy(oPC, "NW_HEN_GRIPERS");
                    if (GetIsObjectValid(oItem) == TRUE)
                    {
                        sTestHench = "NW_HEN_GRI" ;
                        if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
                        {
                            oHen = CreateObject(OBJECT_TYPE_CREATURE, sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
                        }
                   }
                    else

                    {
                        oItem = GetItemPossessedBy(oPC, "NW_HEN_BODPERS");
                        if (GetIsObjectValid(oItem) == TRUE)
                        {
                            sTestHench = "NW_HEN_BOD" ;
                            if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
                            {
                                oHen = CreateObject(OBJECT_TYPE_CREATURE,sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
                            }
                        }
                        else
                        {
                            oItem = GetItemPossessedBy(oPC, "NW_HEN_LINPERS");
                            if (GetIsObjectValid(oItem) == TRUE)
                            {
                                sTestHench = "NW_HEN_LIN" ;
                                if (GetIsObjectValid(GetObjectByTag(sTestHench)) == FALSE)
                                {
                                    oHen = CreateObject(OBJECT_TYPE_CREATURE,sTestHench  + "_" + sLevel, GetLocation(GetObjectByTag("NW_HENCHMAN_BAR")));
                                }
                            }

                        }
                    }

                }

            }

        }

        // * Henchman can be invalid, if it turned out there already was one.
        if (GetIsObjectValid(oHen) == TRUE)
        {
            AssignCommand(oHen, SetWorkingForPlayer(oPC));
            SetLocalInt(oPC, "NW_L_SPAWNCHAPTERENDHENCHMENONCE", 1);
            AddHenchman(oPC, oHen);
        }

    }
}
