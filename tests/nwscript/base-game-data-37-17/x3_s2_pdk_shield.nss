//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Heroic Shield
//:: x3_s2_pdk_shield.nss
//:://////////////////////////////////////////////
//:: Applies a temporary AC bonus to one ally
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:://////////////////////////////////////////////
/*
    Modified By : gaoneng erick
    Modified On : may 6, 2006
    added custom vfx
*/


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nBonus = 4;

    if (GetLocalInt(oPC, "PDKHeroicTracking"))
    {
        FloatingTextStringOnCreature("You can only use this ability once a round", oPC, FALSE);
        return;
    }
    if (oPC == oTarget)
    {
        FloatingTextStringOnCreature("You cannot aid yourself using this ability", oPC, FALSE);
        return;
    }
    if (!GetIsFriend(oTarget))
    {
        FloatingTextStringOnCreature("You cannot aid an enemy using this ability", oPC, FALSE);
        return;
    }

    effect eAC = EffectACIncrease(nBonus);
    effect eVFX = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, RoundsToSeconds(1));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
    SetLocalInt(oPC, "PDKHeroicTracking", TRUE);
    DelayCommand(5.0, DeleteLocalInt(oPC, "PDKHeroicTracking"));
}
