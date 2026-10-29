//::///////////////////////////////////////////////
//:: x2_am_user_stray
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Stray dog will run away if told to 'Go away'
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void main()
{
    int nUser = GetUserDefinedEventNumber();

    // * dog shouts out that its a hunter every
    if (nUser ==  EVENT_IAMTHEHUNTER)
    {
        SpeakString("HUNTER", TALKVOLUME_SILENT_TALK);
        object oSelf = OBJECT_SELF;
        DelayCommand(1.0, SignalEvent(oSelf, EventUserDefined(EVENT_IAMTHEHUNTER)));
    }
    else

    if(nUser == 1001) //HEARTBEAT
    {

    }
    else if(nUser == 1002) // PERCEIVE
    {
        object oLastPerceived = GetLastPerceived();
        if (GetIsObjectValid(oLastPerceived) == TRUE)
        {
            if (GetReady(OBJECT_SELF) && GetIsPC(oLastPerceived) == TRUE
               && GetCurrentAction(OBJECT_SELF) != ACTION_MOVETOPOINT
               )
            {
                ActionMoveToObject(oLastPerceived);
                PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
            }
        }

    }
    else if(nUser == 1003) // END OF COMBAT
    {

    }
    else if(nUser == 1004) // ON DIALOGUE
    {
       int nListeningPattern = GetListenPatternNumber();
       // * was told to go away, will now go away
       if (nListeningPattern == LISTEN_GOAWAY)
       {
        object oMeanie = GetLastSpeaker();
        if (GetIsObjectValid(oMeanie) == TRUE && GetDistanceToObject(oMeanie) <= 2.5)
        {
            ActionMoveAwayFromObject(oMeanie, TRUE, 20.0);
            PlayVoiceChat(VOICE_CHAT_PAIN1);
        }
       }
    }
    else if(nUser == 1005) // ATTACKED
    {

    }
    else if(nUser == 1006) // DAMAGED
    {

    }
    else if(nUser == 1007) // DEATH
    {

    }
    else if(nUser == 1008) // DISTURBED
    {

    }

}
