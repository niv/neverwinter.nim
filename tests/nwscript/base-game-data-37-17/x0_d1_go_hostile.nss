//:://////////////////////////////////////////////////
//:: X0_D1_GO_HOSTILE
/* Switch a creature to the Hostile faction and attack.
 * Useful for hostiles that you want to have temporarily friendly --
 * put them in a non-hostile faction, then use this to make them attack.
 * Also unsets the plot flag.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//:://////////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
    ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
    AdjustReputation(GetPCSpeaker(), OBJECT_SELF, -100);
    DelayCommand(0.5, DetermineCombatRound(GetPCSpeaker()));
    DelayCommand(0.7,
                 SpeakString ("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK));
}
