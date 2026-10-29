//::///////////////////////////////////////////////
//:: Horse Mounting Set Horses Outside Only
//:: x3_fix_horseout
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Makes the module allow horses outside only.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 19th, 2008
//:: Last Update: March 19th, 2008
//::///////////////////////////////////////////////

void main()
{
   SetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY",TRUE);
   SetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND",TRUE);
   SendMessageToPC(OBJECT_SELF,"The module has now been set to allow horses outside only.");
}
