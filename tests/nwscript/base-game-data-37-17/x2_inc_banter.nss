//::///////////////////////////////////////////////
//:: x2_inc_banter
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Include file for party banter and other
    group communication things

    October 23 - 2003
     - Banter variable name renamed to BANT to
     be short enough to be stored on the database
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: August 2003
//:://////////////////////////////////////////////

// ******************************************************
// * Helper functions
// ******************************************************


#include "x0_i0_henchman"
// * This is the main interjection function called from x2_evt_trigger
// * and any plot means of making banter happen\
// * oSelf - is used only when triggers are running the script
// * sTag is the tag of the trigger. Pass in an appropriate henchman tag
// *    when using this function for plot purposes (i.e., x2_oneliner_nr gives you
// *    non-random popups
// * oTrigger - should be the player involved. The object who triggered things
// * nOverrideModNum - Change the popup to display. Should only be used when calling it
// *   from non-triggers
// * oOverrideBanter - this hench should try to initiate banter
void AttemptInterjectionOrPopup(object oSelf, string sTag, object oTrigger, int nOverrideModNum=0, object oOverrideBanter=OBJECT_INVALID);

// * Have the proper plot variables been set?
int AttemptToShowInfo(int nTriggerType, int nId, int bDestroyAnyways = FALSE, object oHench=OBJECT_INVALID);
// * Looks for the valid random Number # to return; updates sVariableName stringlist (i.e., 1|2|3|)
int GetRandomTextNumber(object oHench, string sVariableName, int nDeleteMe=-1);
// * actually speaks the interjection
void FireInterjection(int nType, int nModNumber, object oMaster, object oHench, int nDestroyTriggerAnyways = FALSE, string sConvFile="");
// * Returns either the 1st or second henchman, randomly
// * for purposes of interjections and such
object GetRandomHench(object oPC, string sTag="");
// * Making code reusable. Call this at the highest level to fire the appropriate interjection
void WrapInterjection(int nType, int nId, object oMaster, object oHench, string sTag, int nDestroyTriggerAnyways = FALSE, string sConvFile="");
// * Wrapper function to streamline that party banter system
int TryBanterWith(string sTag, int nBanter);
// * Nathyrra or Valen romance dialog
void AttemptRomanceDialog(object oPC, int nLimit);

int HenchmanMoveable(object oHench);
void DoInterjection(object oHench, object oPC, int MOD_EVENT_NUMBER, string sConvFile="");
int ValidForInterjection(object oPC, object oHench);

const int TRIGGER_ONELINERNONRANDOM = 1;
const int TRIGGER_ONELINERRANDOM = 2;
const int TRIGGER_INTERJECTION_NONRANDOM = 3;
const int TRIGGER_INTERJECTION_RANDOM = 4;



// * Checks to see if henchmen is available for banter interjection
// * and then moves them to the position of the Master, as well
// * as OBJECT_SELF
int BanterReady(string sTag, string sTag2="", string sTag3="")
{
    object oHench1 = OBJECT_SELF;
    int bMoveHench1, bMoveHench2, bMoveHench3, bMoveHench4 = FALSE;

    if (HenchmanMoveable(oHench1) == TRUE)
    {
        // * Move him
        bMoveHench1 = TRUE;
    }
    else
    {
        return FALSE;
    }

    object oHench2 = GetObjectByTag(sTag);
    object oPC = GetMaster(oHench1);

    // * is at least one participant available
    if (GetIsObjectValid(oHench2) == TRUE)
    {
        if (HenchmanMoveable(oHench2) == TRUE && GetMaster(oHench2) == oPC)
        {
            // * Move him
            bMoveHench2 = TRUE;
        }
        else
        {
           return FALSE;
        }
    }
    else
    {
        return FALSE;
    }

    object oHench3, oHench4;

    // * Are we expecting another participant?
    if (sTag2 != "")
        oHench3 = GetObjectByTag(sTag2);
    if (GetIsObjectValid(oHench3) == TRUE)
    {
        if (HenchmanMoveable(oHench3) == TRUE & GetMaster(oHench3) == oPC)
        {
            // * Move him
            bMoveHench3 = TRUE;
        }
        else
        {
           return FALSE;   // * because one of the participants is not available, entire interjection needs
                           // * to be dropped.
        }
    }
    // * Are we expecting another participant?
    if (sTag3 != "")
        oHench4 = GetObjectByTag(sTag3);
    if (GetIsObjectValid(oHench4) == TRUE & GetMaster(oHench4) == oPC)
    {
        if (HenchmanMoveable(oHench4) == TRUE)
        {
            // * Move him
            bMoveHench4 = TRUE;
        }
        else
        {
           return FALSE;   // * because one of the participants is not available, entire interjection needs
                           // * to be dropped.
        }
    }

   // * IF we made it to this point, then we know that
   // * everyone expected to participant, can.
   // * now move them.
    AssignCommand(oPC, ClearAllActions());
   // AssignCommand(oHench1, ClearAllActions()); DOn't clear my actions, already in conversation

    if (bMoveHench2 == TRUE)
    {
        AssignCommand(oHench2, ClearAllActions());
        AssignCommand(oHench2, JumpToObject(oPC));
    }
    if (bMoveHench3 == TRUE)
    {
        AssignCommand(oHench3, ClearAllActions());
        AssignCommand(oHench3, JumpToObject(oPC));
    }
    if (bMoveHench4 == TRUE)
    {
        AssignCommand(oHench4, ClearAllActions());
        AssignCommand(oHench4, JumpToObject(oPC));
    }

    AssignCommand(oHench1, JumpToObject(oPC));


    return TRUE;

}

// * Wrapper function to streamline that party banter system
int TryBanterWith(string sTag, int nBanter)
{
    if (GetLocalInt(OBJECT_SELF, "X2_BANTER_TRY") == 1 && BanterReady(sTag) == TRUE
        && GetLocalInt(OBJECT_SELF, "BANT" + sTag) == nBanter -1)
    {
            // * Prepare for next banter
          SetLocalInt(OBJECT_SELF, "BANT" + sTag, nBanter);
          SetLocalInt(OBJECT_SELF, "X2_BANTER_TRY", 0);

          return TRUE;
    }
    return FALSE;
}
// * Making code reusable. Call this at the highest level to fire the appropriate interjection
void WrapInterjection(int nType, int nId, object oMaster, object oHench, string sTag, int nDestroyTriggerAnyways = FALSE, string sConvFile="")
{
    //int nStart = 0;
    //int nCount = 12;
    string sSubTag = GetSubString(sTag, 0/*nStart*/, 12/*nCount*/);
    string sIntTag = GetSubString(sTag, 12, 100);

    // * unless applicable for anyone (blank tag)
    // * grab the correct henchman
    if (sIntTag != "" )
        oHench = GetObjectByTag(sIntTag);

    if (GetAssociateType(oHench) == ASSOCIATE_TYPE_HENCHMAN && ValidForInterjection(oMaster, oHench) && ValidForInterjection(oHench, oMaster))
    {
        FireInterjection(nType, nId, oMaster, oHench, nDestroyTriggerAnyways, sConvFile);
    }
}


//::///////////////////////////////////////////////
//:: FireInterjection
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Actually speaks the interjection
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void FireInterjection(int nType, int nModNumber, object oMaster, object oHench, int nDestroyTriggerAnyways = FALSE, string sConvFile="")
{
    int bIsInCombat = FALSE;
    if (GetIsInCombat(oMaster) == TRUE)
    {
        bIsInCombat = TRUE;
    }
    // * Has the proper plot variables been set yet?
    // * if not, don't talk.
    // * Keep trigger around.
//    SpawnScriptDebugger();
    if (AttemptToShowInfo(nType, nModNumber, nDestroyTriggerAnyways, oHench) == TRUE)
    {
        if (bIsInCombat == FALSE)
        {
            if (HenchmanMoveable(oHench) == FALSE)
            {
                if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
                   DestroyObject(OBJECT_SELF);
                return;
            }

            DoInterjection(oHench, oMaster, nModNumber, sConvFile);
            // Only signal once
            if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
              DestroyObject(OBJECT_SELF);
        }
        else
        {
            // * Nov 2003
            // * if I am in combat, then destroy this trigger
            // * I can't speak now and if I speak later it won't
            // * make sense
            if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
              DestroyObject(OBJECT_SELF);
        }
    }
}
void DoInterjection(object oHench, object oPC, int MOD_EVENT_NUMBER, string sConvFile)
{
        AssignCommand(oHench, SetHasInterjection(oPC, TRUE, MOD_EVENT_NUMBER));
        AssignCommand(oHench, ClearAllActions());
        AssignCommand(oPC, ClearAllActions());
//        AssignCommand(oHench, ActionMoveToObject(oPC, TRUE, 6.0));
        AssignCommand(oHench, JumpToObject(oPC));
        AssignCommand(oHench, DelayCommand(0.1,ActionStartConversation(oPC, sConvFile)));
}


//::///////////////////////////////////////////////
//:: GetRandomTextNumber
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Modifies the list of strings for sVariableName
    keeping track of which random lines (either
    one-liner, henchmen interjection or
    random standard interjection.

    if nDeleteMe > -1 then it will mark
    this entry as "said". This is useful for Chapter3
    where I want to mark the Chapter 2 randomers off
    of the list.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetRandomTextNumber(object oHench, string sVariableName, int nDeleteMe=-1)
{
    `       string sCode = GetLocalString(oHench, sVariableName);

            // * if string is blank, we've said them all. (Nov 1 - BK)
            if (sCode == "")
            {
                return 0;
            }

            string sCopy = sCode;
            int nNumberOfRandomLeft = 0;

            // * Count number of random entries left in string
            int nPos = 0;
            int nCount = 0;

            while (sCopy != "")
            {
                nPos = FindSubString(sCopy, "|");
                if (nPos > 0)
                {
                    nCount++;
                    sCopy = GetSubString(sCopy, nPos + 1, GetStringLength(sCopy) - nPos);
                }
            }


            // * if count is 0, abort   (Nov 1 - BK)
            if (nCount < 1)
                return 0;

            // * Roll a random number based on the number
            int nRoll = Random(nCount) + 1;

            if (nDeleteMe > - 1)
            {
                nRoll = nDeleteMe; // * this number is meant to be stricken from the list
            }

            // *
            // * Lookup that string entry and delete it
            // *

            nPos = 0;
            int i = 0;
            sCopy = sCode;
            // * this will become the rebuilt string

            string sCopy2 = "";
            string sNumber = "";
            string sFinalNumber = "0";

            while (sCopy != "")
            {
                nPos = FindSubString(sCopy, "|");
                if (nPos > 0)
                {
                    i++;
                    sNumber = GetSubString(sCopy, 0, nPos );
                    // * This is the random one to display
                    if (i == nRoll)
                    {
                        // * do nothing, the number will be returned when
                        // * done rebuilding the string
                        sFinalNumber = sNumber;
                    }
                    else
                    // * don't copy the string I've just said
                        sCopy2 = sCopy2 + GetSubString(sCopy, 0, nPos+1);
                    sCopy = GetSubString(sCopy, nPos + 1, GetStringLength(sCopy) - nPos);
                }
            }
            // * Blank the string out, if we've removed the last random number (Nov 1 -  BK)
            if (nCount == 1)
            {
                sCopy2 = "";
            }
            // * Store variable string with adjusted list of remaining random strings
            SetLocalString(oHench, sVariableName, sCopy2);

    return StringToInt(sFinalNumber) * - 1; // * all random numbers are negative

}

//::///////////////////////////////////////////////
//:: AttemptToShowInfo
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will only show this trigger if the information
    about it, is valid.

    How does this work?

    By default, all triggered events are true
    unless they are listed here.

    If they are listed here, then the variables
    needed to return TRUE must be
    verified.

    bDestroyAnyways: WIll destroy the trigger if true

    oHench: Passed in for circumstances where certain
      henchmen are not able to see particular
      interjections because none have been written for them.

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int AttemptToShowInfo(int nTriggerType, int nId, int bDestroyAnyways = FALSE, object oHench=OBJECT_INVALID)
{
    int nCode = (nTriggerType * 1000) + nId;
    string sTag=""; // * used in certain tests
    int bReturn = TRUE;

    // * do not destroy the final trigger. Or the reaper trigger.
    // * basically these triggers need to stay around until they are actually triggered
    if (bDestroyAnyways == TRUE && nCode != 3016 && nCode != 3015)
    {
       if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
        DestroyObject(OBJECT_SELF);
    }
    if (GetIsObjectValid(oHench) == TRUE)
    {
        sTag = GetTag(oHench);
    }


    // * have to use these variables due to a weird "kick-out" of the script the old
    // * way I had written it
    int bTomi = FALSE;
    int bLinu = FALSE;
    int bSharwyn = FALSE;
    int bDaelan = FALSE;
    int bOriginal = FALSE;

    if (sTag == "x2_hen_tomi")
        bTomi = TRUE;
    if (sTag == "x2_hen_linu")
        bLinu = TRUE;
    if (sTag == "x2_hen_sharwyn")
        bSharwyn = TRUE;
    if (sTag == "x2_hen_daelan")
        bDaelan = TRUE;

     if (bTomi || bLinu || bSharwyn || bDaelan)
     {
        bOriginal = TRUE;
     }

    switch (nCode)
    {
    // **********************
    // * One liner (1000-)
    // * Non-Random
    // **********************
        // * Player does not know anything about Pizza.
        case 1002:
        {
//            if (GetLocalInt(GetModule(), "X2_L_TRUTH_ABOUT_PIZZA") == FALSE)
//                return FALSE;
            break;
        }
    // **********************
    // * One liner (2000-)
    // * Random
    // **********************

    // **********************
    // * Interjection (3000-)
    // * Non-Random
    // **********************
       case 3001:
       case 3005:
       // * these henchmen do not have these lines
        if (bOriginal == TRUE)
        {
            // * Custom: Get Deekin to say something
            object oDeekin = GetNearestObjectByTag("x2_hen_deekin");
            if (GetIsObjectValid(oDeekin) == TRUE && GetMaster(oDeekin) == GetMaster(oHench))
            {    //   AssignCommand(oHench, SpeakString("Give this to Deekin"));
                AttemptInterjectionOrPopup(OBJECT_SELF, "x2_inter_nr", GetMaster(oHench), nCode - 3000, oDeekin);
            }
            bReturn = FALSE;
        }
        break;
       case 3002:
       {
        // * these henchmen do not have these lines
        if (bLinu || bDaelan)
        {
            bReturn = FALSE;
        }
        break;
       }

       case 3004: case 3003:
       {
        // * these henchmen do not have these lines
        if (bLinu)
        {
            return FALSE;
        }
        break;
       }
       // * only Deekin will ever say this line
       case 3015:
       {
       // * these henchmen do not have these lines
        if (bOriginal == TRUE)
        {
            // * Custom: Get Deekin to say something
            object oDeekin = GetNearestObjectByTag("x2_hen_deekin");
            if (GetIsObjectValid(oDeekin) == TRUE && GetMaster(oDeekin) == GetMaster(oHench))
            {    //   AssignCommand(oHench, SpeakString("Give this to Deekin"));
                AttemptInterjectionOrPopup(OBJECT_SELF, "x2_inter_nr", GetMaster(oHench), nCode - 3000, oDeekin);
            }
            bReturn = FALSE;
        }
        break;
       }
       // * final interjection should only be said in certain circumstance
       case 3016:
       {
        if (GetIsObjectValid(GetObjectByTag("x2_homedoor")) == TRUE)
        {
            DestroyObject(OBJECT_SELF, 0.3);
            return TRUE;
        }
        else
        {
            return FALSE;
        }
       }

     // **********************
    // * Interjection (4000-)
    // * Random
    // **********************

    // **********************
    // * Interjection (5000-)
    // * Random, Party
    // **********************



        default:

    }
    return bReturn;

}
// * am I valid for doing an interjection
int ValidForInterjection(object oPC, object oHench)
{
    if (!IsInConversation(oPC)
        && GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oHench)) <= 20.0)
    {
        return TRUE;
    }
    return FALSE;
}

int HenchmanMoveable(object oHench)
{
    if (GetIsDead(oHench) == TRUE || GetIsHenchmanDying(oHench) == TRUE
        || GetHasEffect(EFFECT_TYPE_PARALYZE, oHench)
        || GetHasEffect(EFFECT_TYPE_STUNNED, oHench)
        || GetHasEffect(EFFECT_TYPE_PETRIFY, oHench)
        || GetHasEffect(EFFECT_TYPE_SLEEP, oHench)
        || GetHasEffect(EFFECT_TYPE_CONFUSED, oHench)
        || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oHench)
        )
        return FALSE;

    return TRUE;

}

// * Returns either the 1st or second henchman, randomly
// * for purposes of interjections and such
// * sTag is used in Chapter 2, so that only Deekin speaks
// * random interjections as no one else has any
// * October 20 - fixes to make sure FOLLOWERS ARE NEVER returnted

object GetRandomHench(object oPC, string sTag="")
{
    int num = X2_GetNumberOfHenchmen(oPC);  // *LOOP - Costly **
    int i = Random(num) + 1;
    int nBadNum = i;
    object oHench = OBJECT_INVALID;

    oHench =    GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC,i);
    if (GetIsFollower(oHench) == TRUE && num > 1)
    {
        // * Try another
        do
        {
            i = Random(num) + 1;
        }
        while (i == nBadNum);
        // * Weakness: can fail if you have 2 or more followers.
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
    }

    return oHench;
}



// * This is the main interjection function called from x2_evt_trigger
// * and any plot means of making banter happen\
// * oSelf - is used only when triggers are running the script
// * sTag is the tag of the trigger. Pass in an appropriate henchman tag
// *    when using this function for plot purposes (i.e., x2_oneliner_nr gives you
// *    non-random popups
// * oTrigger - should be the player involved. The object who triggered things
// * nOverrideModNum - Change the popup to display. Should only be used when calling it
// *   from non-triggers
// * oOverrideBanter - this hench should try to initiate banter
void AttemptInterjectionOrPopup(object oSelf, string sTag, object oTrigger, int nOverrideModNum=0, object oOverrideBanter=OBJECT_INVALID)
{
    // ***********************
    // * Find Random henchman
    // * to use.
    // ***********************
    if (GetIsPC(oTrigger) == FALSE)
    {
        return;
    }
    object oHench = OBJECT_INVALID;

    if (GetIsObjectValid(oOverrideBanter) == FALSE)
    {
        oHench = GetRandomHench(oTrigger, sTag);
    }
    else
    {
        oHench = oOverrideBanter;
    }


    if (GetIsObjectValid(oHench) == FALSE)
    {
        // * Oct 1: Even if I do not have a henchman
        // * destroy Non-random triggers (as they
        // * are context sensitive and their info
        // * may be innapropriate at a later date)
        if (sTag == "x2_oneliner_nr" || sTag == "x2_inter_nr")
        {
            if (GetObjectType(oSelf) == OBJECT_TYPE_TRIGGER)
            {
                DestroyObject(oSelf);
            }
        }

        return;
    }
    // * End of finding henchman
    string sConvFile = GetDialogFileToUse(oTrigger, oHench);



    object oMaster = oTrigger;//GetMaster(oHench);


    // **********************

    // The key tag of the trigger is the module event number
    int MOD_EVENT_NUMBER = StringToInt(GetTrapKeyTag(oSelf));

    // * if calling this function from non triggers you can specify a different number
    if (nOverrideModNum != 0)
    {
        MOD_EVENT_NUMBER = nOverrideModNum ;
    }

    // **********************


    // **********************
    // * One liner
    // * Non-Random
    // **********************

    if (sTag == "x2_oneliner_nr")
    {
        if (HenchmanMoveable(oHench) == FALSE)
        {
            if (GetObjectType(oSelf) == OBJECT_TYPE_TRIGGER)
                DestroyObject(oSelf);
            return;
        }
        if (AttemptToShowInfo(TRIGGER_ONELINERNONRANDOM, MOD_EVENT_NUMBER, TRUE) == TRUE)
        {
            AssignCommand(oHench, SetOneLiner(TRUE, MOD_EVENT_NUMBER));
            AssignCommand(oHench, SpeakOneLinerConversation(sConvFile, oMaster));
            SetLocalInt(oHench, "X0_L_BUSY_SPEAKING_ONE_LINER", 10);
            return;
        }
    }
    else
    // **********************
    // * One liner
    // * Random
    // **********************
    if (sTag == "x2_oneliner_r")
    {
        if (HenchmanMoveable(oHench) == FALSE)
        {
            if (GetObjectType(oSelf) == OBJECT_TYPE_TRIGGER)
                DestroyObject(oSelf);
            return;
        }



        if (AttemptToShowInfo(TRIGGER_ONELINERRANDOM, MOD_EVENT_NUMBER, TRUE) == TRUE)
        {
            //  SpawnScriptDebugger();
            MOD_EVENT_NUMBER = GetRandomTextNumber(oHench, "X2_L_RANDOMONELINERS");

            // * if we've said all random things, don't try anymore (Nov 1 - BK)
            if (MOD_EVENT_NUMBER == 0)
                return;
            AssignCommand(oHench, SetOneLiner(TRUE, MOD_EVENT_NUMBER));
            AssignCommand(oHench, SpeakOneLinerConversation(sConvFile, oMaster));
            SetLocalInt(oHench, "X0_L_BUSY_SPEAKING_ONE_LINER", 10);
            return;
        }
    }
    else
    // **********************
    // * Interjection
    // * Non-Random
    // * NOTE: If you want ANY character to say
    // * an interjection at this point
    // * leave the tag as x2_inter_nr
    // * and it will grab a random henchman
    // **********************
    if (FindSubString(sTag, "x2_inter_nr") >-1)
    {
        // * only aribeth has interjections 100 or higher
        if (MOD_EVENT_NUMBER >= 100 && GetTag(oHench) != "H2_Aribeth")
        {
            DestroyObject(OBJECT_SELF); // * always destroy Aribeth's triggers
            return;
        }

        WrapInterjection(TRIGGER_INTERJECTION_NONRANDOM, MOD_EVENT_NUMBER, oMaster, oHench, sTag, FALSE, sConvFile);
    }
    else
    // **********************
    // * Interjection
    // * Random
    // * NOTE: If you want ANY character to say
    // * an interjection at this point
    // * leave the tag as x2_inter_nr
    // * and it will grab a random henchman
    // *
    // * Works as non-random interjection
    // * except the type of interjection being
    // * pulled is diferrent
    // **********************

    if (FindSubString(sTag, "x2_inter_r") >-1)
    {
        // * If henchman chosen is Nathyrra or Valen, kick out (October 20, 2003)
        // * They never have random interjections
        if (GetTag(oHench) == "x2_hen_valen" || GetTag(oHench) == "x2_hen_nathyra")
        {
            return;
        }


        // * if henchman can't speak, don't do this.
        // * unlike other triggers, don't destroy in this case
        // * because it hurts nothing for it to try to fire later.
        if (HenchmanMoveable(oHench) == FALSE)
        {
              return;
        }
        MOD_EVENT_NUMBER = GetRandomTextNumber(oHench, "X2_L_RANDOM_INTERJECTIONS");

        // * if we've said all random things, don't try anymore (Nov 1 - BK)
        if (MOD_EVENT_NUMBER == 0)
            return;

        // * Weakness; We may lost interjections if in the other functions
        // * it turns out that nows not a good time for the interjection this
        // * particular one will never be said because GetRandomTextNumber has
        // * blanked the text.
        WrapInterjection(TRIGGER_INTERJECTION_RANDOM, MOD_EVENT_NUMBER, oMaster, oHench, sTag, FALSE, sConvFile);
    }
    // **********************
    // * Interjection
    // * Party, Random
    // *
    // * Looks for a random
    // * interjection to say to
    // * another party member
    // *
    // * These are never
    // * context sensitive
    // * (though the system
    // * is setup so they could be)
    // **********************
    else
    if (FindSubString(sTag, "x2_party_r") >-1)
    {
        // * if henchman can't speak, don't do this.
        // * unlike other triggers, don't destroy in this case
        // * because it hurts nothing for it to try to fire later.
        if (HenchmanMoveable(oHench) == FALSE)
        {
              return;
        }
        // * Nov 2003 - If there's only one henchmen, no point in bantering
        if (X2_GetNumberOfHenchmen(oMaster) < 2)
        {
            if (GetObjectType(oSelf) == OBJECT_TYPE_TRIGGER)
              DestroyObject(oSelf); // remove trigger
            return;
        }
        SetLocalInt(oHench, "X2_BANTER_TRY", 1);
        // * Try first banter that has not been done already
        AssignCommand(oHench, ClearAllActions());
        AssignCommand(oHench, JumpToObject(oMaster));
        AssignCommand(oHench, ActionStartConversation(oMaster, sConvFile));
        if (GetObjectType(oSelf) == OBJECT_TYPE_TRIGGER)
          DestroyObject(oSelf); // remove trigger
        // * The banter script moves
        // * the henchmen here.

     }
    // **********************
    // * Interjection
    // * Romance
    // * Only 2 of these are in
    // * and they show up in C3 only.
    // * the rest of the romance in c2
    // * is handled via the resting system
    // **********************
    else
    if (FindSubString(sTag, "x2_romance_nr") >-1)
    {
        // * test that we are on the right
        // * numbered romance trigger, either 4 or 5
        if (MOD_EVENT_NUMBER == 4)
            AttemptRomanceDialog(oMaster, 5);
        else
        if (MOD_EVENT_NUMBER == 5)
            AttemptRomanceDialog(oMaster, 6);
    }

}

// * Nathyrra or Valen romance dialog
void AttemptRomanceDialog(object oPC, int nLimit)
{
            /* In Chapter2
            iNathyrraStage:
            This variable increases by 1 for each background/romance story Nathyrra initiates.
            It goes up to 4 in Chapter 2.
            AT THE END OF CHAPTER 2, IT AUTOMATICALLY GETS SET TO 4.
            It then jumps to 5 with the consummate romance trigger at the start of Chapter 3, then goes to 6 with the
            romance dialog Nathyrra inits in Chapter 3.
            WHEN THE PARTY PASSES THROUGH THE DOOR BACK TO WATERDEEP IN CHAPTER 3 this variable has to get set to 99.
            */

            /* Logic
                - I rested.
                - Is the plot completion variable for Chapter 2 further along than the romance variable for
                 my romance partner
                    - Init conversation

                i.e.,

                0 Plot Done = 0 nooky
                1 Plot Done = 1 nooky
                et cetera

                Real life should be this simple.

                There is a cap of "4" lines that get said this way in Chapter 2. (0-3)
                If you don't have an opposite gender henchman, the same gender henchman
                can say their "good friends" lines
            */

            // * Put lowest cost check in first - Chapter 2

            // * Decide if its appropriate to initiate - a plot needs to have been done

            // * Pick appropriate henchman
                int bPlayerGender = GetGender(oPC);
                int bHasValen = FALSE;
                int bHasNath = FALSE;


                object oValen = GetObjectByTag("x2_hen_valen");
                object oNathyrra = GetObjectByTag("x2_hen_nathyra");

                object oHenchToSpeak = OBJECT_INVALID;

                if (GetIsObjectValid(oValen) == TRUE)
                {
                    if (GetMaster(oValen) == oPC)
                    {
                        bHasValen = TRUE;
                    }
                }
                if (GetIsObjectValid(oNathyrra) == TRUE)
                {
                    if (GetMaster(oNathyrra) == oPC)
                    {
                        bHasNath = TRUE;
                    }
                }

                // * Pick which henchman is to speak
                if (bPlayerGender ==  GENDER_MALE)
                {
                    // * can't complete the romance (4) in Chapter 2
                    if (bHasNath == TRUE && GetLocalInt(GetModule(), "iNathyrraStage") < nLimit)
                    {
                        oHenchToSpeak = oNathyrra;
                    }
                    else
                    if (bHasValen == TRUE && GetLocalInt(GetModule(), "iValenStage") < nLimit)
                    {
                        oHenchToSpeak = oValen;
                    }
                }
                else
                if (bPlayerGender ==  GENDER_FEMALE)
                {
                    if (bHasValen == TRUE && GetLocalInt(GetModule(), "iValenStage") < nLimit)
                    {
                        oHenchToSpeak = oValen;
                    }
                    else
                    if (bHasNath == TRUE && GetLocalInt(GetModule(), "iNathyrraStage") < nLimit)
                    {
                        oHenchToSpeak = oNathyrra;
                    }

                }

                // * if a valid henchman is picked, make them speak
                if (GetIsObjectValid(oHenchToSpeak) == TRUE)
                {
                    AssignCommand(oHenchToSpeak, SetHasInterjection(oPC, TRUE, 100));
                    string sDialog = GetDialogFileToUse(oPC, oHenchToSpeak);
                    // * must fake an interjection here, an invalid numbered one
                    // * so it jumps down to the romance dialog
                    AssignCommand(oHenchToSpeak, ActionStartConversation(oPC, sDialog));
                }
}

// * returns true if its time to say another romance line
int GetPlotProgress()
{
    //First - check to see if any new plots have been completed
    //Shattered Mirror
    int nPlots = 0;
    if (GetLocalInt(GetModule(), "q6_city_gone") == 1)
    {
        nPlots++;
    }
    //Hive Mother
    if (GetLocalInt(GetModule(), "x2_plot_beholders_out") == 1)
    {
        nPlots++;
    }
    //Isle of the Maker
    if (GetLocalInt(GetModule(), "x2_plot_golem2_in") == 1 || GetLocalInt(GetModule(), "x2_plot_golem1_in") == 1)
    {
        nPlots++;
    }
    //Slaves to the Overmind
    if (GetLocalInt(GetModule(), "X2_Q2DOvermind") > 0)
    {
        nPlots++;

    }
    // dracolich
    if (GetLocalInt(GetModule(),"x2_plot_undead_out") == 1)
    {
        nPlots++;
    }
    int nGetLastRomanceSaid = GetLocalInt(GetModule(), "X2_G_LASTROMANCESAID");
    if (nPlots > nGetLastRomanceSaid)
    {
        nGetLastRomanceSaid++;
        SetLocalInt(GetModule(), "X2_G_LASTROMANCESAID", nGetLastRomanceSaid);
        return TRUE;
    }
    return FALSE;
}
