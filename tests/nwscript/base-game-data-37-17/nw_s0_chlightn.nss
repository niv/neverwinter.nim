//::///////////////////////////////////////////////
//:: Chain Lightning
//:: NW_S0_ChLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The primary target is struck with 1d6 per caster,
    1/2 with a reflex save.  1 secondary target per
    level is struck for 1d6 / 2 caster levels.  No
    repeat targets can be chosen.
*/
//:://////////////////////////////////////////////
//:: Created By: Brennon Holmes
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 26, 2001
//:: Update Pass By: Preston W, On: July 26, 2001

/*
bugfix by Kovi 2002.07.28
- successful saving throw and (improved) evasion was ignored for
 secondary targets,
- all secondary targets suffered exactly the same damage
2002.08.25
- primary target was not effected
*/

#include "x0_I0_SPELLS"
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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    //Limit caster level
    // June 2/04 - Bugfix: Cap the level BEFORE the damage calculation, not after. Doh.
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }
    int nDamage = d6(nCasterLevel);
    int nDamStrike;
    int nNumAffected = 0;
    int nMetaMagic = GetMetaMagicFeat();
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);;
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = 6 * nCasterLevel;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2); //Damage/is +50%
    }
    //Damage the initial target
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
        //Make an SR Check
        if (!MyResistSpell(OBJECT_SELF, oFirstTarget))
        {
            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamStrike = GetReflexAdjustedDamage(nDamage, oFirstTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
            //Set the damage effect for the first target
            eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_ELECTRICAL);
            //Apply damage to the first target and the VFX impact.
            if(nDamStrike > 0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
            }
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);


    float fDelay = 0.2;
    int nCnt = 0;


    // *
    // * Secondary Targets
    // *


    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget) && nCnt < nCasterLevel)
    {
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
            //Do an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                nDamage = d6(nCasterLevel) ;

                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * nCasterLevel;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/is +50%
                }
                //Adjust damage via Reflex Save or Evasion or Improved Evasion
                nDamStrike = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
                //Apply the damage and VFX impact to the current target
                eDamage = EffectDamage(nDamStrike /2, DAMAGE_TYPE_ELECTRICAL);
                if(nDamStrike > 0) //age > 0)
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
            eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nCnt++;
        }

        // April 2003: Setting the new origin for the beam
       // oFirstTarget = oTarget;

        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
      }
 }
