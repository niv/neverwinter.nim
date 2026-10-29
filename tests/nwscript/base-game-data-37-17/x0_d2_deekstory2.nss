// Deekin is on story #2

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story") == 1;
    return iResult;
}
