//::///////////////////////////////////////////////
//:: Alternate On Enter for Module
//:: x3_mod_alt_enter
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script adds the horse menus to the PCs,
     and preloads horse animations without delay.
     (see the comment for further information)
*/
//:://////////////////////////////////////////////
//:: Created By: Azbest
//:: Created On: April 18th, 2008
//:: Last Update: April 21th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"

void main()
{
    object oPC=GetEnteringObject();
    ExecuteScript("x3_mod_pre_enter",OBJECT_SELF); // Override for other skin systems
    if ((GetIsPC(oPC)||GetIsDM(oPC))&&!GetHasFeat(FEAT_HORSE_MENU,oPC))
    { // add horse menu
        HorseAddHorseMenu(oPC);                                 //  let's add some horse menu, shall we?
        if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB"))
        { // restore PC horse status from database
            DelayCommand(2.0,HorseReloadFromDatabase(oPC,X3_HORSE_DATABASE));
        } // restore PC horse status from database
    } // add horse menu
    if (GetIsPC(oPC))
    { // more details
        if (!GetSkinInt(oPC,"bX3_IS_MOUNTED")) HorseIfNotDefaultAppearanceChange(oPC); // in case you export your character in mounted form, etc.
        HorsePreloadAnimations(oPC);                            //  pre-cache animations for player, so that the animation is fluid without hiccups (when there is lots of models with lots of animations in the entering area, the nwn engine is under heavy strain and camera may get locked until next phenotype change, which may not happen until you mount a horse or otherwise change your phenotype, so use "x3_mod_def_enter" with a delay or increase the delay until its flawless)
        DelayCommand(3.0,HorseRestoreHenchmenLocations(oPC));
    } // more details
}
