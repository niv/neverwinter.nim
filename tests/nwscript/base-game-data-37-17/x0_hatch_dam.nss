/* OnDamaged/OnDeath script for the Deck-summoned hatchlings
 * Transforms them into ancient dragons of the same color.
 */

void DoWyrmSummon(string sResRef, location locSummon)
{
    // This will automatically unsummon the hatchling
    effect eSumm = EffectSummonCreature(sResRef,
                                        VFX_IMP_DISPEL,
                                        0.5);

    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                          eSumm,
                          locSummon);
}

void main()
{
    if (GetLocalInt(OBJECT_SELF, "TRIGGERED")) return;
    SetLocalInt(OBJECT_SELF, "TRIGGERED", TRUE);

    object oCaster = GetMaster();

    // Destroy the hatchling-summoning object
    object oHatchObject = GetLocalObject(oCaster, "X0_DECK_HATCH_OBJECT");
    DestroyObject(oHatchObject);

    // transform the hatchling into appropriate ancient dragon
    string sResRef = GetResRef(OBJECT_SELF);
    if (sResRef == "x0_hatch_good") {
        sResRef = "x0_wyrm_good";
    } else {
        sResRef = "x0_wyrm_evil";
    }

    location locMe = GetLocation(OBJECT_SELF);
    AssignCommand(oCaster, DoWyrmSummon(sResRef, locMe));
}
