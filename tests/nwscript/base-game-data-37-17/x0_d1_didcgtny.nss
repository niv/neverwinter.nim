//::///////////////////////////////////////////////
//:: Adjust 1 point to chaotic good
//:: x0_d1_didcgtny
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward chaotic good 1 point on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    AdjustAlignment( oPC, ALIGNMENT_CHAOTIC, 1 );
    AdjustAlignment( oPC, ALIGNMENT_GOOD, 1 );
}
