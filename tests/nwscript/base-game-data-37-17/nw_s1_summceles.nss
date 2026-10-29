//::///////////////////////////////////////////////
//:: Summon Celestial
//:: NW_S0_SummCeles
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Lantern Archon to aid the threatened
    Celestial
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: Dec 14, 2001

void main()
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    effect eSummon = EffectSummonCreature("NW_S_CLANTERN",VFX_FNF_SUMMON_MONSTER_3);
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Apply the VFX impact and summon effect
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
}
