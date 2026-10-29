//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: x2_s1_summbaatez
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an Erinyes to aid the caster in combat
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-24
//:://////////////////////////////////////////////

void main()
{
    effect eSummon = EffectSummonCreature("x2_erinyes",VFX_FNF_SUMMON_MONSTER_3);
    //Summon
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
}
