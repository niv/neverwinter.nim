//::///////////////////////////////////////////////
//:: Wandering Monster System Debugger
//:: x2_restsys_dbg
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Type runscript x2_restsys_dbg when in DebugMode
    to have this script dump the current Wandering
    Monster settings to the console.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-29
//:://////////////////////////////////////////////
#include "x2_inc_restsys"
void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oPC = OBJECT_SELF;
    struct wm_struct stInfo= WMGetAreaMonsterTable(oArea);

    SendMessageToPC(oPC,"Wandering Monster System Debug");
    SendMessageToPC(oPC,"REMINDER: You need to rest per area once to have correct values displayed here");
    SendMessageToPC(oPC,"2DA: "+ WMGet2DAToUse());
    SendMessageToPC(oPC,"Area: "+ GetName(GetArea(oPC)));
    SendMessageToPC(oPC,"Table:" + stInfo.sTable + "(Row #: " + IntToString(WMGetAreaHasTable(oArea))+")" );
    SendMessageToPC(oPC,"ListenDC: " + IntToString (stInfo.nListenCheckDC));
    SendMessageToPC(oPC,"%Chance for WM Day: " + IntToString(stInfo.nProbabilityDay) );
    SendMessageToPC(oPC,"%Chance for WM Night: " + IntToString(stInfo.nProbabilityNight) );
    SendMessageToPC(oPC,"Day1: " + stInfo.sMonsterDay1 + " (" +IntToString(stInfo.nProbDay1) + "%)");
    SendMessageToPC(oPC,"Day2: " + stInfo.sMonsterDay2 +" (" +IntToString(stInfo.nProbDay2) + "%)");
    SendMessageToPC(oPC,"Day3: " + stInfo.sMonsterDay3 + " (100%)");
    SendMessageToPC(oPC,"Night1: " + stInfo.sMonsterNight1 +" (" +IntToString(stInfo.nProbNight1) + "%)");
    SendMessageToPC(oPC,"Night2: " + stInfo.sMonsterNight2 +" (" +IntToString(stInfo.nProbNight2) + "%)");
    SendMessageToPC(oPC,"Night3: " + stInfo.sMonsterNight3 +  " (100%)");
    SendMessageToPC(oPC,"Disabled:" + IntToString(WMGetWanderingMonstersDisabled(oArea)));
    SendMessageToPC(oPC,"UseDoors: " + IntToString( GetLocalInt(GetArea(oPC),"X2_WM_AREA_USEDOORS")) );
    SendMessageToPC(oPC,"Flood Protection Active:" + IntToString(GetLocalInt(GetArea(oPC),"X2_WM_AREA_FLOODPROTECTION")));
    SendMessageToPC(oPC,"ListenFailureStrRef:" + IntToString(stInfo.nFeedBackStrRefFail));
    SendMessageToPC(oPC,"ListenSuccessStrRef:" + IntToString(stInfo.nFeedBackStrRefSuccess));
  }
