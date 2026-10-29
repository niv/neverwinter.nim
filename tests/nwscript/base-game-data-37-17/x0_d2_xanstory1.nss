// Xanos has not told a story yet

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story") == 0;
    return iResult;
}
