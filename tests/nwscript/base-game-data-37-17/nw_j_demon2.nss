//::///////////////////////////////////////////////
//:: NW_J_DEMON2.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Demon tells player he is ready for negotiations
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December 17, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_TALKSTATE") == 5;
    if (iResult == TRUE)
    {   // * prep demon for next line of dialog
        SetLocalInt(OBJECT_SELF, "NW_L_TALKSTATE", 10);
    }
    return iResult;
}
