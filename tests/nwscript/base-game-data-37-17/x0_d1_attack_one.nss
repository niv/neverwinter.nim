//:://////////////////////////////////////////////////
//:: X0_D1_ONE_ATTACK
/* 
 * This script is used when you want the individual NPC
 * to become hostile and attack from conversation.
 * The speaker will issue the "ATTACK_MY_TARGET" shout, which
 * other faction members may respond to if they have the
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
    object oPC = GetPCSpeaker();
    SetIsTemporaryEnemy(oPC);
    DelayCommand(0.5, DetermineCombatRound(oPC));
    DelayCommand(0.75,
                 SpeakString ("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK));
}
