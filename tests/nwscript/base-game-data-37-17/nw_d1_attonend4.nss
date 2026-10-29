//::///////////////////////////////////////////////
//:: M2Q2CE_ATTACK
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Attack Nearest PC
*/
//:://////////////////////////////////////////////
//:: Created By: Cori
//:: Created On: January 25, 2002
//:://////////////////////////////////////////////
#include "nw_i0_generic"
void main()
{
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
PLAYER_CHAR_IS_PC);
    DetermineCombatRound(oPC);
}



