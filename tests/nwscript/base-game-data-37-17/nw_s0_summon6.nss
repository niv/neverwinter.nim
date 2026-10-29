//::///////////////////////////////////////////////
//:: Summon Monster VI
//:: NW_S0_Summon6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dire bear to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

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
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon = EffectSummonCreature("NW_S_beardire");
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        int nRoll = d4();
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("NW_S_AIRHUGE");
            break;

            case 2:
                eSummon = EffectSummonCreature("NW_S_WATERHUGE");
            break;

            case 3:
                eSummon = EffectSummonCreature("NW_S_EARTHHUGE");
            break;

            case 4:
                eSummon = EffectSummonCreature("NW_S_FIREHUGE");
            break;
        }
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}
