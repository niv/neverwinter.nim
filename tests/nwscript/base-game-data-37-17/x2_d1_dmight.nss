// if  has a LayOnHands available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_DIVINE_MIGHT, OBJECT_SELF);
    return iResult;
}
