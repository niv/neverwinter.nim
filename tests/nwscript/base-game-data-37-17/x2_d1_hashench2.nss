// returns true when the player has 2 henchmen who is not the speaker

int StartingConditional()
{
    object oHench = GetHenchman(GetPCSpeaker(), 2);
    return oHench != OBJECT_INVALID && oHench != OBJECT_SELF;
}
