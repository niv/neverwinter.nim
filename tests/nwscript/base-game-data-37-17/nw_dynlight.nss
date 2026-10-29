#include "nw_inc_dynlight"

void main()
{
    int nRunning = GetLocalInt(GetModule(), NW_DYNAMIC_LIGHT_RUNNING);
    if(!nRunning)
    {
        InitializeAllAreas();
        SetLocalInt(GetModule(), NW_DYNAMIC_LIGHT_RUNNING, TRUE);
        AutoUpdateLight(TRUE);
    }
}

