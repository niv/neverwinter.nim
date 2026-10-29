//::///////////////////////////////////////////////
//:: Does Container Have Anything In It
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


#include "NW_O0_ITEMMAKER"

int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetFirstItemInInventory(GetObjectByTag(GetLocalString(OBJECT_SELF,"NW_L_MYFORGE"))));
    return iResult;
}

