//::///////////////////////////////////////////////
//:: Natures Balance
//:: NW_S0_NatureBal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Reduces the SR of all enemies by 1d4 per 5 caster
    levels for 1 round per 3 caster levels. Also heals
    all friends for 3d8 + Caster Level
    Radius is 15 feet from the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

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
    effect eHeal;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eSR;
    effect eVis2 = EffectVisualEffect(VFX_IMP_BREACH);
    effect eNature = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    int nRand, nNumDice;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = nCasterLevel/3;
    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Set off fire and forget visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    nNumDice = nCasterLevel / 5;
    if(nNumDice == 0)
    {
        nNumDice = 1;
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check to see how the caster feels about the targeted object
        if(GetIsFriend(oTarget))
        {
              //Fire cast spell at event for the specified target
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE, FALSE));
              nRand = d8(3) + nCasterLevel;
              //Enter Metamagic conditions
              if (nMetaMagic == METAMAGIC_MAXIMIZE)
              {
                 nRand = 24 + nCasterLevel;//Damage is at max
              }
              else if (nMetaMagic == METAMAGIC_EMPOWER)
              {
                 nRand = nRand + nRand/2; //Damage/Healing is +50%
              }
              eHeal = EffectHeal(nRand);
              //Apply heal effects
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        else
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE));
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Check for saving throw
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
                {
                      nRand = d4(nNumDice);
                      //Enter Metamagic conditions
                      if (nMetaMagic == METAMAGIC_MAXIMIZE)
                      {
                         nRand = 4 * nNumDice;//Damage is at max
                      }
                      else if (nMetaMagic == METAMAGIC_EMPOWER)
                      {
                         nRand = nRand + (nRand/2); //Damage/Healing is +50%
                      }
                      eSR = EffectSpellResistanceDecrease(nRand);
                      effect eLink = EffectLinkEffects(eSR, eDur);
                      //Apply reduce SR effects
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    }
}

