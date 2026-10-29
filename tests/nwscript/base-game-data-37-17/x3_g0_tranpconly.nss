////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick  - No monsters!!!
// X3_G0_TranPCOnly.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 12th, 2008
//:: Added Support for Keeping mounts out of no mount areas
//::////////////////////////////////////////////////////////


#include "x3_inc_horse"
#include "x0_inc_henai"


void main()
{
    int bOk=FALSE;
    object oClicker=GetClickingObject();
    if (GetIsPC(oClicker)||GetIsPC(GetMaster(oClicker))||GetIsPC(GetMaster(GetMaster(oClicker)))) bOk=TRUE;
    if (!bOk) return; // abort for non associates
    // This code runs as it has already determined this is an associate or the associate of an associate
    object oTarget = GetTransitionTarget(OBJECT_SELF);
    location lPreJump = HORSE_SupportGetMountLocation(oClicker,oClicker,0.0); // location before jump
    int bAnim=!GetLocalInt(OBJECT_SELF,"bDismountFast"); // negation is the only difference from NW_G0_TranPCOnly (= animated dismount for transitions if variable is not set)
    int nN=1;
    object oOb;
    object oAreaHere=GetArea(oClicker);
    object oAreaTarget=GetArea(oTarget);
    object oHitch;
    int bDelayedJump=FALSE;
    int bNoMounts=FALSE;
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oClicker,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oClicker,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oClicker,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oClicker,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    float fDelay=0.1*fX3_MOUNT_MULTIPLE;
    //SendMessageToPC(oClicker,"nw_g0_transition");
    if (!GetLocalInt(oAreaTarget,"X3_MOUNT_OK_EXCEPTION"))
    { // check for global restrictions
        if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oAreaTarget)) bNoMounts=TRUE;
        else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oAreaTarget)) bNoMounts=TRUE;
    } // check for global restrictions
    if (GetLocalInt(oAreaTarget,"X3_NO_MOUNTING")||GetLocalInt(oAreaTarget,"X3_NO_HORSES")||bNoMounts)
    { // make sure all transitioning are not mounted
       //SendMessageToPC(oClicker,"nw_g0_transition:No Mounting");
        if (HorseGetIsMounted(oClicker))
        { // dismount clicker
            bDelayedJump=TRUE;
            AssignCommand(oClicker,HORSE_SupportDismountWrapper(bAnim,TRUE));
            fDelay=fDelay+0.2*fX3_MOUNT_MULTIPLE;
        } // dismount clicker
        oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oClicker,nN);
        while(GetIsObjectValid(oOb))
        { // check each associate to see if mounted
            if (HorseGetIsMounted(oOb))
            { // dismount associate
                bDelayedJump=TRUE;
                DelayCommand(fDelay,AssignCommand(oOb,HORSE_SupportDismountWrapper(bAnim,TRUE)));
                fDelay=fDelay+0.2*fX3_MOUNT_MULTIPLE;
            } // dismount associate
            nN++;
            oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oClicker,nN);
        } // check each associate to see if mounted
        if (fDelay>0.1) SendMessageToPCByStrRef(oClicker,111989);
        if (bDelayedJump)
        { // some of the party has/have been mounted, so delay the time to hitch
            fDelay=fDelay+2.0*fX3_MOUNT_MULTIPLE; // non-animated dismount lasts 1.0+1.0=2.0 by default, so wait at least that!
            if (bAnim) fDelay=fDelay+2.8*fX3_MOUNT_MULTIPLE; // animated dismount lasts (X3_ACTION_DELAY+HORSE_DISMOUNT_DURATION+1.0)*fX3_MOUNT_MULTIPLE=4.8 by default, so wait at least that!
        } // some of the party has/have been mounted, so delay the time to hitch
    } // make sure all transitioning are not mounted
    if (GetLocalInt(oAreaTarget,"X3_NO_HORSES")||bNoMounts)
    { // make sure no horses/mounts follow the clicker to this area
        //SendMessageToPC(oClicker,"nw_g0_transition:No Horses");
        bDelayedJump=TRUE;
        oHitch=GetNearestObjectByTag("X3_HITCHING_POST",oClicker);
        DelayCommand(fDelay,HorseHitchHorses(oHitch,oClicker,lPreJump));
        if (bAnim) fDelay=fDelay+1.8*fX3_MOUNT_MULTIPLE;
      //fDelay=fDelay+0.5*fX3_MOUNT_MULTIPLE; // delays jump to transition, makes you stay longer before jump
    } // make sure no horses/mounts follow the clicker to this area

    //SendMessageToPC(oClicker,"nw_g0_transition:Jump  fDelay="+FloatToString(fDelay));
    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    //if (GetArea(oTarget)!=GetArea(oClicker)) DelayCommand(fDelay,AssignCommand(oClicker,ForceJump(oClicker,oTarget,5.0)));
    //else { DelayCommand(fDelay,AssignCommand(oClicker,ForceJump(oClicker,oTarget,5.0))); }
    if (bDelayedJump)
    { // delayed jump
        DelayCommand(fDelay,AssignCommand(oClicker,ClearAllActions()));
        //DelayCommand(fDelay+0.05*fX3_MOUNT_MULTIPLE,AssignCommand(oClicker,ActionWait(X3_ACTION_DELAY/2*fX3_MOUNT_MULTIPLE)));
        DelayCommand(fDelay+0.1*fX3_MOUNT_MULTIPLE,AssignCommand(oClicker,JumpToObject(oTarget)));
    } // delayed jump
    else
    { // quick jump
        AssignCommand(oClicker,JumpToObject(oTarget));
    } // quick jump
    DelayCommand(fDelay+4.0*fX3_MOUNT_MULTIPLE,HorseMoveAssociates(oClicker));
}
