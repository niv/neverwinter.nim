//::///////////////////////////////////////////////
//::
//:: Fighter Henchman Heartbeat script
//::
//:: c_sh_Fighter_HE.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: This script will 'control' a henchman.
//:: Because henchmen can be ordered through a via of interfaces
//:: I am using the heartbeat to 'drive' the henchman.
//::
//:: The L_HenchmanMode local will control what state
//::
//:: LOCALS USED
//:: L_HenchmanRunState
//:: L_HenchmanMode : which mode henchman currently is in.
//:: L_HenchmanMaster: who hired the henchman
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 24, 2001
//::
//:://////////////////////////////////////////////

int GetRunState();
object GetMaster();

void main()
{
/*    ClearAllActions();
    int nMode = GetLocalInt(OBJECT_SELF,"L_HenchmanMode");
    
    switch (nMode)
    {
    // * Follow
    case 1:
        ActionMoveToObject(GetMaster(),GetRunState());
    break;
    // * Guard; guard master
    case 2:
    break;
    // * Say my master's name
    case 3:
        SpeakString("My master is " + IntToString(GetHitpoints(GetMaster())));
    break;

    default:
        ActionRandomWalk();
    break;*/
    }
}
