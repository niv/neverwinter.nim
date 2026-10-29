// * is the player the last one who died
// * only has memory for the very last player
// * who has been killed
int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(), "NW_L_I_DIED") >= 1;
    return iResult;
}
