///////////////////////////////////////////////////////////////////////////////
//:: NW_C3_Blocker
//::
//:: NW_C3_Blocker.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   This script should be attached to any event on an object that you want the
    defender to respond to.  This should be used in conjuction with the
    NW_C3_Blocker script set.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 5, 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oDefender = GetLocalObject(OBJECT_SELF,"NW_L_MYDEFENDER");
    if(GetIsObjectValid(oDefender))
    {
        SignalEvent(oDefender,EventUserDefined(1));
    }
}
