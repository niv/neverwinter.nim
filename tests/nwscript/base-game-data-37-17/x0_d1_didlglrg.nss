//::///////////////////////////////////////////////
//:: Adjust 13 points to lawful good
//:: x0_d1_didlglrg
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward lawful good 13 points on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs, March 10, 2003
void main()
{
    AdjustAlignment(GetPCSpeaker(), ALIGNMENT_GOOD, 13);
    AdjustAlignment(GetPCSpeaker(), ALIGNMENT_LAWFUL, 13);
}
