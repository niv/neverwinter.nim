#include "NW_I0_PLOT"

int StartingConditional()
{
    int iAdvance = GetLocalInt(OBJECT_SELF,"NW_ARTI_PLOT_ADVANCE");
    if (iAdvance == 1 && GetLocalObject(OBJECT_SELF,"NW_ARTI_PLOT_PC") == GetPCSpeaker())
    {
        return TRUE;
    }
    return FALSE;
}

