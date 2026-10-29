//::///////////////////////////////////////////////
//:: x2_am_makerat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will create a rat.
    Only one rat allowed at a time.
    
    The rat will wander around (uses the townrat set
    of scripts).
    
    If it sees a JOB_HUNTER or enemy it will run
    back to the garbage that created it and another
    rat will be made later
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void main()
{
    int nNumberofRatsMade = GetLocalInt(OBJECT_SELF, "X2_L_RATSMADE");
    if (nNumberofRatsMade == 0)
    {
        CreateRat();
    }
    else
    if (Random(100) > ( (nNumberofRatsMade* 50)))
    {
    //SpeakString("HB: makerat " + IntToString(nNumberofRatsMade) );
        //SpeakString("making a rat %");
        CreateRat();
    }
    
    SpeakString("Go away", TALKVOLUME_SILENT_TALK); // * shouts go away, dogs should
}
