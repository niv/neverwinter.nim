// Deekin now calls the PC by their gender

void main()
{
    string sCall1;
    string sCall2;
    int nSex = GetGender(GetPCSpeaker());
    if (nSex == GENDER_FEMALE)
    {
        sCall1 = GetStringByStrRef(4888, GetGender(GetPCSpeaker()));
    }
    else sCall1 = GetStringByStrRef(4928);

    sCall2 = (GetStringByStrRef(40569, GetGender(GetPCSpeaker()))) + sCall1;

    SetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(GetPCSpeaker()), sCall2, GetPCSpeaker());
    SetCustomToken(1001, sCall2);
}
