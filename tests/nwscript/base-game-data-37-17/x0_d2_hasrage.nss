// if Xanos has a Rage available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_BARBARIAN_RAGE, OBJECT_SELF);
    return iResult;
}
