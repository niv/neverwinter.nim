//::///////////////////////////////////////////////
//:: Greater Spell Turning
//:: NW_S0_GrSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////


void main()
{
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

