// Deekin now calls the PC by boss

void main()
{
    string sCall = GetStringByStrRef(40570, GetGender(GetPCSpeaker()));
    SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
    SetCustomToken(1001, sCall);
}
