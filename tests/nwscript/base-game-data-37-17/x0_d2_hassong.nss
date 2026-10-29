// if Deekin has a bard song available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF);
    return iResult;
}
