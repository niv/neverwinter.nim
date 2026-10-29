// if the player has been told about the death system

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(), "X2_L_DEATHINFOREVEALED") == 1;
    return iResult;
}
