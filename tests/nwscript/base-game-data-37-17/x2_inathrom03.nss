//::///////////////////////////////////////////////
//:: iNathyrraRom03
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the Nathyrra Romance Level is 3 or more
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraRomLevel")>=3 &&
               GetGender(GetPCSpeaker())==GENDER_MALE;
    return iResult;
}

