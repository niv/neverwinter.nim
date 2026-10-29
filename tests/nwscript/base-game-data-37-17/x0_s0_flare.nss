//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by ray loses 1 to attack rolls.
    
    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
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
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);


    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

	if(!GetIsReactionTypeFriendly(oTarget))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));

       // * Apply the hit effect so player knows something happened
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


        //Make SR Check
        if ((!MyResistSpell(OBJECT_SELF, oTarget)) &&  (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) == FALSE) )
        {
            //Set damage effect
            effect eBad = EffectAttackDecrease(1);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10));
        }
    }
}


