// if Tomi has a Summon Shadow use available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_SUMMON_SHADOW, OBJECT_SELF);
    return iResult;
}

