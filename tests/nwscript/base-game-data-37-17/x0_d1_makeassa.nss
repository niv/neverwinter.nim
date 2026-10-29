// This script is run to allow the player to become an Assassin. It sets the local variable to let the player take
// the class.

#include "x0_i0_partywide"

void main()
{
    object oPC = GetPCSpeaker();
    SetLocalIntOnAll(oPC, "X1_AllowAsasin", TRUE);
}
