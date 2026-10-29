//::///////////////////////////////////////////////
//:: x0_s2_blkdead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level 3 - 6:  Summons Ghast
    Level 7 - 10: Doom Knight
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{




   int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    effect eSummon;
    float fDelay = 3.0;
    int nDuration = nLevel;
    if (nLevel >= 7)
        eSummon = EffectSummonCreature("NW_S_DOOMKGHT",VFX_FNF_SUMMON_UNDEAD);
    else
     eSummon = EffectSummonCreature("NW_S_GHAST",VFX_FNF_SUMMON_UNDEAD);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
    
}
