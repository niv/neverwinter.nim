// returns true when the player has 9 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 9);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
