//::///////////////////////////////////////////////
//:: Adjust 3 points to chaotic evil
//:: x0_d1_didcesml
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward chaotic evil 3 points on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs, March 10, 2003
void main()
{
    AdjustAlignment(GetPCSpeaker(), ALIGNMENT_EVIL, 3);
    AdjustAlignment(GetPCSpeaker(), ALIGNMENT_CHAOTIC, 3);
}
