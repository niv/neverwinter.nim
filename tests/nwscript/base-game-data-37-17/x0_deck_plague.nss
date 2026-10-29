/* The OnHeartbeat script for the plague effect object
 * from the Deck of Many Things.
 */

int GetIsDiseased(object oTarget)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if (GetEffectType(eEff) == EFFECT_TYPE_ABILITY_DECREASE)
            return TRUE;
        eEff = GetNextEffect(oTarget);
    }
    return FALSE;
}

void main()
{
    // This script runs every 8 seconds; we should apply the
    // effect only once per game hour (120 seconds)
    int nTicks = GetLocalInt(OBJECT_SELF, "X0_DECK_PLAGUE_TICKS");
    if (nTicks < 15) {
        SetLocalInt(OBJECT_SELF, "X0_DECK_PLAGUE_TICKS", nTicks+1);
        return;
    }
    SetLocalInt(OBJECT_SELF, "X0_DECK_PLAGUE_TICKS", 0);

    // Get the stored target
    object oTarget = GetLocalObject(OBJECT_SELF, "X0_DECK_TARGET");
    if (!GetIsObjectValid(oTarget))
        return;

    // Spasm and occasionally, throw up :-)
    int nSpasmTicks = GetLocalInt(OBJECT_SELF, "X0_DECK_SPASM_TICKS");
    if (nSpasmTicks == 4) {
        SetLocalInt(OBJECT_SELF, "X0_DECK_SPASM_TICKS", 0);
        SetCustomToken(0, GetName(oTarget));
        // FloatingTextStrRefOnCreature(####, oTarget);
        FloatingTextStringOnCreature(GetName(oTarget)
                        + " is momentarily overcome by illness.",
                        oTarget);

        effect eVomit = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
        AssignCommand(oTarget,
              PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 2.0));
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                    eVomit,
                    oTarget);

        // Apply an ability decrease effect if not currently on
        if (!GetIsDiseased(oTarget)) {
            int nAbility = ABILITY_STRENGTH;
            switch (Random(6)) {
            case 0: nAbility = ABILITY_CHARISMA; break;
            case 1: nAbility = ABILITY_DEXTERITY; break;
            case 2: nAbility = ABILITY_CONSTITUTION; break;
            case 3: nAbility = ABILITY_INTELLIGENCE; break;
            case 4: nAbility = ABILITY_WISDOM; break;
            case 5: nAbility = ABILITY_STRENGTH; break;
            }

            effect eAbil = EffectAbilityDecrease(nAbility, 1);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                eAbil,
                                oTarget);
        }
    } else {
        SetLocalInt(OBJECT_SELF, "X0_DECK_SPASM_TICKS", nSpasmTicks+1);
        AssignCommand(oTarget,
              PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, 3.0));
    }


    // Apply a minor bit of damage
    effect eDam = EffectDamage(d4(),
                               DAMAGE_TYPE_MAGICAL,
                               DAMAGE_POWER_PLUS_FIVE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eDam,
                        oTarget);
}

