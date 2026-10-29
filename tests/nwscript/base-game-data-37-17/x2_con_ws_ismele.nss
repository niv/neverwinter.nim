//::///////////////////////////////////////////////
//:: x2_con_ws_ismele
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the right hand weapon is melee
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"
#include "x0_i0_match"


int StartingConditional()
{
    int iResult;

    iResult = !GetWeaponRanged(GetRightHandWeapon(GetPCSpeaker()));
    return iResult;
}
