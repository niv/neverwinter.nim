//::///////////////////////////////////////////////
//:: Blue Whinnis Poison Payload
//:: NW_S0_2BluWhinn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Character is rendered unconscious for 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;
    effect eSleep = EffectSleep();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eSleep, eVis);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
}
