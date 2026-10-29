//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eLink = EffectLinkEffects(eWeb, eVis);
    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(GetAreaOfEffectCreator(OBJECT_SELF));
    int nDC = 20;
    // * the lower the number the faster you go
    int nSlow = 85 - (GetAbilityScore(oTarget, ABILITY_STRENGTH) * 2);
    if (nSlow <= 0)
    {
        nSlow = 1;
    }

    if (nSlow > 99)
    {
        nSlow = 99;
    }

    effect eSlow = EffectMovementSpeedDecrease(nSlow);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
            {
                    //Entangle effect and Web VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
             }
             //Slow down the creature within the Web
             ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
       }
    }
}
