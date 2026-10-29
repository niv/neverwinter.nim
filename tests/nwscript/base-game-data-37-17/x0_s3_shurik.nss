//::///////////////////////////////////////////////////
//:: X0_S3_SHURIK
//:: Shoots a shuriken at the target.
//:: The shuriken animation effect is produced by the 
//:: projectile settings in spells.2da; this impact script
//:: merely does the hit check and applies the damage.
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
