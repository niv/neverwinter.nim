// check if the pc is an elf or half-elf

int StartingConditional()
{
    int nRace = GetRacialType(GetPCSpeaker());
    if ((nRace == RACIAL_TYPE_ELF) || (nRace == RACIAL_TYPE_HALFELF))
    {
        return TRUE;
    }
    return FALSE;
}
