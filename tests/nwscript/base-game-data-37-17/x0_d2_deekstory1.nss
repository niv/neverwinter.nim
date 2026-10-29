// Deekin has not told a story yet

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story") == 0;
    return iResult;
}
