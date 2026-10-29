// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_WOUNDING_WHISPERS, OBJECT_SELF);
    return iResult;
}

