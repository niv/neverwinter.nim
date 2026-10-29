//::///////////////////////////////////////////////
//:: Shout if Opened
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Guard, if still alive, will attempt to
    defend the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

#include "NW_J_GUARD"


void main()
{
    // * if player is wearing uniform or has
    // * bargained with the guard, then no alarm is sounded
    string sLocalName = "NW_L_ENTRANCEGRANTED" + GetTag(Global());
    if ((PlayerWearsUniform(GetLastOpenedBy()) == TRUE) || (GetLocalInt(GetLastOpenedBy(), sLocalName) ==1) )
    {
        return;
    }
    else
    {   SpeakString("test");
        string sHelp = "NW_BLOCKER_" + GetTag(OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, "NW_BLOCKER_INTRUDER", GetLastOpenedBy());
        SpeakString(sHelp, TALKVOLUME_SILENT_SHOUT);
    }
}
