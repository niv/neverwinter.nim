//::///////////////////////////////////////////////
//:: ValRomancex
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if Valen romance variable at 2
    (Romance consumated)
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////


int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iValRomance")==2;
    return iResult;
}
