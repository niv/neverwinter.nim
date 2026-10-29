//::///////////////////////////////////////////////
//:: con_q2cdjinthrt
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Checks to see if PC has NOT threatened Djinni before.
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: July 2003
//:://////////////////////////////////////////////
int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(),"DJINNITHREAT")==0;
    return iResult;
}

