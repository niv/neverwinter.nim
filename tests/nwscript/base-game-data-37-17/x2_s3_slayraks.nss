//::///////////////////////////////////////////////
//:: Slay Rakshasa
//:: x2_s3_slayraks
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When hit by an item that cast this spell on hit
    (usually a blessed bolt), an Rakshasa is instantly
    slain

    The spell considers any creature that looks like a
    rakshasha (appearance type) or has Rakshasa in its
    Subrace field vulnerable (to cope with illusions)

*/
//:://////////////////////////////////////////////
//:: Created By: 2003-07-07
//:: Created On: Brent, Georg
//:://////////////////////////////////////////////


void main()
{

    object oBlessedBolt = GetSpellCastItem();
    effect eVis  = EffectVisualEffect(VFX_IMP_DEATH);
    effect eSlay = EffectLinkEffects(eVis,EffectDeath());

    if (GetIsObjectValid(oBlessedBolt) == TRUE)
    {
        object oRak = GetSpellTargetObject();
        if (GetIsObjectValid(oRak) == TRUE)
        {
            int nAppear = GetAppearanceType(oRak);
            if ( nAppear  ==   APPEARANCE_TYPE_RAKSHASA_BEAR_MALE  || nAppear  ==   APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE                 ||
                 nAppear  ==   APPEARANCE_TYPE_RAKSHASA_TIGER_MALE ||  nAppear  ==   APPEARANCE_TYPE_RAKSHASA_WOLF_MALE)
            {
               ApplyEffectToObject(DURATION_TYPE_INSTANT,eSlay,oRak);
            }
            else
            {
               if (FindSubString(GetSubRace(oRak), "Rakshasa") > -1)
               {
                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eSlay,oRak);
               }
            }
        }
    }
}
