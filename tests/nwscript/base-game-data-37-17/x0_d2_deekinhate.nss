// Deekin really dislikes the PC

int StartingConditional()
{
    int iResult;

    iResult = GetCampaignInt("Deekin", "Deekin_Like_PC", GetPCSpeaker()) < -4;
    return iResult;
}
