//::///////////////////////////////////////////////
//:: Aura of Frost on Heartbeat
//:: NW_S1_AuraColdC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes frost damage to all within the aura.
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
    int nDamage;
    int nDC = 10 + nHD/3;

    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    object oTarget;
    //Get the first target in the aura of cold
    oTarget = GetFirstInPersistentObject();
    while (GetIsObjectValid(oTarget))
    {
    	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_COLD));
            //Roll damage based on the creatures HD
            nDamage = d4(nHD);
            //Make a Fortitude save for half
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))
            {
                nDamage = nDamage / 2;
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
            //Apply the VFX constant and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        //Get the next target in the aura of cold
        oTarget = GetNextInPersistentObject();
    }
}
