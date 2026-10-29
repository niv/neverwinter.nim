//::///////////////////////////////////////////////
//:: Ferocity 3
//:: NW_S1_Feroc3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Dex and Str of the target increases
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    int nIncrease = 9;
    //Determine the duration by getting the con modifier
    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION);

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nIncrease);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eDur);

    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
    //effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_FEROCITY_3, FALSE));
    if (nCon > 0)
    {
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
    }
}
