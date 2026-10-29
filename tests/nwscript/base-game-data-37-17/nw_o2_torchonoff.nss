//::///////////////////////////////////////////////
//:: NW_O2_TORCHONOFF.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Turns the placeable object's animation on
    during the night and off during the day.
*/
//:://////////////////////////////////////////////
//:: Created By:  John Winski
//:: Created On:  February 20, 2002
//:://////////////////////////////////////////////


void main()
{
    if (GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 0 &&
        GetIsNight())
    {
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",1);
    }
    else if (GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 1 &&
             GetIsDay())
    {
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);
    }
}
