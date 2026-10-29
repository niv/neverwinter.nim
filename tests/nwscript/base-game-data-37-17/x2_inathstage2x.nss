//::///////////////////////////////////////////////
//:: iNathyrraStage1x
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The iNathyrraStage2 variable is at 1
   (Player can ask follow up qestions to romance stage 2)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage2")==1;
    return iResult;
}

