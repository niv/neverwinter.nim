//::///////////////////////////////////////////////
//:: NathyrraCatchUp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if Nathyrra is behind Valen in Romance counter
    (Only valid up to stage 4)
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////




int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage")<=3 &&
              GetLocalInt(GetModule(),"iNathyrraStage") < GetLocalInt(GetModule(),"iValenStage");
    return iResult;
}

