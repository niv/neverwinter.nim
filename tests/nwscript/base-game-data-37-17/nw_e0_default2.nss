///////////////////////////////////////////////////////////////////////////////
//:: Default Notice
//::
//:: NW_E0_Default2.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   This script will begin the attack cycle if the last seen creature belongs
     to an enemy faction.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 5, 2001
//:: Modified By Aidan on Oct 2001
///////////////////////////////////////////////////////////////////////////////

void main()
{
    object oNoticed = GetLastPerceived();
    if(GetIsObjectValid(oNoticed))
    {
        if (GetLastPerceptionSeen() &&
            GetIsEnemy(oNoticed) &&
            !GetIsObjectValid(GetAttackTarget()))
        {
            ClearAllActions();
            //SetListening(OBJECT_SELF,FALSE);
            ActionAttack(oNoticed);
        }
        else if(GetLastPerceptionVanished() &&
                 GetAttackTarget() == oNoticed)
        {
            SignalEvent(OBJECT_SELF,EventEndCombat());
        }
    }
}
