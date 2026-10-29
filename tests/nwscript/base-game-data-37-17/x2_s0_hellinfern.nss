//::///////////////////////////////////////////////
//:: Hellish Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    NPC only spell for yaron

    like normal inferno but lasts only 5 rounds,
    ticks twice per round, adds attack and damage
    penalty.

*/
//:://////////////////////////////////////////////
// Georg Z, 19-10-2003
//:://////////////////////////////////////////////


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"


void RunImpact(object oTarget, object oCaster);

void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF)/2;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;
    }
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    if (nDuration >6)
    {
        nDuration= 6;
    }


    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

    if(!MyResistSpell(OBJECT_SELF, oTarget))
    {
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f);
        effect eAttackDec = EffectAttackDecrease(4);
        effect eDamageDec = EffectDamageDecrease(4);
        effect eLink = EffectLinkEffects(eAttackDec, eDamageDec);
        effect eDur = EffectVisualEffect(498);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)));
        object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
        DelayCommand(fDelay,RunImpact(oTarget, oSelf));
    }
    else
    {
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
    }

}


void RunImpact(object oTarget, object oCaster)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(762,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //* GZ: Removed Meta magic, does not work in delayed functions
        effect eDam  = EffectDamage(d6(2), DAMAGE_TYPE_FIRE);
        effect eDam2 = EffectDamage(d6(1), DAMAGE_TYPE_DIVINE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam2,oTarget);
        DelayCommand(3.0f,RunImpact(oTarget,oCaster));
    }
}

