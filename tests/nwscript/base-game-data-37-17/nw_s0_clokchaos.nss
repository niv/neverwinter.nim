//::///////////////////////////////////////////////
//:: Cloak of Chaos
//:: NW_S0_CloakChaos.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////


void main()
{
    effect eVis = EffectVisualEffect(VFX_IMP_CHAOS_HELP);
    object oTarget = GetSpellTargetObject();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);;
}

