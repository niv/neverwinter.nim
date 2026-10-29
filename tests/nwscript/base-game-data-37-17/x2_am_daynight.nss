//::///////////////////////////////////////////////
//:: x2_am_daynight
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 _setup_
 - need a NIGHTTIME area (this is where sleepers will go)
 - Every in a DayNight trigger has the object of the trigger stored on them


 Trigger Heartbeat
 - will check if day-night or vice versa transition has happened
 - IF SO
     IF Day To Night
        - Take everyone who is inside trigger and has DayNightObj = Trigger_Self
          - Have them walk away and fade out
             - Store their last location on them
             - They will be teleported to NIGHTTIME area

     IF Night To Day
        - Cycle through everybody in NIGHTTIME area
           - any with DayNightObj = Trigger_Self
              - Have them appear at location they stored

    Requirements: Q/A needs to test this to make sure
    its very robust
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
// * Stores the triggers object on everyone in trigger, once only at start
void SetupMyPeople();
// * everyone at night is moved to the NIGHTTIME area
void SendAwayAtNight();
// * bring them back during the day
// * parse through all creatures in AREADAYNIGHT
void BringBackDuringDay();
void debugit(string s)
{
  //  SendMessageToPC(GetFirstPC(), s);
}
void main()
{
    SetupMyPeople();
    if (NoPlayerInArea() == TRUE) return; // * don't run this if no one is around

    if (GetIsNight() == TRUE)
    {
       // * must send away everyone in my trigger
        if (GetLocalInt(OBJECT_SELF, "X2_L_SendAwayForNight")  == 0)
        {   //debugit("Send away at night");
            SendAwayAtNight();
            SetLocalInt(OBJECT_SELF, "X2_L_SendAwayForNight", 10);
            SetLocalInt(OBJECT_SELF, "X2_L_SendAwayForDay", 0);
        }
    }
    else
    if (GetIsDay() == TRUE)
    {
        if (GetLocalInt(OBJECT_SELF, "X2_L_SendAwayForDay")  == 0)
        {
            //debugit("bring back during day");
            BringBackDuringDay();
            SetLocalInt(OBJECT_SELF, "X2_L_SendAwayForNight", 0);
            SetLocalInt(OBJECT_SELF, "X2_L_SendAwayForDay", 10);
        }
    }


}


// * Stores the triggers object on everyone in trigger, once only at start
void SetupMyPeople()
{
    if (GetLocalInt(OBJECT_SELF, "X2_L_Setup") == 10) return; // * already setup
    SetLocalInt(OBJECT_SELF, "X2_L_Setup", 10);
    object oCreature = OBJECT_INVALID;
    oCreature = GetFirstInPersistentObject();
    while (GetIsObjectValid(oCreature) == TRUE)
    {
        if (GetIsPC(oCreature) == FALSE)
        {
            SetLocalObject(oCreature, "X2_G_DayNightObj", OBJECT_SELF);
        }
        oCreature = GetNextInPersistentObject();
    }
}
// * everyone at night is moved to the NIGHTTIME area
void SendAwayAtNight()
{
    object oCreature = OBJECT_INVALID;
    oCreature = GetFirstInPersistentObject();
    //SpawnScriptDebugger();
    while (GetIsObjectValid(oCreature) == TRUE)
    {
        // * if this creature belongs to me, send it away
        if (GetLocalObject(oCreature, "X2_G_DayNightObj") == OBJECT_SELF)
        {
            object oArea = GetObjectByTag("AREADAYNIGHT");

            if (GetIsObjectValid(oArea) == TRUE)
            {
                object oWay = GetFirstObjectInArea(oArea);
                SetLocalLocation(oCreature, "X2_G_MYORIGIN", GetLocation(oCreature));
                AssignCommand(oCreature, ClearAllActions());
                AssignCommand(oCreature, JumpToObject(oWay));
            }
        }
        oCreature = GetNextInPersistentObject();
    }

}
// * bring them back during the day
// * parse through all creatures in AREADAYNIGHT
void BringBackDuringDay()
{
    object oArea = GetObjectByTag("AREADAYNIGHT");
    if (GetIsObjectValid(oArea) == TRUE)
    {
        object oCreature = OBJECT_INVALID;
        oCreature = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oCreature) == TRUE)
        {
            if (GetIsObjectValid(oCreature) == TRUE)
            {
                if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
                {    //   SpawnScriptDebugger();
                    object oOwner = GetLocalObject(oCreature, "X2_G_DayNightObj");
                    // * creature belongs to me
                    if (oOwner == OBJECT_SELF)
                    {
                       // SpawnScriptDebugger();
                      AssignCommand(oCreature, ClearAllActions());
                      AssignCommand(oCreature, JumpToLocation(GetLocalLocation(oCreature, "X2_G_MYORIGIN")));
                    }
                }
                oCreature = GetNextObjectInArea(oArea);
            }
        }
    }
}

