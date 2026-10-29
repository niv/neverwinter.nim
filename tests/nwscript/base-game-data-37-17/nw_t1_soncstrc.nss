//::///////////////////////////////////////////////
//:: Strong Sonic Trap
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 1 round and 5d4 damage
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
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
        //Roll damage
        nDamage = d4(5);
        //Make a Will roll to avoid being stunned
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 17, SAVING_THROW_TYPE_TRAP))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
        }
        //Set the damage effect
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
        //Apply the VFX impact and damage effect
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    }
}

