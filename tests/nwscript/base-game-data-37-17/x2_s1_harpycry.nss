//::///////////////////////////////////////////////
//:: Harpies Captivating Song
//:: x2_s1_harpycry
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will charm any creature failing saving a will throw DC 15 x
    Charm song in a RADIUS_SIZE_HUGE radius for 6 rounds

    If cast by a Shifter Character, the DC is
    15 + Shifter Level /3

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/07/08
//:://////////////////////////////////////////////


#include "X0_I0_SPELLS"

void main()
{
    object oTarget;
    effect eCharm = EffectCharmed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    int nRacial;
    int nDuration = 6;
    float fDelay;
    int nSaveDC;
    if (GetIsPC(OBJECT_SELF))
    {
        int nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) / 3 ;
        if (nShifter<1)
        {
            nShifter = 0;
        }
        nSaveDC = 15 + nShifter;
    }
    else
    {
        nSaveDC = 15;
    }



    // Apply song Effect on Self
    effect eSong = EffectVisualEffect(VFX_DUR_BARD_SONG);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSong, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget) )
    {

        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            nRacial = GetRacialType(oTarget);
            fDelay = GetRandomDelay();
            //Check that the target is humanoid or animal
            if  ((nRacial == RACIAL_TYPE_DWARF) ||
                (nRacial == RACIAL_TYPE_ELF) ||
                (nRacial == RACIAL_TYPE_GNOME) ||
                (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                (nRacial == RACIAL_TYPE_HALFLING) ||
                (nRacial == RACIAL_TYPE_HUMAN) ||
                (nRacial == RACIAL_TYPE_HALFELF) ||
                (nRacial == RACIAL_TYPE_HALFORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Make an SR check
                if (MyResistSpell(OBJECT_SELF, oTarget) <1)
                {
                    //Make a Will save to negate
                    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply the linked effects and the VFX impact
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }

            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    }

}



