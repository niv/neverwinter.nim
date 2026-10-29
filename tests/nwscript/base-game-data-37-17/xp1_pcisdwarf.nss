// the PC is a dwarf

int StartingConditional()
{
    int iResult;

    iResult = GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_DWARF;
    return iResult;
}
