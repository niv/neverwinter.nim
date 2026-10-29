//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(GetSpellId(), oTarget) == TRUE)
    {
        RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(460);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extension

    // Apply effects to the currently selected target.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


