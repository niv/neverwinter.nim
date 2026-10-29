#include "nw_inc_dynlight"

void main()
{
    if(GetIsPC(GetEnteringObject()))
    {
        AutoUpdateLight(FALSE);
    }

    string sOriginalAreaEnterScript = GetLocalString(OBJECT_SELF, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT);
    if(sOriginalAreaEnterScript != "")
    {
        ExecuteScript(sOriginalAreaEnterScript);
    }
}

