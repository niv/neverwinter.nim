#include "nw_inc_dynlight"

void main()
{
    if(GetLocalInt(GetModule(), NW_DYNAMIC_LIGHT_RUNNING))
    {
        DeleteLocalInt(GetModule(), NW_DYNAMIC_LIGHT_RUNNING);
        ResetAllAreas();
    }
}
