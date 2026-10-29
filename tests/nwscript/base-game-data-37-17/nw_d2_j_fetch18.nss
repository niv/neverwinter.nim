#include "NW_I0_PLOT"

int StartingConditional()
{
    int l_iResult;

    l_iResult = CheckIntelligenceNormal() && CheckWisdomHigh()  && (HasGold(250,GetPCSpeaker())) ;
    return l_iResult;
}
