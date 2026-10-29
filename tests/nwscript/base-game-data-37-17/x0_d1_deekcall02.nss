// Deekin now calls the PC by their name plus "the great"

void main()
{
    string sCall1 = GetName(GetPCSpeaker());
    string sCall = GetStringByStrRef(40564, GetGender(GetPCSpeaker())) + sCall1;
    SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
    SetCustomToken(1001, sCall);
}
