//::///////////////////////////////////////////////
//:: Deflecting Force (Su)
//:: x2_s1_defforce
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Deflecting Force
    Prismatic Dragon Supernatural Ability
    The dragon gains his charisma bonus to his
    AC

    For balance reasons, we limit this to
    1 round / level.

    Does not stack

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 19, 2003
//:://////////////////////////////////////////////

void main()
{
    if (! GetHasSpellEffect (GetSpellId()) )
    {
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        int nBonus = GetAbilityModifier(ABILITY_CHARISMA);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
        effect eAC1= EffectACIncrease(nBonus,AC_DEFLECTION_BONUS);
        effect eLink = EffectLinkEffects(eAC1, eDur);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,OBJECT_SELF,RoundsToSeconds(GetHitDice(OBJECT_SELF)));
    }
}
