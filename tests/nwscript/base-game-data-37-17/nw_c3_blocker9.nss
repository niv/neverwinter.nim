//::///////////////////////////////////////////////
//::
//:: Guard, Blocker.  Setup object I am blocking.
//::
//:: NW_C3_Blocker9.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//::  Takes BL+MyTag and sets the local
//::  NW_L_MYDEFENDER = ObjectSelf
//::
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 8, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    string sIdent = GetTag(OBJECT_SELF);
    SetLocalObject(GetNearestObjectByTag("BL_" + sIdent),"NW_L_MYDEFENDER",OBJECT_SELF);
}
