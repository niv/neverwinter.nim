//::///////////////////////////////////////////////
//:: iValenStage2x
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The iValenStage2 variable is at 1
   (Player can ask follow up qestions to romance stage 2)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iValenStage2")==1;
    return iResult;
}
