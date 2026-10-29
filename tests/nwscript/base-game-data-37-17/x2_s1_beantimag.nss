//::///////////////////////////////////////////////
//:: Beholder Anti Magic cone
//:: x2_s1_beantimag
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Beholder anti magic cone
    30m cone,
    100% spell failure to all targets,
    100% spellresistance to all targets
    9 seconds duration
    No save

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-19
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void DoRemoveEffects(object oTarget)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectSubType(eEff) == SUBTYPE_MAGICAL)
        {
            if (GetEffectType(eEff) != EFFECT_TYPE_DISAPPEARAPPEAR
               && GetEffectType(eEff) != EFFECT_TYPE_SPELL_FAILURE
               )
            {

                RemoveEffect (oTarget, eEff);
            }
        }
        eEff = GetNextEffect(oTarget);
    }
}

void main()
{

    location lTargetLocation = GetSpellTargetLocation();
    effect eDur = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE);
    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    effect eAntiMag = EffectSpellFailure(100);
//    effect eImmune = EffectSpellImmunity();
    eAntiMag = ExtraordinaryEffect(eAntiMag);
    eAntiMag = EffectLinkEffects(eDur, eAntiMag);


    object oTarget;
    float fDuration = 9.0f;
    float fDelay;

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 25.0f, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
            {
               // only dispel AoEs done by creatures
               if (GetObjectType(GetAreaOfEffectCreator(oTarget)) == OBJECT_TYPE_CREATURE)
               {
                   DestroyObject(oTarget,0.1f);
               }
            }
            else
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Set damage effect
                //Apply the VFX impact and effects
                if (!GetIsDM(oTarget) && !GetPlotFlag(oTarget) )
                {
                    if (!GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) && GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") != 10)
                    {
                        DoRemoveEffects(oTarget);
                    }
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAntiMag, oTarget, fDuration));

                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 25.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }










}
