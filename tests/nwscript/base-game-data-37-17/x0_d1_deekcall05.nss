// Deekin now calls the PC by their gender

void main()
{
    string sCall;
    int nSex = GetGender(GetPCSpeaker());
    if (nSex == GENDER_FEMALE)
    {
        sCall = GetStringByStrRef(40568, GetGender(GetPCSpeaker()));
    }
    else
    {
        sCall = GetStringByStrRef(4939, GetGender(GetPCSpeaker()));
    }

    SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall, GetPCSpeaker());
    SetCustomToken(1001, sCall);
}
