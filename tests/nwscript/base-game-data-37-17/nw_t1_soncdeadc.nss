//::///////////////////////////////////////////////
//:: Deadly Sonic Trap
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 4 rounds and 8d4 damage
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget;
    int nDamage;
    effect eDam;
    effect eStun = EffectStunned();
    effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eStun, eMind);
    //effect eDam;
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(GetEnteringObject()));
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    while (GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Roll damage
            nDamage = d4(8);
            //Make a Will roll to avoid being stunned
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 20, SAVING_THROW_TYPE_TRAP))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            //Apply the VFX impact and damage effect
            DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            //Get the next target in the spell area
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    }
}

