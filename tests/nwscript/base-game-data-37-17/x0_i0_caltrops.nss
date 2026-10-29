//:://////////////////////////////////////////////////
//:: X0_I0_CALTROPS
/*
  Small include library for caltrops effect.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/30/2002
//:://////////////////////////////////////////////////

#include "nw_i0_spells"

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Apply the caltrops effect to the specified target.
// Caltrops do 1 point of damage up to 25 total points, then
// are destroyed. 
// This is applied from within the area of effect object.
void DoCaltropsEffect(object oTarget);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

void DoCaltropsEffect(object oTarget)
{
    int nDam = 1;

    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING);

    float fDelay = GetRandomDelay(1.0, 2.2);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, 
                EventSpellCastAt(GetAreaOfEffectCreator(), 
                                 SPELL_GRENADE_CALTROPS));

    //Apply damage
    DelayCommand(fDelay, 
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, 
                                     eDam, 
                                     oTarget));

    int nDamageDone = GetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE");
    nDamageDone++;
    SetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE", nDamageDone);

    if (nDamageDone == 25) {
        object oCaltrops = GetNearestObjectByTag("X0_CALTROPS_OBJ");
        DestroyObject(oCaltrops);
        DestroyObject(OBJECT_SELF, 0.1);
    }
}
