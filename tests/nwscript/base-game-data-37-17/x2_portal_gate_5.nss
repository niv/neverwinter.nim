//::///////////////////////////////////////////////
//:: Name: x2_portal_gate_5.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Reaper will create a personalized door
    for the PC speaker to take him to his party leader.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 16/03
//:://////////////////////////////////////////////

void CreateDoor(object oPC);

void main()
{
    //ActionPauseConversation();
    AssignCommand(OBJECT_SELF, ActionCastFakeSpellAtLocation(SPELL_ISAACS_LESSER_MISSILE_STORM, GetLocation(GetWaypointByTag("wp_q2eleaderdoor"))));
    object oPC = GetPCSpeaker();
    DelayCommand(3.0, CreateDoor(oPC));
    //DelayCommand(3.5, ActionResumeConversation());

}
void CreateDoor(object oPC)
{
    location lTarget = GetLocation(GetWaypointByTag("wp_q2eleaderdoor"));
    //Apply a little effect for the door
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);
    object oNewDoor = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_leaderdoor", lTarget, FALSE, "L" + GetName(oPC));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE), oNewDoor);
    SetLocalString(oNewDoor, "szOwner", GetName(oPC));
    DelayCommand(1.0, AssignCommand(oNewDoor, ActionStartConversation(oPC, "x2_con_hod_ldoor")));
}

