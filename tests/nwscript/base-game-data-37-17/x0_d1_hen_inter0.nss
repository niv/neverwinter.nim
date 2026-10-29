//:://////////////////////////////////////////////////
//:: X0_D1_HEN_INTER0
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Turn off the henchman's "I have an interjection" conversation.
The latest interjection will still be available under the
conversation tree.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    SetHasInterjection(GetPCSpeaker(), FALSE);
}
