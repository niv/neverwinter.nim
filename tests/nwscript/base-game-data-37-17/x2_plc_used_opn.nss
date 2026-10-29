//::///////////////////////////////////////////////
//:: OnUse: Toggle Open
//:: x2_plc_used_opn
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Simple script to toggle the placeable animation
    state for placeables that support Open and
    Close Animations

    Placeables are best set to be Closed by
    default with this script.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-10
//:://////////////////////////////////////////////
void main()
{
    // * note that nActive == 1 does  not necessarily mean the placeable is active
    // * that depends on the initial state of the object
    int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_OPEN_STATE");
    // * Play Appropriate Animation
    if (!nActive)
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);
    }
    else
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE);
    }
    // * Store New State
    SetLocalInt(OBJECT_SELF,"X2_L_PLC_OPEN_STATE",!nActive);
}
