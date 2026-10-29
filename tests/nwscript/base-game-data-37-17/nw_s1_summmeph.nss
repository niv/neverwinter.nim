//::///////////////////////////////////////////////
//:: Summon Mephit
//:: NW_S1_SummMeph
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Steam Mephit
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    effect eSummon = EffectSummonCreature("NW_S_MEPSTEAM",VFX_FNF_SUMMON_MONSTER_1);
   // effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //Apply the VFX impact and summon effect
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
}
