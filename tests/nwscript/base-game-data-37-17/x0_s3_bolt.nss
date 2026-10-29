//:://////////////////////////////////////////////////
//:: X0_S3_BOLT
/*
  Spell script.
  Launches a crossbow bolt at a single target, with
  increasing attack and damage penalties at higher levels.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/08/2002
//:://////////////////////////////////////////////////

void main()
{
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);

    // Temporary kludge for placeable caster level
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE) 
    {
        nCasterLevel = GetReflexSavingThrow(OBJECT_SELF);
    }
    
    // Determine the level-based changes
    int nDamageBonus = 0;
    int nAttackBonus = 0;

    // Possible levels: 1, 4, 7, 11, 15
    if (nCasterLevel < 4) {
        // no changes
    } else if (nCasterLevel < 7) {
        nDamageBonus = 2;
        nAttackBonus = 2;
    } else if (nCasterLevel < 11) {
        nDamageBonus = 4;
        nAttackBonus = 4;
    } else if (nCasterLevel < 15) {
        nDamageBonus = 6;
        nAttackBonus = 6;
    } else {
        nDamageBonus = 8;
        nAttackBonus = 8;
    }

    // Apply the attack bonus if we should have one
    if (nAttackBonus > 0) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAttackIncrease(nAttackBonus),
                            OBJECT_SELF, 5.0);
    }
        
    // Don't display feedback
    if (TouchAttackRanged(oTarget, FALSE) > 0)
    {
        effect eDamage = EffectDamage(d8() + nDamageBonus, 
                                      DAMAGE_TYPE_PIERCING);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, 
                            eDamage, 
                            oTarget);
    }
}

