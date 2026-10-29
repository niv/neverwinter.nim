//::///////////////////////////////////////////////
//:: Empty Body
//:: NW_S2_Empty.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.28
- was not a supernatual effect
*/

void main()
{
    if(!GetHasFeatEffect(FEAT_EMPTY_BODY))
    {
        //Declare major variables
        object oTarget = OBJECT_SELF;
        effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eCover = EffectConcealment(50);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eCover, eVis);
        eLink = EffectLinkEffects(eLink, eDur);

        eLink = SupernaturalEffect(eLink);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_EMPTY_BODY, FALSE));
        int nDuration = GetLevelByClass(CLASS_TYPE_MONK);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
}
