//::///////////////////////////////////////////////
//:: x2_am_user_townh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     On bar patrons and others who make use of the
     town hubs
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"
void debugit(string s)
{
  //  SpeakString(s);
}
void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1004) // ON DIALOGUE
    {
        int nListen = GetListenPatternNumber();
        if (nListen != -1)
        {
            if (nListen == LISTEN_MOVETOTOWNHUB)
            {
                //debugit("heard hub shout");
                object oHub = GetLastSpeaker();
                object oOldHub = GetLocalObject(OBJECT_SELF, "X2_MYHUB");
                if (GetIsObjectValid(oOldHub) == TRUE)
                {
                    // * if the hub that is talking to me
                    // * is not my current hub then
                    // * don't go there. Only go to my current hub
                    if (oHub != oOldHub)
                    {   //debugit("returning because hubs do not match");
                    // * November 13 2002: Put in a failsafe, in that if I'm too far
                    // * away from my hub I'll clear my hub
                        if (GetDistanceToObject(oOldHub) > 10.0)
                        {
                            //debugit("clearing hub info " + FloatToString(GetDistanceToObject(oOldHub)));
                            SetLocalObject(OBJECT_SELF, "X2_MYHUB", OBJECT_INVALID);
                        }
                        return;
                    }
                }
                if (GetDistanceToObject(oHub) > 2.4 && GetReady(OBJECT_SELF) == TRUE && GetAmbientBusy(OBJECT_SELF) == FALSE)
                {
                    //debugit("move to old hub");
                    ClearAllActions();
                    ActionMoveToObject(oHub, FALSE, 2.4);
                    // * if I make it there, store this hub as 'my hub'

                    //SpeakString("going to a hub");
                    SetLocalObject(OBJECT_SELF, "X2_MYHUB", oHub);
                }
            }

        }
    }

}

