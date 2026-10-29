/* The OnHeartbeat script for the oracle effect object
 * from the Deck of Many Things.
 */

int GetHasProtection(object oCaster)
{
    effect eEff = GetFirstEffect(oCaster);
    while (GetIsEffectValid(eEff)) {
        if (GetEffectType(eEff) == EFFECT_TYPE_DAMAGE_REDUCTION)
            return TRUE;
        eEff = GetNextEffect(oCaster);
    }
    return FALSE;
}

void main()
{
    // Get the stored target
    object oTarget = GetLocalObject(OBJECT_SELF, "X0_DECK_TARGET");
    if (!GetIsObjectValid(oTarget))
        return;

    // Don't reapply if we're already protected
    if (GetHasProtection(oTarget))
        return;

    // if the oracle effect is off, reapply it
    effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, 0);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(ePrem, eVis);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}

