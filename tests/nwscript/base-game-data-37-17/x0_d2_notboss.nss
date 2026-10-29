// checks to see that the PC has told Deekin to call him something else

int StartingConditional()
{
    int iResult;

    iResult = GetCampaignString("Deekin", "q6_Deekin_Call", GetPCSpeaker()) != "boss";
    return iResult;
}
