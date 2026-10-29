// if  has a LayOnHands available

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_LAY_ON_HANDS, OBJECT_SELF);
    return iResult;
}
