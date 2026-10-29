//::///////////////////////////////////////////////
//:: Epic Sonic Trap
//:: X2_T1_SoncEpicC
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 4 rounds and 40d4 damage
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
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
            nDamage = d4(40);
            //Make a Will roll to avoid being stunned
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 30, SAVING_THROW_TYPE_SONIC))
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

