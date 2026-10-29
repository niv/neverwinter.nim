//::///////////////////////////////////////////////
//:: x1_playerrest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script controls what should happen when
    the player rests.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_henchman"

// * these constants copied from q3_inc_plot
// values for Q3_GNOLL_STATUS:
int GNOLL_STATUS_INIT =             0; // initial status
int GNOLL_STATUS_LEFT =             1; // all gnoll left the area
int GNOLL_STATUS_DEAD =             2; // chief is dead
int GNOLL_STATUS_SAFE_PASSAGE =     3; // gnollsgave safe passge
int GNOLL_STATUS_CONTROL_TRIBE=     4; // player has full control over the tribe

// values for Q3_GNOLL_HELP
int GNOLL_NOHELP = 0;
int GNOLL_HELP = 1;

// * Am I NOT on a safe rest trigger?
int NotOnSafeRest(object oPC);
// * Am I in a place where it is not safe to rest?
int NotSafeToRest(object oPC);

void main()
{  // SpawnScriptDebugger();
    int nRest = GetLastRestEventType();
    if (nRest == REST_EVENTTYPE_REST_STARTED)
    {
        object oPC = GetLastPCRested();
        object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);
        
        
        // * rest started, if I have a henchman
        // * who is dying, abort the rest
        if (GetIsObjectValid(oHench) && GetIsHenchmanDying(oHench))
        {
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oHench, ClearAllActions());
            SetCommandable(TRUE, oHench);
            // * clear previous animatioms...
            AssignCommand(oHench,
                               PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                             1.0, 1.0));
            AssignCommand(oHench, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, HENCHMEN_DIE_ANIM_DURATION));
            SetCommandable(TRUE, oHench);
            FloatingTextStrRefOnCreature(40051, oPC);
        }
        else
        if (NotSafeToRest(oPC) == TRUE)
        {
            if (NotOnSafeRest(oPC) == TRUE)
            {
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oHench, ClearAllActions());
                FloatingTextStrRefOnCreature(40156, oPC);
            //    AssignCommand(oPC, SpeakString("blah"));
            }
        }
    }
}

//::///////////////////////////////////////////////
//:: NotSafeToRest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns TRUE if this is an area that the
    player is not allowed to rest in and the condition
    is not achieved.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int NotSafeToRest(object oPC)
{

    // * The resting system only works on Hardcore
    // * or above.
    if (GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        return FALSE;
    }

    string sTag = GetTag(GetArea(oPC));
    int nNotSafe = FALSE;
    if (sTag == "Q3_HighForestGnollCaves")
    {
    
        nNotSafe = TRUE;
        
        int nStatus = GetLocalInt(GetModule(), "Q3_GNOLL_STATUS");
        if(nStatus == GNOLL_STATUS_SAFE_PASSAGE ||
           nStatus == GNOLL_STATUS_CONTROL_TRIBE ||
           nStatus == GNOLL_STATUS_LEFT ||
           nStatus == GNOLL_STATUS_DEAD)
        {
            nNotSafe = FALSE;
        }

       int nHelp = GetLocalInt(GetModule(), "Q3_GNOLL_HELP");
       if (nHelp == GNOLL_HELP)
       {
            nNotSafe = FALSE;
       }

    } // GNOLL CAVES
    else
    if (sTag == "Q3C_AncientTemple")
    {
        nNotSafe = TRUE;
        if (GetLocalInt(GetModule(), "X1_JNAHPLOT") == 10 || GetLocalInt(GetModule(), "X1_JNAH_STATUS") == 3)
        {
            nNotSafe = FALSE;
        }
    }   // Ancient Temple
    else
    if (sTag == "q5_KoboldCaves")
    {
        nNotSafe = TRUE;
        if (GetLocalInt(GetModule(), "X1_TYMOFARRAR_STATUS") == 2 ||
            GetLocalInt(GetModule(), "X1_Q5CHAMPION"       ) > 10 ||
            GetLocalInt(GetModule(), "X1_CHIEFARZIGDEAD"   )   ==1)
        {
            nNotSafe = FALSE;
        }
    } // Kobold Caves
    else
    if (sTag == "Q5_DragonCaves")
    {
        nNotSafe = TRUE;
        if (GetLocalInt(GetModule(), "X1_TYMOFARRAR_STATUS") > 1)
        {
            nNotSafe = FALSE;
        }

    } // dragon caves
    else if(sTag == "q1_StingerCaves")
    {
        nNotSafe = TRUE;
    }
    else if(sTag == "q1_StingerCavesTemple")
    {
        nNotSafe = TRUE;
    }
    else if(sTag == "q2d_TombofKelGaras")
    {
        nNotSafe = TRUE;
    }
    else if(sTag == "q2e_TombofKelGarasInnerCatacombs")
    {
        nNotSafe = TRUE;
    }
    else if(sTag == "q3b_AnaurochExcavatedRuins")
    {
        nNotSafe = TRUE;
    }
    else if(sTag == "q3c_FormiansHive")
    {
        nNotSafe = TRUE;
        if(GetLocalInt(GetModule(), "Q3C_HIVE_NOT_HOSTILE") == 1)
        {
            nNotSafe = FALSE;
        }
    }
    else if(sTag == "q4_AbovetheCityofUdrentide")
    {
        nNotSafe = TRUE;
    }
/* Chapter 2 Resting Specifics
Allow Resting When "bAllowRest" (saved on the area) = TRUE:
1) Area Tag: "Undrentide_01" (When Ashtara's Quest is Complete)
2) Area Tag: "Undrentide_02" (When Ashtara's Quest is Complete)
3) Area Tag: "Undrentide_03" (When Ashtara's Quest is Complete)
4) Area Tag: "Undrentide_04" (When Ashtara's Quest is Complete)
5) Area Tag: "Crypt_01" (When all sarcophagi are destroyed)
6) Area Tag: "Crypt_03" (When all undead in the area are destroyed)
7) Area Tag: "Crypt_04" (When the Dead Wind is obtained)
8) Area Tag: "Wizard_04" (When the Portable Door is obtained)
9) Area Tag: "Wizard_05" (When the Dark Wind is obtained)
10) Area Tag: "Library_03a" (When Quill Pen is obtained)
11) Area Tag: "Library_04a" (When Inkwell is obtained)
12) Area Tag: "Library_05" (When the Wise Wind is obtained)
13) Area Tag: "Winds_02" (When all golems have been destroyed)
*/
    else if(sTag == "Undrentide_01")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Undrentide_02")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Undrentide_03")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Undrentide_04")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Crypt_01")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Crypt_03")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Crypt_04")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Wizard_04")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Wizard_05")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Library_03a")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Library_04a")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Library_05")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    else if(sTag == "Winds_02")
    {
        nNotSafe = !GetLocalInt(GetArea(oPC), "bAllowRest");
    }
    return nNotSafe;
}

//::///////////////////////////////////////////////
//:: NotOnSafeRest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    returns TRUE if the player is not in a safe
    zone within an area.

    RULE: There must be at least one door
          All doors must be closed
      
    - takes player object
    - finds nearest safe zone
    - is player in safe zone?
       - find all doors in safe zone
        - are all doors closed?
            - if YES to all the above
                is safe to rest,
                    RETURN FALSE
    - otherwise give appropriate feedback and return TRUE
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int NotOnSafeRest(object oPC)
{  // SpawnScriptDebugger();
    object oSafeTrigger = GetNearestObjectByTag("X0_SAFEREST", oPC);
    int bAtLeastOneDoor = FALSE;
    int bAllDoorsClosed = TRUE;
    int bPCInTrigger = FALSE;

    if (GetIsObjectValid(oSafeTrigger))
    {
        if (GetObjectType(oSafeTrigger) == OBJECT_TYPE_TRIGGER)
        {

            // * cycle through trigger looking for oPC
            // * and looking for closed doors
            object oInTrig = GetFirstInPersistentObject(oSafeTrigger, OBJECT_TYPE_ALL);
            while (GetIsObjectValid(oInTrig) == TRUE)
            {
                // * rester is in trigger!
                if (oPC == oInTrig)
                {
                    bPCInTrigger = TRUE;
                }
                else
                {
                    // * one door found
                    if (GetObjectType(oInTrig) == OBJECT_TYPE_DOOR)
                    {
                        bAtLeastOneDoor = TRUE;
                        // * the door was open, exit
                        if (GetIsOpen(oInTrig) == TRUE)
                        {
                            return TRUE; //* I am no in a safe rest place because a door is open
                        }
                    }
                }
                oInTrig = GetNextInPersistentObject(oSafeTrigger, OBJECT_TYPE_ALL);
            }
        }
    }
    if (bPCInTrigger == FALSE || bAtLeastOneDoor == FALSE)
    {
        return TRUE;
    }
    // * You are in a safe trigger, if in a trigger, and all doors closed on that trigger.
    return FALSE;
}
