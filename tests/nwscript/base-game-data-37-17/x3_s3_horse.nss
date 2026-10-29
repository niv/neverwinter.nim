//::///////////////////////////////////////////////
//:: Horse Feat Control System
//:: x3_s3_horse
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script handles the Mount,Dismount,Party Mount,Party Dismount,
     and Assign Mount menu feats.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Tweaking By: Martin "Azbest" Psikal
//:: Created On: 2007-18-12
//:: Last Update: April 21th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"

/*
    NOTE: If considering using Party Mount or similar feature
    with your own script and calling it via an ActionCastSpellAtObject() make
    sure you use the CHEAT option.

*/


////////////////////////////////
// PROTOTYPES
////////////////////////////////


void FunctionSummonAndMount(int bAnimate=TRUE); // summon paladin mount and mount
void FunctionHenchmanMount(object oHenchman);


////////////////////////////////////////////////////////////////////[ MAIN ]////
void main()
{
   object oPC=OBJECT_SELF;
   object oTarget=GetSpellTargetObject();
   object oHorse;
   int nN;
   object oHench;
   int nSpellId=GetSpellId();
   int bNoMounts=FALSE;
   object oAreaTarget=GetArea(oPC); // used for mount restriction checking

   if (GetIsEnemy(oTarget)) return; // no assigning enemies

   if (!GetLocalInt(oAreaTarget,"X3_MOUNT_OK_EXCEPTION"))
   { // check for global restrictions
       if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oAreaTarget)) bNoMounts=TRUE;
       else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oAreaTarget)) bNoMounts=TRUE;
   } // check for global restrictions
   if ((GetLocalInt(oTarget,"X3_DOING_HORSE_ACTION")||(GetLocalInt(oPC,"X3_DOING_HORSE_ACTION")&&HorseGetIsAMount(oTarget)))&&nSpellId!=SPELL_HORSE_ASSIGN_MOUNT) return; // abort

   switch(nSpellId)
   { // SPELL/FEAT ID - switch to control horse actions
       case SPELL_HORSE_MOUNT:
       { // Mount Menu Selection
           if (GetLocalInt(GetArea(oPC),"X3_NO_HORSES")||GetLocalInt(GetArea(oPC),"X3_NO_MOUNTING")||bNoMounts)
           { // no mounting in this area
               FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111960),STRING_COLOR_PINK),oPC,FALSE);
               return;
           } // no mounting in this area
           else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_SCRIPT_MOUNT"))>0)
           { // execute alternate script
               ExecuteScript(GetLocalString(oTarget,"X3_HORSE_SCRIPT_MOUNT"),oPC);
               return;
           } // execute alternate script
           if (!HorseGetCanBeMounted(oTarget)&&GetMaster(oTarget)==oPC&&GetLocalInt(oTarget,"bX3_IS_MOUNT")!=TRUE)
           { // Henchman selected - not mountable
               if (HorseGetIsMounted(oTarget))
               { // already mounted
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111961),STRING_COLOR_PINK),oPC,FALSE);
                   return;
               } // already mounted
               oHorse=GetLocalObject(oTarget,"oAssignedHorse");
               if (GetIsObjectValid(oHorse)&&GetDistanceBetween(oHorse,oTarget)<30.0&&GetArea(oHorse)==GetArea(oTarget)&&HorseGetCanBeMounted(oHorse,oTarget))
               { // valid target
                   AssignCommand(oTarget,HorseMount(oHorse,TRUE));
               } // valid target
               else
               { // not valid
                   // check for paladin mount
                   if (GetLevelByClass(CLASS_TYPE_PALADIN,oTarget)>4)
                   { // handle summoning and mounting paladin mount
                       oHorse=HorseGetPaladinMount(oTarget);
                       if (GetIsObjectValid(oHorse)&&GetArea(oHorse)==GetArea(oTarget)&&GetDistanceBetween(oHorse,oTarget)<30.0&&HorseGetCanBeMounted(oHorse,oTarget))
                       { // mount existing paladin mount
                           AssignCommand(oTarget,HorseMount(oHorse,TRUE));
                       } // mount existing paladin mount
                       else if (GetHasFeat(FEAT_PALADIN_SUMMON_MOUNT,oTarget))
                       { // summon paladin mount
                           AssignCommand(oTarget,FunctionSummonAndMount());
                       } // summon paladin mount
                   } // handle summoning and mounting paladin mount
                   else
                   { // not valid
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111962),STRING_COLOR_PINK),oPC,FALSE);
                   } // not valid
               } // not valid
           } // Henchman selected - not mountable
           else
           { // mountable
               if (HorseGetCanBeMounted(oTarget,oPC))
               { // PC Can mount it
                   if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS")&&GetLocalInt(oTarget,"bX3_HAS_SADDLEBAGS"))
                   { // saddlebags
                       //if (GetMaster(oTarget)!=oPC) HorseSetOwner(oTarget,oPC,TRUE);
                       HorseMount(oTarget,TRUE);
                   } // saddlebags
                   else
                   { // not saddlebags
                       HorseMount(oTarget,TRUE);
                   } // not saddlebags
               } // PC Can mount it
               else
               { // not mountable
                   FloatingTextStringOnCreature(HorseGetMountFailureMessage(oTarget,oPC),oPC,FALSE);
               } // not mountable
           } // mountable
           break;
       } // Mount Menu Selection

       case SPELL_HORSE_DISMOUNT:
       { // Dismount Menu Selection
           if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_SCRIPT_DISMOUNT"))>0)
           { // execute alternate script
               ExecuteScript(GetLocalString(oTarget,"X3_HORSE_SCRIPT_DISMOUNT"),oPC);
               return;
           } // execute alternate script
           else if (GetIsObjectValid(oTarget)&&GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
           { // Creature
               if (HorseGetIsMounted(oTarget))
               { // mounted
                   if (oPC==oTarget||GetMaster(oTarget)==oPC)
                   { // valid target
                       if (!GetIsPC(oTarget)) AssignCommand(oTarget,HORSE_SupportDismountWrapper(TRUE,TRUE));
                       else { oHorse=HorseDismount(TRUE,TRUE); }
                   } // valid target
                   else
                   { // cannot order that target to dismount
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111963),STRING_COLOR_PINK),oPC,FALSE);
                   } // cannot order that target to dismount
               } // mounted
               else
               { // not mounted
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111964),STRING_COLOR_PINK),oPC,FALSE);
               } // not mounted
           } // Creature
           else
           { // not a valid target
               FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111965),STRING_COLOR_PINK),oPC,FALSE);
           } // not a valid target
           break;
       } // Dismount Menu Selection

       case SPELL_HORSE_PARTY_MOUNT:
       { // Party Mount Menu Selection
           if (GetLocalInt(GetArea(oPC),"X3_NO_HORSES")||GetLocalInt(GetArea(oPC),"X3_NO_MOUNTING")||bNoMounts)
           { // no mounting in this area
               FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111960),STRING_COLOR_PINK),oPC,FALSE);
               return;
           } // no mounting in this area
           if (GetIsObjectValid(oTarget)&&HorseGetIsAMount(oTarget)&&HorseGetCanBeMounted(oTarget,oPC))
           { // PC mount this target
               HorseMount(oTarget,FALSE);
           } // PC mount this target
           nN=1;
           oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
           while(GetIsObjectValid(oHench))
           { // check to see which henchmen can mount and if possible make them mount
               if (GetLocalInt(oHench,"X3_DOING_HORSE_ACTION")) return;
               if (!HorseGetIsAMount(oHench)&&!HorseGetIsMounted(oHench))
               { // try to mount
                   DelayCommand(IntToFloat(nN)/2.5,FunctionHenchmanMount(oHench));
               } // try to mount
               nN++;
               oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
           } // check to see which henchmen can mount and if possible make them mount
           break;
       } // Party Mount Menu Selection

       case SPELL_HORSE_PARTY_DISMOUNT:
       { // Party Dismount Menu Selection
           if (HorseGetIsMounted(oPC)) HorseDismount(FALSE,TRUE);
           nN=1;
           oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
           while (GetIsObjectValid(oHench))
           { // see which henchmen to dismount
               if (GetLocalInt(oHench,"X3_DOING_HORSE_ACTION")) return;
               if (HorseGetIsMounted(oHench))
               { // dismount
                   DelayCommand(IntToFloat(nN)/2.0,AssignCommand(oHench,HORSE_SupportDismountWrapper(FALSE,TRUE)));
               } // dismount
               nN++;
               oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
           } // see which henchmen to dismount
           break;
       } // Party Dismount Menu Selection

       case SPELL_HORSE_ASSIGN_MOUNT:
       { // Assign Mount Menu Selection
           oHench=GetLocalObject(oPC,"oX3LastAssignClicked");
           if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_SCRIPT_ASSIGN"))>0)
           { // execute alternate script
               ExecuteScript(GetLocalString(oTarget,"X3_HORSE_SCRIPT_ASSIGN"),oPC);
               return;
           } // execute alternate script
           else if (HorseGetIsMounted(oTarget)&&!GetIsPC(oTarget))
           { // mounted
               FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111966),STRING_COLOR_PINK),oPC,FALSE);
               DeleteLocalObject(oPC,"oX3LastAssignClicked");
           } // mounted
           else if (GetStringLeft(GetResRef(oTarget),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX||GetStringLeft(GetResRef(oHench),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX)
           { // Paladin Mount
               if (oHench==oTarget&&HorseGetPaladinMount(oPC)==oTarget)
               { // unsummon
                   DeleteLocalObject(oPC,"oX3LastAssignClicked");
                   AssignCommand(oPC,HorseUnsummonPaladinMount());
               } // unsummon
               else if (GetIsObjectValid(oHench)||HorseGetPaladinMount(oPC)!=oTarget)
               { // not unsummoning
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111967),STRING_COLOR_PINK),oPC,FALSE);
                   DeleteLocalObject(oPC,"oX3LastAssignClicked");
               } // not unsummoning
               else
               { // set for potential unsummon
                   SetLocalObject(oPC,"oX3LastAssignClicked",oTarget);
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111972),STRING_COLOR_WHITE),oPC,FALSE);
               } // set for potential unsummon
           } // Paladin Mount
           else if (HorseGetCanBeMounted(oTarget,OBJECT_INVALID,TRUE))
           { // Horse
               oHorse=GetLocalObject(oPC,"oX3LastAssignClicked");
               if (GetMaster(oTarget)!=oPC&&GetMaster(GetMaster(oTarget))!=oPC&&(GetIsObjectValid(GetMaster(oTarget))||GetLocalInt(oTarget,"X3_HORSE_NOT_RIDEABLE_OWNER")||GetStringLength(GetLocalString(oTarget,"X3_HORSE_OWNER_TAG"))>0))
               { // you do not own that horse
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111968),STRING_COLOR_PINK),oPC,FALSE);
                   DeleteLocalObject(oPC,"oX3LastAssignClicked");
               } // you do not own that horse
               else if (oHorse==oTarget)
               { // double selected mount - releases the mount
                   if (HorseGetOwner(oHorse)==oPC||GetMaster(HorseGetOwner(oHorse))==oPC)
                   { // PC is the owner
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111969),STRING_COLOR_WHITE),oPC,FALSE);
                       HorseRemoveOwner(oHorse);
                       AssignCommand(oHorse,ClearAllActions());
                       DeleteLocalObject(oPC,"oX3LastAssignClicked");
                   } // PC is the owner
                   else
                   { // cannot release unless assigned to you
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111970),STRING_COLOR_PINK),oPC,FALSE);
                       DeleteLocalObject(oPC,"oX3LastAssignClicked");
                   } // cannot release unless assigned to you
               } // double selected mount - releases the mount
               else if (GetIsObjectValid(oHorse))
               { // double assign for horse
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111971),STRING_COLOR_PINK),oPC,FALSE);
                   DeleteLocalObject(oPC,"oX3LastAssignClicked");
               } // double assign for horse
               else
               { // first click
                   SetLocalObject(oPC,"oX3LastAssignClicked",oTarget);
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111972),STRING_COLOR_WHITE),oPC,FALSE);
               } // first click
           } // Horse
           else if (GetIsPC(oTarget))
           { // PC
               oHorse=GetLocalObject(oPC,"oX3LastAssignClicked");
               if (GetIsObjectValid(oHorse))
               { // mount previously selected
                   if (oTarget==oPC)
                   { // give to self
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111973),STRING_COLOR_WHITE),oPC,FALSE);
                       if (GetAssociateType(GetMaster(oHorse))==ASSOCIATE_TYPE_HENCHMAN)
                       { // unassign from henchman
                           DeleteLocalObject(GetMaster(oHorse),"oAssignedHorse");
                       } // unassign from henchman
                       HorseRemoveOwner(oHorse);
                       HorseSetOwner(oHorse,oPC,TRUE);
                       SetAssociateState(NW_ASC_MODE_STAND_GROUND,FALSE,oHorse);
                   } // give to self
                   else if (GetMaster(oHorse)==oPC||GetMaster(GetMaster(oHorse))==oPC)
                   { // allowed to assign the mount
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111974)+GetName(oTarget)+".",STRING_COLOR_WHITE),oPC,FALSE);
                       FloatingTextStringOnCreature(StringToRGBString(GetName(oPC)+GetStringByStrRef(111975),STRING_COLOR_WHITE),oPC,FALSE);
                       if (GetAssociateType(GetMaster(oHorse))==ASSOCIATE_TYPE_HENCHMAN)
                       { // unassign from henchman
                           DeleteLocalObject(GetMaster(oHorse),"oAssignedHorse");
                       } // unassign from henchman
                       HorseRemoveOwner(oHorse);
                       HorseSetOwner(oHorse,oTarget);
                       SetAssociateState(NW_ASC_MODE_STAND_GROUND,FALSE,oHorse);
                   } // allowed to assign the mount
                   else
                   { // not allowed
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111976),STRING_COLOR_PINK),oPC,FALSE);
                   } // not allowed
                   DeleteLocalObject(oPC,"oX3LastAssignClicked");
               } // mount previously selected
               else
               { // no mount selected
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111977),STRING_COLOR_PINK),oPC,FALSE);
               } // no mount selected
           } // PC
           else if ((GetMaster(oTarget)==oPC||GetMaster(GetMaster(oTarget))==oPC)&&GetAssociateType(oTarget)==ASSOCIATE_TYPE_HENCHMAN)
           { // Henchman
               oHorse=GetLocalObject(oPC,"oX3LastAssignClicked");
               if (GetIsObjectValid(oHorse))
               { // a mount was previously clicked
                   if (HorseGetCanBeMounted(oHorse,oTarget))
                   { // horse is mountable
                       if (GetIsObjectValid(GetLocalObject(oTarget,"oAssignedHorse"))&&GetLocalObject(oTarget,"oAssignedHorse")!=oHorse)
                       { // remove old horse
                           oHench=GetLocalObject(oTarget,"oAssignedHorse");
                           HorseRemoveOwner(oHench);
                           HorseSetOwner(oHench,oPC);
                       } // remove old horse
                       HorseRemoveOwner(oHorse);
                       HorseSetOwner(oHorse,oTarget,TRUE);
                       FloatingTextStringOnCreature(GetStringByStrRef(111978)+GetName(oTarget)+".",oPC,FALSE);
                   } // horse is mountable
                   else
                   { // cannot be mounted
                       FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111979),STRING_COLOR_PINK),oPC,FALSE);
                   } // cannot be mounted
               } // a mount was previously clicked
               else
               { // no mount selected
                   FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111980),STRING_COLOR_PINK),oPC,FALSE);
               } // no mount selected
               DeleteLocalObject(oPC,"oX3LastAssignClicked");
           } // henchman
           else
           { // invalid target
               FloatingTextStringOnCreature(StringToRGBString(GetStringByStrRef(111981),STRING_COLOR_PINK),oPC,FALSE);
               DeleteLocalObject(oPC,"oX3LastAssignClicked");
           } // invalid target
           break;
       } // Assign Mount Menu Selection
       default: break;
   } // SPELL/FEAT ID - switch to control horse actions
}
////////////////////////////////////////////////////////////////////[ MAIN ]////

////////////////////////////////
// FUNCTIONS
////////////////////////////////


void FunctionSummonAndMount(int bAnimate=TRUE)
{ // PURPOSE: Summon the Paladin mount and mount it
    object oHorse;
    object oRider=OBJECT_SELF;
    int bPHBDuration=GetLocalInt(GetModule(),"X3_HORSE_PALADIN_USE_PHB");
    oHorse=HorseSummonPaladinMount(bPHBDuration);
    if (GetIsObjectValid(oHorse)) HorseMount(oHorse,bAnimate);
    else { AssignCommand(oRider,SpeakStringByStrRef(111959)); }
    DecrementRemainingFeatUses(oRider,FEAT_PALADIN_SUMMON_MOUNT);
} // FunctionSummonAndMount()


void FunctionHenchmanMount(object oHenchman)
{ // PURPOSE: Handle Mounting for this henchman
    object oHorse;
    oHorse=GetLocalObject(oHenchman,"oAssignedHorse");
    if (GetIsObjectValid(oHorse)&&GetDistanceBetween(oHorse,oHenchman)<30.0&&GetArea(oHorse)==GetArea(oHenchman)&&HorseGetCanBeMounted(oHorse,oHenchman))
    { // Valid target
        AssignCommand(oHenchman,HorseMount(oHorse,FALSE));
    } // valid target
    else
    { // not valid
      // check for paladin mount
        if (GetLevelByClass(CLASS_TYPE_PALADIN,oHenchman)>4)
        { // handle summoning and mounting paladin mount
            oHorse=HorseGetPaladinMount(oHenchman);
            if (GetIsObjectValid(oHorse)&&GetArea(oHorse)==GetArea(oHenchman)&&GetDistanceBetween(oHorse,oHenchman)<30.0&&HorseGetCanBeMounted(oHorse,oHenchman))
            { // mount existing paladin mount
                AssignCommand(oHenchman,HorseMount(oHorse,FALSE));
            } // mount existing paladin mount
            else if (GetHasFeat(FEAT_PALADIN_SUMMON_MOUNT,oHenchman))
            { // summon paladin mount
                AssignCommand(oHenchman,FunctionSummonAndMount(FALSE));
            } // summon paladin mount
         } // handle summoning and mounting paladin mount
    } // not valid
} // FunctionHenchmanMount()
