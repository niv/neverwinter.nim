//::///////////////////////////////////////////////
//:: Spell Turning
//:: NW_S0_SpTurn.nss
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
	effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(2));
}

