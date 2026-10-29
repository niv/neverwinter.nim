//::///////////////////////////////////////////////
//:: 50% chance of appearing
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = Random(100) >= 50;
    // * turns off the responder from any more looking
    SetLocalInt(OBJECT_SELF, "NW_L_ONTHEMOVE",0);
    return iResult;
}
