//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Fear ability
//:: x3_s2_pdk_fear.nss
//:://////////////////////////////////////////////
//:: Identical to the Fear Spell, except it uses
//:: the PDK's character level
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/* -----------------------------------------------------------------
Spellcast Hook Code
Added 2003-06-20 by Georg
If you want to make changes to all spells,
check x2_inc_spellhook.nss to find out more */

    if (!X2PreSpellCastCode())
    {
// If code within the PreSpellCastHook (i.e. UMD)
// reports FALSE, do not run this spell
        return;
    }
// End - Spell Cast Hook -------------------------------------------


    // Declare/assign major variables
    int nDamage;// Will hold damage value
    float fDelay;// For delay value
    object oTarget;// Target object
    int nCasterLevel = GetHitDice(OBJECT_SELF);// Character level for caster level
    int nMetaMagic = GetMetaMagicFeat();// Determine the meta magic used on last spell cast
    float fDuration = RoundsToSeconds(nCasterLevel);// Determine duration based on level
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);// Get VFX
    effect eFear = EffectFrightened();// Get Frightened effect
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);// Get VFX
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);// Get VFX
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);// Get VFX

    // Link the fear and mind effects
    effect eLink = EffectLinkEffects(eFear, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    // Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    // Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);

    // Keep processing targets until no valid ones left
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay();

            // Cause the SpellCastAt event to be triggered on oTarget
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));

            // Make SR Check
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Make a will save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
}
