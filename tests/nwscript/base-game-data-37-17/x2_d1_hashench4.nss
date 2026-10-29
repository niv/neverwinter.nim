// returns true when the player has 4 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 4);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
