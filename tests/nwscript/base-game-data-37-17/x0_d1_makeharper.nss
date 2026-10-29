// This script is run to allow the player to become a Harper. It gives the player
// a copy of the Harper pin and sets the local variable to let the player take
// the Harper class. Although it only gives one copy of the pin, the variable
// gets set on all party members.

#include "x0_i0_partywide"

void main()
{
    object oPC = GetPCSpeaker();
    CreateItemOnObject("x1_harperpin", oPC);
    SetLocalIntOnAll(oPC, "X1_AllowHarper", TRUE);
}
