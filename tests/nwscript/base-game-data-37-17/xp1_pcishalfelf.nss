// the PC is a half-elf

int StartingConditional()
{
    int iResult;

    iResult = GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HALFELF;
    return iResult;
}
