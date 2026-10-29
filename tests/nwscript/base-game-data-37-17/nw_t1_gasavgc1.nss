//::///////////////////////////////////////////////
//:: Gas Trap
//:: NW_T1_GasAvgC1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a  5m poison radius gas cloud that
    lasts for 2 rounds and poisons all creatures
    entering the area with Death Blade
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////

void main()
{
    object oTarget;
    effect ePoison = EffectPoison(POISON_DEATHBLADE);

    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget))
    	{
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget);
        }
        oTarget = GetNextInPersistentObject();
    }
}
