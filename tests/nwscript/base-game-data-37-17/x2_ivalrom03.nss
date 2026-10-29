//::///////////////////////////////////////////////
//:: iValenRom03
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the Valen Romance Level is 5 or more
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


int StartingConditional()
{
    int iResult;

    iResult = ((GetLocalInt(GetModule(),"iValenRomLevel")>=5) &&
               (GetGender(GetPCSpeaker())==GENDER_FEMALE) &&
               (GetLocalInt(GetModule(),"iValenRomance")!=1));
    return iResult;
}
