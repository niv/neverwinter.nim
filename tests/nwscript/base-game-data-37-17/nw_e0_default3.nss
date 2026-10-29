///////////////////////////////////////////////////////////////////////////////
//:: Default End of Combat round
//::
//:: NW_C2_Default3.nss
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Every round of combat, this script will cheack to see if the last
    opponent is still available.  If not, it will check for a new opponent.
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: Sept 4, 2001
//:: Modified By Aidan on Oct 2001
///////////////////////////////////////////////////////////////////////////////
object FindTarget(float fMaxDistance);

void main()
{
    float fFollowDistance = 25.0f;

    // Will only return a valid target if you've attacked it successfully.
    object oTarget = GetAttackTarget();

    if(  GetIsObjectValid(oTarget) &&
         GetDistanceToObject(oTarget) < fFollowDistance &&
         !GetIsDead(oTarget) &&
         GetIsEnemy(oTarget) )
    {
        if ( !GetIsObjectValid(GetAttackTarget()) )
        {
            ActionAttack(oTarget);
         //   SpeakString("I am attacking my valid target now!");
        }
    }
    else
    {
        if ( !GetIsObjectValid(GetAttemptedAttackTarget()) )
        {
            //SpeakString("I'm looking for a new target");
            oTarget = FindTarget(fFollowDistance);
            if(  GetIsObjectValid(oTarget) )
            {
             //   SpeakString("I have a new target, and it's all good.");
                ClearAllActions();
                ActionAttack(oTarget);
            }
            else
            {
             //   SpeakString("I lost him... damn.");
                ClearAllActions();
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
//  FindTarget
///////////////////////////////////////////////////////////////////////////////
/* This function will return the nearest viable Target within the given range
   If none are available, it will return OBJECT_INVALID
*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan  On:
///////////////////////////////////////////////////////////////////////////////


object FindTarget(float fMaxDistance)
{
    int nNth = 1;
    int bFoundTarget = FALSE;
    object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,nNth);
    while ( !bFoundTarget && GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) < fMaxDistance)
    {
        if( !GetIsDead(oTarget) &&
            GetIsEnemy(oTarget)  )
        {
            bFoundTarget = TRUE;
        }
        else
        {
            nNth++;
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,nNth);
        }
    }
    return oTarget;
}
