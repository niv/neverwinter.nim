// Deekin now calls the PC by their gender

void main()
{
    int nSex = GetGender(GetPCSpeaker());
    string sCall;
    if (nSex == GENDER_FEMALE)
    {
        sCall = GetStringByStrRef(4931, GetGender(GetPCSpeaker()));
        SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
        SetCustomToken(1001, sCall);
    }
    else
    {
        sCall = GetStringByStrRef(4930, GetGender(GetPCSpeaker()));
        SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
        SetCustomToken(1001, sCall);
    }
}
