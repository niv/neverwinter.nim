//::///////////////////////////////////////////////
//:: Carrions Crawler Brain Juice
//:: NW_S0_1Carrion
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Induces Paralysis
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eParal, eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
}
