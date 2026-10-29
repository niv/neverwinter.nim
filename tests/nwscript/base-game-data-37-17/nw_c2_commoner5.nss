//::///////////////////////////////////////////////
//::
//:: Commoner On Attacked
//::
//:: NW_C2_Commoner5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: If I am attacked, I run from my attacker.
//:://////////////////////////////////////////////
//:: Created By: Brent On: April 30, 2001
//:: Modified By: Aidan On June 26, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oAttacker = GetLastAttacker();
    if (GetIsObjectValid(oAttacker))
    {
        ClearAllActions();
        SetListening(OBJECT_SELF,FALSE);
        SetLocalObject(OBJECT_SELF,"NW_L_GENERICCommonerFleeFrom",oAttacker);
        ActionSpeakString("NW_I_WAS_ATTACKED",TALKVOLUME_SILENT_SHOUT);
        ActionMoveAwayFromObject(oAttacker,TRUE);
        DelayCommand(3.0f,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
    }
}
