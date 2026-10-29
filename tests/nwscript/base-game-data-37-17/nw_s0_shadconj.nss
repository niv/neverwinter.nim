//::///////////////////////////////////////////////
//:: Shadow Conjuration
//:: NW_S0_ShadConj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the opponent is clicked on Shadow Bolt is cast.
    If the caster clicks on himself he will cast
    Mage Armor and Mirror Image.  If they click on
    the ground they will summon a Shadow.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

void ShadowBolt (object oTarget, int nMetaMagic);

void main()
{
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCast;
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eVis;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
		nDuration = nDuration *2;	//Duration is +100%
    }

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            nCast = 1;
        }
        else
        {
            nCast = 2;
        }
    }
    else
    {
        nCast = 3;
    }

    switch (nCast)
    {
        case 1:
            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            effect eAC = EffectModifyAC(4, AC_NATURAL_BONUS);
            effect eMirror = EffectVisualEffect(VFX_DUR_MIRROR_IMAGE);
            effect eLink = EffectLinkEffects(eAC, eMirror);
            eLink = EffectLinkEffects(eLink, eVis);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
        case 2:
           if (!ResistSpell(OBJECT_SELF, oTarget))
	       {
              ShadowBolt(oTarget, nMetaMagic);
           }
        case 3:
           eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
           int nCasterLevel = GetCasterLevel(OBJECT_SELF);
           effect eSummon = EffectSummonCreature("sbio_shadow");
           ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
           ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    }
}

void ShadowBolt (object oTarget, int nMetaMagic)
{
    int nDamage;
    int nBolts = GetCasterLevel(OBJECT_SELF)/5;
    int nCnt;
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDam;
    for (nCnt = 0; nCnt < nBolts; nCnt++)
    {
        int nDam = d6(2);
        //Enter Metamagic conditions
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDamage = 12;//Damage is at max
		}
		else if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDamage = nDamage + nDamage/2; //Damage/Healing is +50%
		}
        if (ReflexSave(oTarget, GetSpellSaveDC()))
        {
            nDamage = nDamage/2;
        }
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}


