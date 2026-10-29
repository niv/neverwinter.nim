//::///////////////////////////////////////////////
//:: Circle of Death
//:: NW_S0_CircDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster slays a number of HD worth of creatures
    equal to 1d4 times level.  The creature gets a
    Fort Save or dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 1, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Aidan Scanlan
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 25, 2001

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
    object oTarget;
    object oLowest;
    effect eDeath =  EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    int bContinueLoop = FALSE; //Used to determine if we have a next valid target
    int nHD = d4(GetCasterLevel(OBJECT_SELF)); //Roll to see how many HD worth of creature will be killed
    int nMetaMagic = GetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 10;// maximun hd creature affected, set this to 9 so that a lower HD creature is chosen automatically
    //Also 9 is the maximum HD a creature can have and still be affected by the spell
    float fDelay;
    string sIdentifier = GetTag(OBJECT_SELF);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nHD = 4 * GetCasterLevel(OBJECT_SELF);//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nHD = nHD + (nHD/2); //Damage/Healing is +50%
    }
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetSpellTargetLocation());
    //Check for at least one valid object to start the main loop
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.  If no value target exists we do not enter
    // the loop.

    while ((nHD > 0) && (bContinueLoop))
    {
        int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
        bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
        //Get first target creature in loop
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make sure the currect target is not an enemy
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        	{
                //Get a local set on the creature that checks if the spell has already allowed them to save
                bAlreadyAffected = GetLocalInt(oTarget, "bDEATH" + sIdentifier);
                if (!bAlreadyAffected)
                {
                     nCurrentHD = GetHitDice(oTarget);
                     //If the selected creature is of lower HD then the current nLow value and
                     //the HD of the creature is of less HD than the number of HD available for
                     //the spell to affect then set the creature as the currect primary target
                     if(nCurrentHD < nLow && nCurrentHD <= nHD)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get next target in shape to test for a new
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        }
        //Check to make sure that oLowest has changed
        if(bContinueLoop == TRUE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, SPELL_CIRCLE_OF_DEATH));
            fDelay = GetRandomDelay();
            if(!MyResistSpell(OBJECT_SELF, oLowest, fDelay))
            {
                //Make a Fort Save versus death effects
                if(!MySavingThrow(SAVING_THROW_FORT, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest));
                    //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest));
                }
            }
            //Even if the target made their save mark them as having been affected by the spell
            SetLocalInt(oLowest, "bDEATH" + sIdentifier, TRUE);
            //Destroy the local after 1/4 of a second in case other Circles of Death are cast on
            //the creature laster
            DelayCommand(fDelay + 0.25, DeleteLocalInt(oLowest, "bDEATH" + sIdentifier));
            //Adjust the number of HD that have been affected by the spell
            nHD = nHD - GetHitDice(oLowest);
            oLowest = OBJECT_INVALID;
        }
    }
}
