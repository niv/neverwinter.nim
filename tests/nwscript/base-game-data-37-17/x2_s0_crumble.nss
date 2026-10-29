//::///////////////////////////////////////////////
//:: Crumble
//:: X2_S0_Crumble
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// This spell inflicts 1d6 points of damage per
// caster level to Constructs to a maximum of 15d6.
// This spell does not affect living creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003/
//:: 2004-01-02: GZ: Removed Spell resistance check
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "X2_i0_spells"

void DoCrumble (int nDam, object oCaster, object oTarget);

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

    object oCaster  = OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();
    int  nCasterLvl = GetCasterLevel(oCaster);
    int  nType      = GetObjectType(oTarget);
    int  nRacial    = GetRacialType(oTarget);
    int  nMetaMagic = GetMetaMagicFeat();

    //Minimum caster level of 1, maximum of 15.
    if(nCasterLvl == 0)
    {
        nCasterLvl = 1;
    }
    else if (nCasterLvl > 15)
    {
        nCasterLvl = 15;
    }

    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);

    if (nType != OBJECT_TYPE_CREATURE && nType !=  OBJECT_TYPE_PLACEABLE && nType != OBJECT_TYPE_DOOR )
    {
        return;
    }

    if (GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT  &&  GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget) == 0)
    {
        return;
    }

    int nDam = d6(nCasterLvl);

    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDam = 6*nCasterLvl;
    }

    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDam = nDam + nDam/2;
    }
    
    if (nDam>0)
    {
        //----------------------------------------------------------------------
        // * Sever the tie between spellId and effect, allowing it to
        // * bypass any magic resistance
        //----------------------------------------------------------------------
        DelayCommand(0.1f,DoCrumble(nDam, oCaster, oTarget));
    }

}

//------------------------------------------------------------------------------
// This part is moved into a delayed function in order to alllow it to bypass
// Golem Spell Immunity. Magic works by rendering all effects applied
// from within a spellscript useless. Delaying the creation and application of
// an effect causes it to loose it's SpellId, making it possible to ignore
// Magic Immunity. Hacktastic!
//------------------------------------------------------------------------------
void DoCrumble (int nDam, object oCaster, object oTarget)
{
    float  fDist = GetDistanceBetween(oCaster, oTarget);
    float  fDelay = fDist/(3.0 * log(fDist) + 2.0);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
    effect eMissile = EffectVisualEffect(477);
    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eVis = EffectVisualEffect(135);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
}
