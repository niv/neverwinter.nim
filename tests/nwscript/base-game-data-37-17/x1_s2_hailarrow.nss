//::///////////////////////////////////////////////
//:: x1_s2_hailarrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    One arrow per arcane archer level at all targets

    GZ SEPTEMBER 2003
        Added damage penetration

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"

// GZ: 2003-07-23 fixed criticals not being honored
void DoAttack(object oTarget)
{
    int nBonus = ArcaneArcherCalculateBonus();
    int nDamage;
    // * Roll Touch Attack
    int nTouch = TouchAttackRanged(oTarget, TRUE);
    if (nTouch > 0)
    {
        nDamage = ArcaneArcherDamageDoneByBow(nTouch ==2);
        if (nDamage > 0)
        {
            // * GZ: Added correct damage power
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, IPGetDamagePowerConstantFromNumber(nBonus));
            effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget);
        }
    }
}

void main()
{

    object oTarget;

    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
    int i = 0;
    float fDist = 0.0;
    float fDelay = 0.0;

    for (i = 1; i <= nLevel; i++)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i);
        if (GetIsObjectValid(oTarget) == TRUE)
        {
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            fDelay = fDist/(3.0 * log(fDist) + 2.0);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 603));
            effect eArrow = EffectVisualEffect(357);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
            DelayCommand(fDelay, DoAttack(oTarget));
        }
    }

}
