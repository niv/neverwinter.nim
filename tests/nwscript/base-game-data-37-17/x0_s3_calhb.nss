// * do caltrop effect each round targets are in it
#include "x0_i0_spells"

void main()
{



    object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     DoCaltropEffect(oTarget);
        //Get next target.
    oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}
