//::///////////////////////////////////////////////
//:: iNathyrraStage1x
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The iNathyrraStage1 variable is at 1
   (Player can ask follow up qestions to romance stage 1)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage1")==1;
    return iResult;
}

