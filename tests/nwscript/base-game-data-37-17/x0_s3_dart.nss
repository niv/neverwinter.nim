//::///////////////////////////////////////////////////
//:: X0_S3_DART
//:: Shoots a dart at the target. The dart animation is produced
//:: by the projectile specifications for this spell in the
//:: spells.2da file, so this merely does a check for a hit
//:: and applies damage as appropriate. 
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

void main()
{
    object oTarget = GetSpellTargetObject();

    if (TouchAttackRanged(oTarget, TRUE) > 0)
    {
        effect eDamage = EffectDamage(d8());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
}
