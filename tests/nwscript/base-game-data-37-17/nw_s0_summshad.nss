//::///////////////////////////////////////////////
//:: Summon Shadow
//:: NW_S0_SummShad.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell powerful ally from the shadow plane to
    battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    effect eSummon;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 7)
    {
        eSummon = EffectSummonCreature("NW_S_SHADOW",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 8) && (nCasterLevel <= 10))
    {
        eSummon = EffectSummonCreature("NW_S_SHADMASTIF",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 11) && (nCasterLevel <= 14))
    {
        eSummon = EffectSummonCreature("NW_S_SHFIEND",VFX_FNF_SUMMON_UNDEAD); // change later
    }
    else if ((nCasterLevel >= 15))
    {
        eSummon = EffectSummonCreature("NW_S_SHADLORD",VFX_FNF_SUMMON_UNDEAD);
    }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}

