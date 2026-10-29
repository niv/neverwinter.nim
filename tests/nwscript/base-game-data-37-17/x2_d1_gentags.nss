// Generate custom toekns for multiple henchmen.

void main()
{
    object oPC = GetPCSpeaker();
    int i = 1;
    object oHench = GetHenchman(oPC, i);
    while(oHench != OBJECT_INVALID)
    {
        SetCustomToken(77100 + i, GetName(oHench));
        i++;
        oHench = GetHenchman(oPC, i);
    }
}
