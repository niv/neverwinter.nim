// returns true when the player has 5 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 5);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
