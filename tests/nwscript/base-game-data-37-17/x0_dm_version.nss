//::///////////////////////////////////////////////
//:: x0_dm_version
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script returns the version # for the module.
    
    In the OnModuleLoad event please do the following
    SetLocalString(GetModule(),"NW_S_VERSION", "1.65");
    
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void main()
{
    string sVersion = GetLocalString(GetModule(), "NW_S_VERSION");
    SendMessageToPC(GetFirstPC(), sVersion);
}
