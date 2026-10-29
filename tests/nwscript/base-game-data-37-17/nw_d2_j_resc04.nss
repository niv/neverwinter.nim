#include "NW_J_RESCUE"

int StartingConditional()
{
    int bCondition =  GetLocalInt(Global(),"NW_Resc_Plot") < 100 &&
                      GetIsObjectValid(GetRingGivenTo()) &&
                      GetRingGivenTo() != GetPCSpeaker();
    return bCondition;
}

