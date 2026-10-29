// returns true when the player has 1 henchman who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 1);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
