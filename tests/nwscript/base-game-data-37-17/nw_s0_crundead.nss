//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell summons a Ghoul, Shadow, Ghast, Wight or
    Wraith
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
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
    nDuration = 24;
    effect eSummon;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 11)
    {
        eSummon = EffectSummonCreature("NW_S_GHOUL",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 12) && (nCasterLevel <= 13))
    {
        eSummon = EffectSummonCreature("NW_S_GHAST",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 14) && (nCasterLevel <= 15))
    {
        eSummon = EffectSummonCreature("NW_S_WIGHT",VFX_FNF_SUMMON_UNDEAD); // change later
    }
    else if ((nCasterLevel >= 16))
    {
        eSummon = EffectSummonCreature("NW_S_SPECTRE",VFX_FNF_SUMMON_UNDEAD);
    }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}

