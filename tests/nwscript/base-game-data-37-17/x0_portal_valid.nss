//::///////////////////////////////////////////////
//:: x0_portal_valid
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if PC Speaker is valid (i.e.,
   when player talks to the portal stone)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetPCSpeaker());
    return iResult;
}
