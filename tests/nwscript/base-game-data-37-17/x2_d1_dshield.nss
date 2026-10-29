// if  has a LayOnHands available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_DIVINE_SHIELD, OBJECT_SELF);
    return iResult;
}
