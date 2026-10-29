// lowers Deekin's like of the PC by 1

void main()
{
    int nLike = GetCampaignInt("Deekin", "Deekin_Like_PC", GetPCSpeaker());
    SetCampaignInt("Deekin", "Deekin_Like_PC", (nLike - 1), GetPCSpeaker());
}
