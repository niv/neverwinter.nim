//::///////////////////////////////////////////////
//:: Shield of Law
//:: NW_S0_ShldLaw.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

void main()
{
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_LAW_HELP);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

