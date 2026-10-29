// fourth question has not been asked yet

int StartingConditional()
{
    int iResult;

    iResult = ((GetLocalInt(GetModule(), "Valen_Tale_4") == 0) &&
               (GetGender(GetPCSpeaker()) == GENDER_FEMALE));
    return iResult;
}
