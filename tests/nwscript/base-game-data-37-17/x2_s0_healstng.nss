//::///////////////////////////////////////////////
//:: Healing Sting
//:: X2_S0_HealStng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You inflict 1d6 +1 point per level damage to
    the living creature touched and gain an equal
    amount of hit points. You may not gain more
    hit points then your maximum with the Healing
    Sting.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 19, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, 19/10/2003


#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d6(1) + nCasterLvl;

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = 6 + nCasterLvl;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
         nDamage += nDamage / 2;
    }

    //Declare effects
    effect eHeal = EffectHeal(nDamage);
    effect eVs = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eLink = EffectLinkEffects(eVs,eHeal);

    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLink2 = EffectLinkEffects(eVis,eDamage);

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
           //Signal spell cast at event

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Spell resistance
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
                {
                    //Apply effects to target and caster
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
                    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                }
            }
        }
    }
}
