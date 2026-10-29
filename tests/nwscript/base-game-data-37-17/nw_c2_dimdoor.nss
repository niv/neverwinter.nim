//::///////////////////////////////////////////////
//:: NW_C2_DIMDOOR.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Creature randomly hops around
     to enemies during combat.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////

void JumpToWeakestEnemy(object oTarget)
{
    object oTargetVictim = GetFactionMostDamagedMember(oTarget);
    // * won't jump if closer than 4 meters to victim
    if ((GetDistanceToObject(oTargetVictim) > 4.0)   && (GetObjectSeen(oTargetVictim) == TRUE))
    {
        ClearAllActions();
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

//        SpeakString("Jump to " + GetName(oTargetVictim));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
        DelayCommand(0.3,ActionJumpToObject(oTargetVictim));
        DelayCommand(0.5,ActionAttack(oTargetVictim));
    }
}
void main()
{
    // * During Combat try teleporting around
    if (GetUserDefinedEventNumber() == 1003)
    {
        // * if random OR heavily wounded then teleport to next enemy
        if ((Random(100) < 50)  ||  ( (GetCurrentHitPoints() / GetMaxHitPoints()) * 100 < 50) )
        {
           JumpToWeakestEnemy(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY));
        }
    }
}
