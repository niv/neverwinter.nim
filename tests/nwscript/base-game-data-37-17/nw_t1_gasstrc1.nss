//::///////////////////////////////////////////////
//:: Gas Trap
//:: NW_T1_GasStrC1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a  5m poison radius gas cloud that
    lasts for 2 rounds and poisons all creatures
    entering the area with Dark Reaver Powder
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////

void main()
{
    object oTarget;
    effect ePoison = EffectPoison(POISON_DARK_REAVER_POWDER);

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
