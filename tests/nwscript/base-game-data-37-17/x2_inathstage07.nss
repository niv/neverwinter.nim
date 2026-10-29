//::///////////////////////////////////////////////
//:: iNathyrraStage07
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Checks if Nathyrra Romance is over
  (Set automatically when passing through final door)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage")>=99;
    return iResult;
}

