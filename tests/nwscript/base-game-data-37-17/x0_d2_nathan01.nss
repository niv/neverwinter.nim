// the player has not yet spoken to Nathan

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "X1_NATHANSPEAK") == 0;
    return iResult;
}
