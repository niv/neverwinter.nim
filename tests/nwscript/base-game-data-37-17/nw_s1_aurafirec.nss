//::///////////////////////////////////////////////
//:: Aura of Fire on Heartbeat
//:: NW_S1_AuraElecC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes fire damage to all within the aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nHD = GetHitDice(GetAreaOfEffectCreator());
    nHD = nHD/3+1;
    int nDC = 10 + nHD/3;
    int nDamage = d4(nHD);
    int nDamSave;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    //Get first target in spell area
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
    	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FIRE));
            //Roll damage
            nDamage = d4(nHD);
            //Make a saving throw check
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nHD, SAVING_THROW_TYPE_FIRE))
            {
                nDamage = nDamage / 2;
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}
