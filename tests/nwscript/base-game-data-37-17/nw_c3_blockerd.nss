///////////////////////////////////////////////////////////////////////////////
//:: Blocker (User Defined)
//::
//:: NW_C3_BlockerD
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   The event in this script is signaled by the defended object.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 5, 2001
///////////////////////////////////////////////////////////////////////////////
void main()
{
    int nEvent = GetUserDefinedEventNumber();
    switch (nEvent)
    {
        case 1:
            object oBlockee = GetObjectByTag("BL_" + GetTag(OBJECT_SELF));

            object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE,oBlockee);
            if(GetIsFriend(oTarget) == FALSE && GetObjectSeen(oTarget))
            {
                AdjustReputation(oTarget,GetFaction(OBJECT_SELF), -100);
                SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oTarget);
                ActionAttack(oTarget);
            }
        break;
    }
}
