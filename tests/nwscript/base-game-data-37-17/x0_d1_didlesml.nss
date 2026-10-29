//::///////////////////////////////////////////////
//:: Adjust 3 points to lawful evil
//:: x0_d1_didlesml
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward lawful evil 3 points on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    AdjustAlignment( oPC, ALIGNMENT_LAWFUL, 3 );
    AdjustAlignment( oPC, ALIGNMENT_EVIL, 3 );
}
