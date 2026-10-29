//::///////////////////////////////////////////////
//:: Clarity
//:: NW_S0_Clarity.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell removes Charm, Daze, Confusion, Stunned
    and Sleep.  It also protects the user from these
    effects for 1 turn / level.  Does 1 point of
    damage for each effect removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eDam = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetSpellTargetObject();
    effect eSearch = GetFirstEffect(oTarget);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }
    int bValid;
    int bVisual;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLARITY, FALSE));
    //Search through effects
    while(GetIsEffectValid(eSearch))
    {
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
        {
            bValid = TRUE;
        }
        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            RemoveEffect(oTarget, eSearch);
            bVisual = TRUE;
        }
        eSearch = GetNextEffect(oTarget);
    }
    float fTime = 30.0  + RoundsToSeconds(nDuration);
    //After effects are removed we apply the immunity to mind spells to the target
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fTime);
}

