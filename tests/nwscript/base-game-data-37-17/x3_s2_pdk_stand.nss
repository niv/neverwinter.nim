//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Final Stand
//:: x3_s2_pdk_stand.nss
//:://////////////////////////////////////////////
//:: Add temporary hitpoints to friends in spell
//:: sphere.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////
/*
    Modified By : gaoneng erick
    Modified On : may 6, 2006
    added custom vfx
*/


void main()
{
    object oPDK = OBJECT_SELF;
    int nCount = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPDK) + GetAbilityModifier(ABILITY_CHARISMA, oPDK);

    int nHP = d10(2);
    effect eHP = EffectTemporaryHitpoints(nHP);// Increase hit points
    eHP = ExtraordinaryEffect(eHP);// Make effect ExtraOrdinary
    effect eVis = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), oPDK));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_FINAL_STAND), oPDK);

    int nTargetsLeft = nCount;// Number of targets equals level

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

    // Cycle through the targets within the spell shape until you run out of targets.
    while (GetIsObjectValid(oTarget) && nTargetsLeft > 0)
    {
        if(oTarget == OBJECT_SELF)
        {
            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCount));
            // Every time you apply effects, count down remaining targets
            nTargetsLeft -= 1;

        }
        else if(GetIsNeutral(oTarget) || GetIsFriend(oTarget))
        {
            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCount));
            // Every time you apply effects, count down
            nTargetsLeft -= 1;
        }

        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    }
}
