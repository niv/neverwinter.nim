//::///////////////////////////////////////////////
//:: Blade Barrier: On Enter
//:: NW_S0_BladeBarA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{




    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
    int nMetaMagic = GetMetaMagicFeat();
    int nLevel = GetCasterLevel(GetAreaOfEffectCreator());
    //Make level check
    if (nLevel > 20)
    {
        nLevel = 20;
    }
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_BLADE_BARRIER));
        //Roll Damage
        int nDamage = d6(nLevel);
        //Enter Metamagic conditions
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamage = nLevel * 6;//Damage is at max
        }
        else if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);
        }
        //Make SR Check
        if (!MyResistSpell(GetAreaOfEffectCreator(), oTarget) )
        {
            //Adjust damage according to Reflex Save, Evasion or Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC());

            //Set damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
            //Apply damage and VFX
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}

