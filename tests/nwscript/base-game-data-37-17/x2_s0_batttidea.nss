//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    effect eLink = CreateBadTideEffectsLink();
    effect eLink2 = CreateGoodTideEffectsLink();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eFind;
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    float fDelay;

    //Check faction of spell targets.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a SR check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
            }
        }
    }
    else if(oTarget == oCreator)
    {
        //Apply the VFX impact and linked effects
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
    }
}
