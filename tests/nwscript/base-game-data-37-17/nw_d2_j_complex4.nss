#include "NW_I0_Plot"
#include "NW_J_COMPLEX"
int StartingConditional()
{
    int bCondition = GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(),GetComplexItem())) && CheckIntelligenceNormal();
    return bCondition;
}

