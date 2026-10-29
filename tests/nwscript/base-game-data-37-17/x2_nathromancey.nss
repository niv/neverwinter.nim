//::///////////////////////////////////////////////
//:: NathyrraRomanceY
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if Nathyrra romance variable at 3
    (Romance forced)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////


int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraRomance")==3;
    return iResult;
}


