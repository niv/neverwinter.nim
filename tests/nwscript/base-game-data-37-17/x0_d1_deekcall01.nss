// Deekin now calls the PC by their name

void main()
{
    string sCall = GetName(GetPCSpeaker());
    SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
    SetCustomToken(1001, sCall);
}
