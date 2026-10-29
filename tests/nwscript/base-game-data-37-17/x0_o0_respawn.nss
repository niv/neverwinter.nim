//:://////////////////////////////////////////////////
//:: X0_O0_RESPAWN
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  Respawn handler for XP1.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/10/2002
//:://////////////////////////////////////////////////

#include "nw_i0_plot"
#include "x0_i0_common"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Raise & heal the player, clearing all negative effects
void Raise(object oPlayer);

// Applies an XP and GP penalty
// to the player respawning
void ApplyPenalty(object oDead);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Raise & heal the player, clearing all negative effects
void Raise(object oPlayer)
{
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectResurrection(),
                        oPlayer);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetMaxHitPoints(oPlayer)),
                        oPlayer);

    // Remove negative effects
    RemoveEffects(oPlayer);

    //Fire cast spell at event for the specified target
    SignalEvent(oPlayer,
                EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPlayer);
}


// * Applies an XP and GP penalty
// * to the player respawning
void ApplyPenalty(object oDead)
{
    int nXP = GetXP(oDead);
    int nPenalty = 50 * GetHitDice(oDead);
    int nHD = GetHitDice(oDead);
    // * You can not lose a level with this respawning
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    int nNewXP = nXP - nPenalty;
    if (nNewXP < nMin)
       nNewXP = nMin;
    SetXP(oDead, nNewXP);
    int nGoldToTake =    FloatToInt(0.10 * GetGold(oDead));
    // * a cap of 10 000gp taken from you
    if (nGoldToTake > 10000)
    {
        nGoldToTake = 10000;
    }
    AssignCommand(oDead, TakeGoldFromCreature(nGoldToTake, oDead, TRUE));
    DelayCommand(4.0, FloatingTextStrRefOnCreature(58299, oDead, FALSE));
    DelayCommand(4.8, FloatingTextStrRefOnCreature(58300, oDead, FALSE));
}

//////////////////////////////////////////////////////////////////////////////


void main()
{
    object oRespawner = GetLastRespawnButtonPresser();

    location lRespawn = GetRespawnLocation(oRespawner);

    if (GetIsObjectValid(GetAreaFromLocation(lRespawn))) {
        DBG_msg("Respawn location OK");
        // we have a good respawn location -- go there

        // save the current location
        SetLocalLocation(oRespawner,
                         "NW_L_I_DIED_HERE",
                         GetLocation(oRespawner));

        // Indicate that the respawner died
        SetLocalInt(oRespawner, "NW_L_I_DIED", TRUE);

        // Take XP & Gold
        ApplyPenalty(oRespawner);

        // Jump the PC to the valid respawn location, w/ henchman
        // works even within same area, unlike JumpToLocation
        TransportToLocation(oRespawner, lRespawn);
    } else {
        DBG_msg("Respawn location bad!");
        // * do nothing, just respawn where you are.
    }

    // Heal 'em up
    Raise(oRespawner);
}
