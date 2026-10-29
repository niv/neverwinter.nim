// * Returns true if the player bad global has been set
int StartingConditional()
{
    if (GetLocalInt(GetPCSpeaker(), "NW_G_Playerhasbeenbad")  ==  10)
    {
        SetLocalInt(GetPCSpeaker(), "NW_G_Playerhasbeenbad", 0);
        return TRUE;
    }
    return FALSE;
}
