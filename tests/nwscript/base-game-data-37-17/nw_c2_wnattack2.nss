//::///////////////////////////////////////////////
//:: Warning:Attack On Notice
//::
//:: NW_C2_WnAttack2.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: If I see an enemy then attack enemy.
//:://////////////////////////////////////////////
//::
//:: Created By: Brent On: April 30, 2001
//:: Modified by: Aidan on: June 29, 2001
//:://////////////////////////////////////////////

void main()
{
    object oNoticed = GetLastPerceived();
    if(GetIsObjectValid(oNoticed))
    {
        if (GetIsEnemy(oNoticed))
        {
            SetListening(OBJECT_SELF,FALSE);
            ActionAttack(oNoticed);
            SetLocalObject(OBJECT_SELF,"NW_L_TargetOfAttack",oNoticed);
            DelayCommand(3.0,SignalEvent(OBJECT_SELF,EventUserDefined(0)));
        }
    }
}
