// This script is run to allow the player to become a Shadowdancer. It sets the local variable to let the player take
// the class.

#include "x0_i0_partywide"

void main()
{
    object oPC = GetPCSpeaker();
    SetLocalIntOnAll(oPC, "X1_AllowShadow", TRUE);
}
