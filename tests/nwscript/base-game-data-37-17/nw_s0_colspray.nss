//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

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
    int nMetaMagic = GetMetaMagicFeat();
    int nHD;
    int nDuration;
    float fDelay;
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink1 = EffectLinkEffects(eSleep, eMind);

    effect eLink2 = EffectLinkEffects(eStun, eMind);
    eLink2 = EffectLinkEffects(eLink2, eDur);

    effect eLink3 = EffectLinkEffects(eBlind, eMind);

    effect eVis1 = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);
    effect eVis3 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);


    //Get first object in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && oTarget != OBJECT_SELF)
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                      nDuration = 3 + d4();
                      //Enter Metamagic conditions
    		          if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		          {
    			         nDuration = 7;//Damage is at max
    		          }
    		          else if (nMetaMagic == METAMAGIC_EMPOWER)
    		          {
    			         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    		          }
    		          else if (nMetaMagic == METAMAGIC_EXTEND)
    		          {
    			         nDuration = nDuration *2;	//Duration is +100%
    		          }

                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)
                    {
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds(nDuration)));
                    }
                    else if(nHD > 2 && nHD < 5)
                    {
                         nDuration = nDuration - 1;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, RoundsToSeconds(nDuration)));                }
                    else
                    {
                         nDuration = nDuration - 2;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration)));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    }
}

