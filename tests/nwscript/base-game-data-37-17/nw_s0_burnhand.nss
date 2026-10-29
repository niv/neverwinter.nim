//::///////////////////////////////////////////////
//:: Burning Hands
//:: NW_S0_BurnHand
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A thin sheet of searing flame shoots from your
// outspread fingertips. You must hold your hands
// with your thumbs touching and your fingers spread
// The sheet of flame is about as thick as your thumbs.
// Any creature in the area of the flames suffers
// 1d4 points of fire damage per your caster level
// (maximum 5d4).
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 5, 2001
//:://////////////////////////////////////////////
//:: Last Updated On: April 5th, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 23, 2001

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
    float fDist;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    object oTarget;
    effect eFire;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    //Limit Maximum caster level to keep damage to spell specifications.
    if (nCasterLevel > 5)
    {
        nCasterLevel = 5;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Signal spell cast at event to fire.
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BURNING_HANDS));
            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Make SR check, and appropriate saving throw.
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDist) && oTarget != OBJECT_SELF)
            {
                nDamage = d4(nCasterLevel);
    		    //Enter Metamagic conditions
    		    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		    {
    			     nDamage = 4 * nCasterLevel;//Damage is at max
    		    }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
    		    {
    			     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    		    }
                //Run the damage through the various reflex save and evasion feats
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
