//::///////////////////////////////////////////////
//::
//:: Summon: No Damage
//::
//:: NW_C2_SmNoDamagD.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//:: User defined Event.
//:: Cannot die or take damage.
//:: Will summon creatures whenever this event is fired.
//:: This script summons 'default' guards.
//:: It will normally be overridden by other scripts that
//:: are copies of this one but with the appropriate
//:: guards.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 30, 2001
//::
//:://////////////////////////////////////////////


void main()
{
    if (GetUserDefinedEventNumber() == 10)
    {
        CreateObject(OBJECT_TYPE_CREATURE,"NW_Guard",GetLocation(OBJECT_SELF));
    }
}
