//::///////////////////////////////////////////////
//:: Greater Mindblast 10m radius
//:: x2_s1_mblast10
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A psionic wave originating from the creature
    in a 10m foot radius around the creature

    Creatures can save vs the mindblast at a
    -4 modifier or be stunned for 1d3 rounds

    if the creature is already stunned, the
    mind blast does 1d3+casterlevel points of
    damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July 30, 2003
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    object oTarget;
    int nLevel = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    eVis = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),eVis);
    effect eVisStun = EffectVisualEffect(VFX_IMP_DOMINATE_S);

    int nDuration;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    eDur = EffectLinkEffects(EffectStunned(),eDur);

    int nSaveDC = 10 +(GetHitDice(OBJECT_SELF)/2) +  GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

    //Determine enemies in the radius around the bard
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 15.0f, GetLocation(OBJECT_SELF),TRUE,OBJECT_TYPE_CREATURE);
    int nDamage = GetHitDice(OBJECT_SELF);
    effect eDam = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
           if (GetHasSpellEffect(GetSpellId(),oTarget))
           {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
                //nDamage = GetHitDice(OBJECT_SELF);
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
           }
           else
           {
               nDuration = d3();
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
               //Make SR and Will saves
                if (WillSave(oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF)==0)
                {
                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisStun, oTarget);
                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
                }
          }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 15.0f, GetLocation(OBJECT_SELF),TRUE,OBJECT_TYPE_CREATURE);
    }
    //Apply bonus and VFX effects to bard.
}
