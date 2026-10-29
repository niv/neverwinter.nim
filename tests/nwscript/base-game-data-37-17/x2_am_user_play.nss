//::///////////////////////////////////////////////
//:: Custom User Defined Event
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Two components
     a) Hear a shout, respond
     b) send shouts every second
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
void debugit(string s)
{
//    if (GetTag(OBJECT_SELF) == "townchicken")
 //    if (GetTag(OBJECT_SELF) == "towndogchik")
 //     SpeakString(s);
}

void main()
{
    float  nSendEvents = 1.0;

    if (NoPlayerInArea() == TRUE)
    {
        nSendEvents = 100.0;
    }

    //debugit(IntToString(GetCurrentAction(OBJECT_SELF)));
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1004) // ON DIALOGUE
    {

       //debugit("heard some dialog");
        int nListeningPattern = GetListenPatternNumber();
        //SpeakString("I heard");
        if (GetJob() == JOB_TAG_IT)
        {
            //debugit("think I'm it");
            // * move towards shouter
            if (nListeningPattern == LISTEN_IAMNOTIT)
            {
               //debugit("Heard someone who is not it");
               if (GetCurrentAction(OBJECT_SELF) != ACTION_MOVETOPOINT)
               {
                object oShouter = GetLastSpeaker();
                object oNearest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
                // * always move to closest creature
                if (oShouter != oNearest)
                {
                    if (GetJob(oNearest) == JOB_TAG_NOTIT)
                        oShouter = oNearest;
                }
              //  SpeakString("move to " + GetName(oShouter));

               // * caused chugging and freezing
                DelayCommand(nSendEvents, SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_IT_SHOUTS)));
                ActionMoveToObject(oShouter, TRUE, 1.3);
                }
            }
        }
        else
        if (nListeningPattern ==  LISTEN_SOMEONEISIT)
        {
         //debugit("heard the SomeoneIsIt");
            object oIt = GetLastSpeaker();
            if (GetCurrentAction(OBJECT_SELF) != ACTION_MOVETOPOINT)
            {
               // ClearAllActions(); Causes them to move out of bounding region
                ActionMoveAwayFromObject(oIt, TRUE, 10.0);
            }
        }
        //else
        //    debugit(IntToString(nListeningPattern));
    }
    else
    // * I shout that I am it, tell me to shout again
    if (nUser == EVENT_IT_SHOUTS)
    {
        // * should ever second
        if (GetJob() == JOB_TAG_IT)
        {
        //debugit("it");
        //    SpeakString("shooting  it");
            SpeakString("IAMIT", TALKVOLUME_SILENT_TALK);
            event eShout = EventUserDefined(EVENT_IT_SHOUTS);
            object oSelf = OBJECT_SELF;
           // DelayCommand(1.0, SignalEvent(oSelf, eShout));

                        // * shout that I am it and chase nearest child
            // * if I am within 1.0 meters of them they are it
            object oChild = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
            if (GetIsObjectValid(oChild) == TRUE)
            {
                if (GetJob(oChild) == JOB_TAG_NOTIT)
                {
                    // * can only tag someone who is close enough
                    // * and is allowed to be tagged
                    if (GetDistanceToObject(oChild) <= 1.0 && GetLocalInt(oChild, "X2_G_NEVERIT") == 0)
                    {
                        //ClearAllActions();
                        SpeakString("ut: You're It!");
                        ActionSpeakStringByStrRef(3789);
                        SetJob(JOB_TAG_NOTIT);
                        SetJob(JOB_TAG_IT, oChild);
                        DelayCommand(nSendEvents, SignalEvent(oChild, EventUserDefined(EVENT_IT_SHOUTS)));
                        DelayCommand(nSendEvents, SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_NOTIT_SHOUTS)));
                        ClearAllActions(); // * this clear is VERY important, else they seem to get stuck in place
                        ActionMoveAwayFromObject(oChild, TRUE, 10.0);
                    }
                }
           }

        }
    }
    // * I shout that I am not it
    else
    if (nUser == EVENT_NOTIT_SHOUTS)
    {
        if (GetJob(OBJECT_SELF) == JOB_TAG_NOTIT)
        {
        // SpeakString("shooting not it");
        //debugit("not it");
         SpeakString("IAMnotIT", TALKVOLUME_SILENT_TALK);
         event eShout = EventUserDefined(EVENT_NOTIT_SHOUTS);
         object oSelf = OBJECT_SELF;
         DelayCommand(nSendEvents, SignalEvent(oSelf, eShout));
        }
    }
}

