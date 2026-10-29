//::///////////////////////////////////////////////
//:: Summon Huge Elemental
//:: x0_s3_summonelem
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    This spell is used for the various elemental-summoning
    items.
    It does not consider metamagic as it is only used for
    item properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 12/13/02
//:://////////////////////////////////////////////
//:: Latest Update: Andrew Nobbs April 9, 2003

void main()
{
    // Level 1: Air elemental
    // Level 2: Water elemental
    // Level 3: Earth elemental
    // Level 4: Fire elemental

    //Declare major variables
    object oCaster = OBJECT_SELF;
    string sResRef;
    int nLevel = GetCasterLevel(oCaster) - 4;
    float fDuration = 606.0; // Ten turns + one round
    
    // Figure out which creature to summon
    switch (nLevel)
    {
        case 1: sResRef = "X1_S_AIRSMALL"; break;
        case 2: sResRef = "X1_S_WATERSMALL"; break;
        case 3: sResRef = "X1_S_EARTHSMALL"; break;
        case 4: sResRef = "X1_S_FIRESMALL"; break;
    }

    // 0.5 sec delay between VFX and creature creation
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}
