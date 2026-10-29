// the PC is a gnome

int StartingConditional()
{
    int iResult;

    iResult = GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_GNOME;
    return iResult;
}
