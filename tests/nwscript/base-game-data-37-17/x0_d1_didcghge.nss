//::///////////////////////////////////////////////
//:: Adjust 25 points to chaotic good
//:: x0_d1_didcghge
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward chaotic good 25 points on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    AdjustAlignment( oPC, ALIGNMENT_CHAOTIC, 25 );
    AdjustAlignment( oPC, ALIGNMENT_GOOD, 25 );
}
