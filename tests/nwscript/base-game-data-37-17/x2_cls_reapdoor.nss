//::///////////////////////////////////////////////
//:: Name x2_cls_reapdoor.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When the reaper door trigger is exited - which
    could happen either if the PC decides not to
    use a particular door, or by actually using the
    door and being transported elsewhere - the
    door will appear to move up to its original
    position, by destroying and recreating itself.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 16/03
//:://////////////////////////////////////////////

void main ()
{
    //Get the door that is now open and on the ground
    object oDoor = GetObjectByTag("x2_reapdoor" + GetStringRight(GetTag(OBJECT_SELF), 1));
    //Close the door
    AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    //Get the position of the door that's on the ground
    vector vDoor = GetPosition(oDoor);
    //Create a new position that is back up in the air to create the door at
    vector vNewDoor = Vector(vDoor.x, vDoor.y, 3.5);
    //Create the location from the above vector
    location lDoor = Location(GetArea(OBJECT_SELF), vNewDoor, GetFacing(oDoor));
    //Apply an effect to the door as it closes and rises
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), GetLocation(oDoor));
    //Destroy the lower door
    DestroyObject(oDoor, 0.2);
    //Create the upper door
    object oNewDoor = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_reapdoor", lDoor, TRUE, "x2_reapdoor" + GetStringRight(GetTag(OBJECT_SELF), 1));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_RED), oNewDoor);
}
