//::///////////////////////////////////////////////
//:: Divine Might
//:: x0_s2_divmight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to (turn undead amount) per day the character may add his Charisma bonus to all
    weapon damage for a number of rounds equal to the Charisma bonus.

    MODIFIED JULY 3 2003
    + Won't stack
    + Set it up properly to give correct + to hit (to a max of +20)

    MODIFIED SEPT 30 2003
    + Made use of new Damage Constants
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_itemprop"
void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
   }
   else
   if(GetHasFeatEffect(413) == FALSE)
   {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetCasterLevel(OBJECT_SELF);

        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        if (nCharismaBonus>0)
        {
            int nDamage1 = IPGetDamageBonusConstantFromNumber(nCharismaBonus);

            effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE);
            effect eLink = EffectLinkEffects(eDamage1, eDur);
            eLink = SupernaturalEffect(eLink);

            // * Do not allow this to stack
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_MIGHT, FALSE));

            //Apply Link and VFX effects to the target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
}



