//::///////////////////////////////////////////////
//:: ValenCatchUp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if Valen is behind Nathyrra in Romance counter
    (Only valid up to stage 4)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////




int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iValenStage")<=3 &&
              GetLocalInt(GetModule(),"iValenStage") < GetLocalInt(GetModule(),"iNathyrraStage");
    return iResult;
}
