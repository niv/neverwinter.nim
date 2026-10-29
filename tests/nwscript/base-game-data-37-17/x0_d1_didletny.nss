//::///////////////////////////////////////////////
//:: Adjust 1 point to lawful evil
//:: x0_d1_didletny
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Used in conversation to adjust the PC's alignment
    toward lawful evil 1 point on each axis.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/12/02 @ 16:25
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    AdjustAlignment( oPC, ALIGNMENT_LAWFUL, 1 );
    AdjustAlignment( oPC, ALIGNMENT_EVIL, 1 );
}
