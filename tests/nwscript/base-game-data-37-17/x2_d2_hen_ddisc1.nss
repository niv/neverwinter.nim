// if Deekin has not told the PC about being a dragon disciple already

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(), "x2_hen_deekdisc") == 0;
    return iResult;
}
