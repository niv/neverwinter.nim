// Dorna is on story #3

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "XP1_Dorna_Story") == 2;
    return iResult;
}
