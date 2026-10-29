//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a stream of fiery arrows at the selected
    target that do 4d6 damage per arrow.  1 Arrow
    per 4 levels is created.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:: Updated By: Georg Zoeller, Aug 18 2003: Uncapped
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


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eMissile;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    int nMissiles = (nCasterLvl)/4;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    //Limit missiles to five
    if(nMissiles == 0)
    {
        nMissiles = 1;
    }
    /* Uncapped because PHB does list any cap and we now got epic levels
    else if (nMissiles > 5)
    {
        nMissiles = 5;
    }*/
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_ARROW));
        //Apply a single damage hit for each missile instead of as a single mass
        //Make SR Check
        for (nCnt = 1; nCnt <= nMissiles; nCnt++)
        {
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                //Roll damage
                int nDam = d6(4) + 1;
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                      nDam = 24;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }
                nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
                //Apply the MIRV and damage effect
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));

            }
            // * May 2003: Make it so the arrow always appears, even if resisted
            eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        }
    }
}

