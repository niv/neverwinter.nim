//::///////////////////////////////////////////////
//::
//:: Commoner Heartbeat
//::
//:: NW_C2_Commoner1.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Commoners return to their stored location
//:: after hostilities are over.
//::
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 30, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    // TEMP: Should be checking to see if any hostiles are around
    if (GetLocalInt(OBJECT_SELF,"NW_L_GENERICCommonerStoreLocationBoolean") == TRUE)
    {
        ActionMoveToLocation(GetLocalLocation(OBJECT_SELF,"NW_L_GENERICCommonerStoreLocation"));
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICCommonerStoreLocationBoolean",FALSE);
    }
}
