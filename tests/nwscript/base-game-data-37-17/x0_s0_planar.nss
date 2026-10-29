//::///////////////////////////////////////////////
//:: Planar Ally
//:: X0_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Modified from Planar binding
//:: Hold ability removed for cleric version of spell

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
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon;
    effect eGate;


    int nRacial = GetRacialType(oTarget);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nDuration == 0)
    {
        nDuration == 1;
    }
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }

    //Set the summon effect based on the alignment of the caster
    float fDelay = 3.0;
    switch (nAlign)
    {
        case ALIGNMENT_EVIL:
            eSummon = EffectSummonCreature("NW_S_SUCCUBUS",VFX_FNF_SUMMON_GATE, fDelay);
            //eGate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
        break;
        case ALIGNMENT_GOOD:
            eSummon = EffectSummonCreature("NW_S_CHOUND", VFX_FNF_SUMMON_CELESTIAL, fDelay);
            //eGate = EffectVisualEffect(219);
        break;
        case ALIGNMENT_NEUTRAL:
            eSummon = EffectSummonCreature("NW_S_SLAADGRN",VFX_FNF_SUMMON_MONSTER_3, 1.0);
            //eGate = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            //fDelay = 1.0;
        break;
    }
    //Apply the summon effect and VFX impact
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}

