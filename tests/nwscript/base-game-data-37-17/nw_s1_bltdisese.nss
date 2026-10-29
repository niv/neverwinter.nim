//::///////////////////////////////////////////////
//:: Bolt: Disease
//:: NW_S1_BltDisease
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to infect
    the target with a disease.  The disease used
    is chosen based upon the racial type of the
    caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nRacial = GetRacialType(OBJECT_SELF);
    int nDisease;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_DISEASE));

    //Here we use the racial type of the attacker to select an
    //appropriate disease.
    switch (nRacial)
    {
        case RACIAL_TYPE_VERMIN:
            nDisease = DISEASE_VERMIN_MADNESS;
        break;
        case RACIAL_TYPE_UNDEAD:
            nDisease = DISEASE_FILTH_FEVER;
        break;
        case RACIAL_TYPE_OUTSIDER:
            if(GetTag(OBJECT_SELF) == "NW_SLAADRED")
            {
                nDisease = DISEASE_RED_SLAAD_EGGS;
            }
            else
            {
                nDisease = DISEASE_DEMON_FEVER;
            }
        break;
        case RACIAL_TYPE_MAGICAL_BEAST:
            nDisease = DISEASE_SOLDIER_SHAKES;
        break;
        case RACIAL_TYPE_ABERRATION:
            nDisease = DISEASE_BLINDING_SICKNESS;
        break;
        default:
            nDisease = DISEASE_SOLDIER_SHAKES;
        break;
    }
    //Assign effect and chosen disease
    effect eBolt = EffectDisease(nDisease);
    //Make the ranged touch attack.
    if (TouchAttackRanged(oTarget))
    {
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBolt, oTarget);
    }
}
