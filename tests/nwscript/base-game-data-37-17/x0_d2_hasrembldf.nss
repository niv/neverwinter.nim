// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, OBJECT_SELF);
    return iResult;
}
