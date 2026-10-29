// returns true when the player has 3 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 8);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
