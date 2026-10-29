//::///////////////////////////////////////////////
//:: iNathyrraStage3x
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The iNathyrraStage3 variable is at 1
   (Player can ask follow up qestions to romance stage 3)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage3")==1;
    return iResult;
}

