// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_SUMMON_CREATURE_V, OBJECT_SELF);
    return iResult;
}
