// Xanos is on story #2

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story") == 1;
    return iResult;
}
