//::///////////////////////////////////////////////
//:: x2_s2_gwdrain
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The shadow gets  special strength drain
    attack, once per round.

    The shifter's spectre form can use this ability
    but is not as effective as a real shadow
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_shifter"

void DoDrain(object oTarget, int nDrain)
{
    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
}

void main()
{
 //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nDrain = d2();

    int nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY_MEDIUM);
    if(oTarget != OBJECT_SELF)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            int nTouch = TouchAttackMelee(oTarget);
            if (nTouch >0)
            {
                if (nTouch ==2)
                {
                    nDrain *=2;
                }
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    if (GetHitDice(oTarget)-nDrain<1)
                    {
                        effect eDeath = EffectDeath(TRUE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget);
                    }
                    else
                    {
                        DelayCommand(0.1f,DoDrain(oTarget,nDrain));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
        }
    }
}
