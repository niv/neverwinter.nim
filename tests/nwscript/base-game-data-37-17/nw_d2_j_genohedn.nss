#include "NW_I0_PLOT"

int StartingConditional()
{
    object oHead = GetItemPossessedBy(GetPCSpeaker(),"HEAD_" + GetTag(OBJECT_SELF));
    if (GetIsObjectValid(oHead))
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}

