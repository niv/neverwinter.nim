// Deekin is on story #3

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story") == 2;
    return iResult;
}
