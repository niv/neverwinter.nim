//::///////////////////////////////////////////////
//:: Black Blade of Disaster
//:: X2_S0_BlckBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greatsword to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, July 28 - 2003


#include "x2_i0_spells"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned()
{
    //Declare major variables
    int nStat;

    // cast from scroll, we just assume +5 ability modifier
    if (GetSpellCastItem() != OBJECT_INVALID)
    {
        nStat = 5;
    }
     else
    {
        int nClass = GetLastSpellCastClass();
        int nLevel = GetLevelByClass(nClass);

        int nStat;

        int nCha =  GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
        int nInt =  GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF);

        if (nClass == CLASS_TYPE_WIZARD)
        {
            nStat = nInt;
        }
        else
        {
            nStat = nCha;
        }

        if (nStat >20)
        {
            nStat =20;
        }

        if (nStat <1)
        {
           nStat = 0;
        }
    }

    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    // Make the blade require concentration
    SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE);
    SetPlotFlag (oSummon,TRUE);
    object oWeapon;
    //Create item on the creature, epuip it and add properties.
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSummon);
    if (nStat > 0)
    {
        IPSetWeaponEnhancementBonus(oWeapon, nStat);
    }
    SetDroppableFlag(oWeapon, FALSE);
}

#include "x2_inc_spellhook"

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


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon = EffectSummonCreature("x2_s_bblade");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;//Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.5, spellsCreateItemForSummoned());
}
