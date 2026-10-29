//::///////////////////////////////////////////////
//:: Deathless Master Touch
//:: X2_S2_dthmsttch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to
    kill their foes.

    -Requires melee Touch attack
    -Save vs DC 17 to resist

    Epic:
    -SaveDC raised by +1 for each 2 levels past 10th
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 24, 2003
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "X2_inc_switches"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Declare effects
    effect eSlay = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
    int nSave = 17;

    //* GZ: Handle Epic Save Progression
    int nEpicMod = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF) - 10 ;
    if (nEpicMod>0)
    {
        nSave += (nEpicMod/2);
    }

    //Link effects

    if(TouchAttackMelee(oTarget,TRUE)>0)
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 624));
        //Saving Throw

        if ((GetCreatureSize(oTarget)>CREATURE_SIZE_LARGE )&& (GetModuleSwitchValue(MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH) == TRUE))
        {
            return; // creature too large to be affected.
        }

        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSave, SAVING_THROW_TYPE_NEGATIVE))
        {
            //Apply effects to target and caster
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSlay, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        }
   }

}
