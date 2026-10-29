#include "NW_I0_PLOT"
#include "nw_j_fetch"
int StartingConditional()
{
    return CheckCharismaLow() && GetLocalInt(Global(), "NW_J_FETCHPLOT") >= 10;
}

