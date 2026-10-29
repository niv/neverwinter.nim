// check if the PC is human

int StartingConditional()
{
    int iResult;

    iResult = GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMAN;
    return iResult;
}
