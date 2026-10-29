//::///////////////////////////////////////////////
//:: Aura of Glory
//:: x2_s0_auraglory.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 Charisma Bonus
 All allies in medium area of effect: +6 Saves against Fear
 All allies in medium area of effect: 1d4 hitpoints healing
 40% chance of disease on the caster when used.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "X0_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-07-07 by Georg Zoeller
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
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = GetMetaMagicFeat();

    effect eChar = EffectAbilityIncrease(ABILITY_CHARISMA, 2);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eChar, eDur);

    int nDuration = GetCasterLevel(OBJECT_SELF); // * Duration 1 turn/level
     if (nMetaMagic == METAMAGIC_EXTEND)	//Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

    // * now setup benefits for allies
        //Apply Impact
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    float fDelay = 0.0;
    eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, 6, SAVING_THROW_TYPE_FEAR);
    effect eHeal = EffectHeal(MaximizeOrEmpower(4,1, nMetaMagic));
    eLink = EffectLinkEffects(eFear, eHeal);
    eLink = EffectLinkEffects(eLink, eDur);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
    	{
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            //Apply VFX impact and bonus effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    
    //Create a disease effect on the caster 40% of the time
    if (d100() < 41)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_DEMON_FEVER), oTarget);
    }

}







