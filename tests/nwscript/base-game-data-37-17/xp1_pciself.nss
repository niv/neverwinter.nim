// checks to see if the PC is an elf

int StartingConditional()
{
    int iResult;

    iResult = GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_ELF;
    return iResult;
}
