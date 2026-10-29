#include "nw_i0_plot"

int StartingConditional()
{
    if (GetLocalInt(GetModule(),"NW_Theft_Plot"+GetTag(OBJECT_SELF)) == 0)
    {
        if (GetPLocalInt(GetPCSpeaker(),"NW_Theft_Plot_Accepted"+GetTag(OBJECT_SELF)) == 1)
        {
            return TRUE;
        }
    }
    return FALSE;
}

