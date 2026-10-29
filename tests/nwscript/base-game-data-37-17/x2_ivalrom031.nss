//::///////////////////////////////////////////////
//:: iValenRom03
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the Valen Romance Level is 3 or more
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


int StartingConditional()
{
    int iResult;

    iResult = ((GetLocalInt(GetModule(),"iValenRomLevel")>=3) &&
               (GetLocalInt(GetModule(),"iValenRomance")!=1));
    return iResult;
}
