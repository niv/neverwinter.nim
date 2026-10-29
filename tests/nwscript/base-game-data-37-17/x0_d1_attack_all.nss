//:://////////////////////////////////////////////////
//:: X0_D1_ALL_ATTACK
/* 
 * This script is used when you want the NPC's entire faction 
 * to become hostile and attack as the result of a conversation. 
 * The speaker will issue the "ATTACK_MY_TARGET" shout, which
 * other faction members will respond to if they have the
 * appropriate OnSpawn setting. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//:://////////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{
    AdjustReputation(GetPCSpeaker(), OBJECT_SELF, -100);
    DelayCommand(0.5, DetermineCombatRound(GetPCSpeaker()));
    DelayCommand(0.7,
                 SpeakString ("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK));
}
