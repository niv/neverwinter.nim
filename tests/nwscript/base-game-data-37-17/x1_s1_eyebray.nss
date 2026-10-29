//::///////////////////////////////////////////////
//:: Eyeball attacks
//:: x1_s1_eyebray
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    By default, the eyeball only has the cold
    attack. On critical its freezing

    2nd attack (familiar) is wounding
    On Critical hit its slowing for 1d3 rounds


*/
//:://////////////////////////////////////////////
//:
//:://////////////////////////////////////////////

int EBGetScaledBoltDamage(int nSpell)
{
    int nLevel = GetHitDice(OBJECT_SELF);
    int nCount = nLevel /5;
    if (nCount == 0)
    {
        nCount =1;
    }

    int nDamage;

    switch (nSpell)
    {
        case 710:
            nDamage = d4(nCount) + (nLevel /2);
            break;
        case 711:
            nDamage = d6(2) + (nCount*2);
            break;
        case 712:
            nDamage = d6(nCount) + (nCount);
            break;
    }

    return nDamage;
}

#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis;
    effect eBolt ;
    int nHit;
    int nDamage;
    int nSpell = GetSpellId();
    int nDC;

    if (nSpell == 710) // cold bolt
    {
        nDamage = EBGetScaledBoltDamage(nSpell);
        eVis = EffectVisualEffect(VFX_IMP_FROST_S);

        eBolt = EffectDamage(nDamage,DAMAGE_TYPE_COLD);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a saving throw check
        nHit = TouchAttackRanged(oTarget);
        if (nHit>0)
        {
           //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

             // if critical hit , freeze for 1 round
           if (nHit ==2)
           {
               effect ePara = EffectParalyze();
               effect eIce = EffectVisualEffect(VFX_DUR_ICESKIN);
               ePara = EffectLinkEffects(eIce,ePara);
               nDC = 10 + (nHD/3);
               if (MySavingThrow(SAVING_THROW_FORT,oTarget, nDC, SAVING_THROW_TYPE_COLD,OBJECT_SELF) == 0)
               {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara,oTarget, RoundsToSeconds(1));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L),oTarget, RoundsToSeconds(d3(2)));
               }
           }
        }
    } else if (nSpell == 711) // inflict wounds
    {
        // Negative Energy should heal undead creatures.
        int bUndead = FALSE;
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            bUndead = TRUE;
        }
        nDamage = EBGetScaledBoltDamage(nSpell);

        if ( bUndead == FALSE )
        {
            eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            eBolt = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
        }
        else
        {
           eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
           eBolt =  EffectHeal(nDamage);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(),!bUndead));
        //Make a saving throw check
        nHit = TouchAttackRanged(oTarget);
        if (nHit>0)
        {
           //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

             // if critical hit , slow for 1 round
           if (nHit ==2 && bUndead == FALSE)
           {
               effect eSlow = EffectSlow();
               nDC = 10 + (nHD/3);
               if (MySavingThrow(SAVING_THROW_FORT,oTarget, nDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF) == 0)
               {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow,oTarget, RoundsToSeconds(d3(2)));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW),oTarget, RoundsToSeconds(d3(2)));
               }
           }
        }
    }else if (nSpell == 712)//Fire
    {
        nDamage = EBGetScaledBoltDamage(nSpell);
        eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eBolt = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a saving throw check
        nHit = TouchAttackRanged(oTarget);
        if (nHit>0)
        {
           //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

             // if critical hit , knockdown for 1 round
           if (nHit ==2)
           {
               effect eKnock = EffectKnockdown();
               int nDC = 10 + (nHD/3);
               if (MySavingThrow(SAVING_THROW_FORT,oTarget, nDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF) == 0)
               {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock,oTarget, RoundsToSeconds(2));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M),oTarget, RoundsToSeconds(d3(2)));
               }
           }
        }
    }
}
