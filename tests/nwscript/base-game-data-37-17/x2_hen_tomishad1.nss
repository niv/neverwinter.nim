// if Tomi has a Shadow Evade use available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_SHADOW_EVADE, OBJECT_SELF);
    return iResult;
}
