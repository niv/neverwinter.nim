//::///////////////////////////////////////////////
//:: Name: x0_plot_items
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Create all plot items in a convenient chest
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 12/03
//:://////////////////////////////////////////////

void main()
{
    location lLoc = GetLocation(OBJECT_SELF);
    CreateObject(OBJECT_TYPE_PLACEABLE, "x2plotchest", lLoc);
}
