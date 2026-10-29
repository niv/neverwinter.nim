//::///////////////////////////////////////////////////
//:: X0_S3_ARROW
//:: Fires arrow(s) at the target and surrounding targets
//:: with increasing damage and attack bonuses for higher
//:: caster level. 
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::///////////////////////////////////////////////////


void DoAttack(object oTarget, int nDamageBonus)
{
    // Don't display feedback
    if (TouchAttackRanged(oTarget, FALSE) > 0)
    {
        effect eDamage = EffectDamage(d6() + nDamageBonus, 
                                      DAMAGE_TYPE_PIERCING);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, 
                            eDamage, 
                            oTarget);
    }

}

void main()
{
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    PrintString("Caster level: " + IntToString(nCasterLevel));

    // Temporary kludge for placeable caster level
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE) 
    {
        nCasterLevel = GetReflexSavingThrow(OBJECT_SELF);
    }
    PrintString("New caster level: " + IntToString(nCasterLevel));

    // Determine the level-based changes
    int nExtraTargets = 0;
    int nDamageBonus = 0;
    int nAttackBonus = 0;

    // Possible levels: 1, 4, 7, 11, 15
    if (nCasterLevel < 4) {
        // no changes
    } else if (nCasterLevel < 7) {
        nExtraTargets = 1;
        nDamageBonus = 1;
        nAttackBonus = 1;
    } else if (nCasterLevel < 11) {
        nExtraTargets = 2;
        nDamageBonus = 2;
        nAttackBonus = 2;
    } else if (nCasterLevel < 15) {
        nExtraTargets = 3;
        nDamageBonus = 3;
        nAttackBonus = 3;
    } else {
        nExtraTargets = 4;
        nDamageBonus = 4;
        nAttackBonus = 4;
    }

    // Apply the attack bonus if we should have one
    if (nAttackBonus > 0) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAttackIncrease(nAttackBonus),
                            OBJECT_SELF, 5.0);
    }
        
    object oTarget = GetSpellTargetObject();
    DoAttack(oTarget, nDamageBonus);
    int i=1;
    object oNextTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget);
    for (i=1; i <= nExtraTargets && GetIsObjectValid(oNextTarget); i++) {
        // Fire another arrow at the target, but fakely
        ActionCastFakeSpellAtObject(SPELL_TRAP_ARROW, oNextTarget, 
                                    PROJECTILE_PATH_TYPE_HOMING);
        DoAttack(oNextTarget, nDamageBonus);
        oNextTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, i+1);
    }
        
}
