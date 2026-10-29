//::///////////////////////////////////////////////
//:: Remove Effects
//:: NW_SO_RemEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Takes the place of
        Remove Disease
        Neutralize Poison
        Remove Paralysis
        Remove Curse
        Remove Blindness / Deafness
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
//#include "NW_I0_SPELLS"
#include "X0_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
    int nSpellID = GetSpellId();
    object oTarget = GetSpellTargetObject();
    int nEffect1;
    int nEffect2;
    int nEffect3;
    int bAreaOfEffect = FALSE;
    
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    //Check for which removal spell is being cast.
    if(nSpellID == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
    {
        nEffect1 = EFFECT_TYPE_BLINDNESS;
        nEffect2 = EFFECT_TYPE_DEAF;
        bAreaOfEffect = TRUE;
    }
    else if(nSpellID == SPELL_REMOVE_CURSE)
    {
        nEffect1 = EFFECT_TYPE_CURSE;
    }
    else if(nSpellID == SPELL_REMOVE_DISEASE || nSpellID == SPELLABILITY_REMOVE_DISEASE)
    {
        nEffect1 = EFFECT_TYPE_DISEASE;
        nEffect2 = EFFECT_TYPE_ABILITY_DECREASE;
    }
    else if(nSpellID == SPELL_NEUTRALIZE_POISON)
    {
        nEffect1 = EFFECT_TYPE_POISON;
        nEffect2 = EFFECT_TYPE_DISEASE;
        nEffect3 = EFFECT_TYPE_ABILITY_DECREASE;
    }


    // * March 2003. Remove blindness and deafness should be an area of effect spell
    if (bAreaOfEffect == TRUE)
    {
        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
        effect eLink;
        
        spellsGenericAreaOfEffect(OBJECT_SELF, GetSpellTargetLocation(), SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,
            SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, eImpact, eLink, eVis,
            DURATION_TYPE_INSTANT, 0.0,
            SPELL_TARGET_ALLALLIES, FALSE, TRUE, nEffect1, nEffect2);
        return;
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    //Remove effects
    RemoveSpecificEffect(nEffect1, oTarget);
    if(nEffect2 != 0)
    {
        RemoveSpecificEffect(nEffect2, oTarget);
    }
    if(nEffect3 != 0)
    {
        RemoveSpecificEffect(nEffect3, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


