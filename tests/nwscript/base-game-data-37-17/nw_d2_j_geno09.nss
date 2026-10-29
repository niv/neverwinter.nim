#include "NW_I0_PLOT"

int StartingConditional()
{
    object oHead = GetItemPossessedBy(GetPCSpeaker(),"GENO_HEAD01");
    if (!GetIsObjectValid(oHead))
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}

