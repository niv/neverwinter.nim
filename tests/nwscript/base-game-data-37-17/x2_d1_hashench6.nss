// returns true when the player has 6 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 6);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
