///////////////////////////////////////////////////////
//:: Name - x2_inc_cutscene
//:: Copyright (c) 2001 Bioware Corp.
///////////////////////////////////////////////////////
/*
   This is the cutscene include file that contains many
   useful functions when doing cutscenes. The uses are
   described before each function.

   Each function will be in a wrapper function that will
   check to see if the cutscene has been aborted yet or
   not.

   There is an added variable called iShift. This can be
   ignored in all cases, except when the GetShift function
   is being called. It was added so that when a shift is
   done, you can insert stuff (the reason for the shift)
   into your script without the new stuff being shifted.

   An example of this: You decide you need to add 20
   seconds of material in the middle of your cutscene.
   You need to do this at the 1 minute mark, and you
   want to shift everything after that point by 20 secs.
   The new stuff you add there for that 20 secs will
   get shifted as well since you called the shift. But
   by adding FALSE at the end of the function call, it
   will ignore the shift amount.

   Also, if anything after the shift is something that
   you don't want adjusted from the default, use this
   there as well.
*/
///////////////////////////////////////////////////////
//:: Created By: Brad Prince
//:: Created On: Dec 9, 2002
///////////////////////////////////////////////////////

// Used to shift the entire cutscene a length of time. Used internally here,
// but very handy for cutscenes that are complete, but need to be changed
// after the fact. From the point it is called, it just shifts the cutscene
// accordingly. Can be used (and should be) for non-cutscene delays in a
// script (ie - commands that aren't here or regular DelayCommands in a script.)

//UPDATE Jan 8/03 :Keith Warner: The integer nCutscene is now passed in to all cutscene functions.
//This is so that if a player skips one cutscene and then very soon after enters another
//cutscene, we need to be able to check which cutscene a delayed function belongs to.
//If it is not the cutscene that the PC is currently in - the delayed actions that effect the
//PC should NOT take place

// UPDATE MAY 27, 2003: Yaron Jakobs:
// - Using the CutSetActiveCutscene() function at the begining
// of each cutscene, instead of giving a number for each line. For example:
// call CutSetActiveCutscene(1) and then any Cut* functions that follow would assume cutscene
// number 1 is valid and would compare that number to the value that is set on the player as the
// active cutscene (if you use ExecuteScript or SignalEvent in the middle of a cutscene, you should
// run the CutSetActiveCutscene() function again right at the returning line).
// - Any object that uses any of the delayed Cut* functions must have it's cutscene value be set by
// the CutSetActiveCutsceneForObject() function. This prevents any delayed actions to be taken after
// a cutscene has been aborted. You would need to handle any specific actions that should still
// happen in the abort script.
// - Added a fade length variable to the CutFadeOutAndIn() function.
// - Changed FreezeAssociate and UnfreezeAssociate to be a part of the SetCutsceneMode function.
// - Added more CutAction* functions
// - Added CutStoreMusic(), CutRestoreMusic() and CutSetMusic() functions
// - the CutRestoreLocation (and any other CutRestore* function) does not require a cutscene
// number parameter anymore, as this function can run even after a cutscene has been aborted so
// there is no need to make a check with this num.
// - Added CutSetTile*** function to change tile colors
// - Added CutSetAbortDelay(). Use this function at the begining of a cutscene to set the
// delay you want for the execution of all cutscene related functions for players only.
// The corresponding function CutGetAbortDelay() fetches the value in the abort script
// and applies it for all the needed functions (defaults the 0). This delay is counted right
// after pressing the abort button.
// - Added CutSetDestroyCopyDelay(). Functions much the same as CutSetAbortDelay(), although
// this one is responsible to delay the removal of the pc copy (if there is one) (defaults to 0).
// - Added CutCreatePCCopy() and CutDestroyPCCopy().
// - Objects created by CutCreateObject would have their cutscene number set to the current
// cutscene number, unless the default parameter of SetActive is FALSE (default value of TRUE).
// - Added CutDisableCutscene() function. This function should be called at the end of a cutscene
// and it is also called in the generic abort script for the module.
// - Added CutDisableAbort() function to be used in a begining of a function that should not
// be abortable.
// - Added support for cumulative delay (give only the delay between each line).
// - Added CutGetConvDuration() to get dialog duration from a 2da (multi-lang support)
// - CutSpeakStringByStrRef() now also calls PlaySoundByStrRef internally.
// - Add CutBeginConversation to handle dialog without the initiating object running to the other object

// UPDATE JUNE 25 - Yaron Jakobs:
// - Added an option to specify fade speed to all fade functions.
// - Destroying a PC copy would jump the player to his original location.


// Use this function at the begining of a cutscene for each object involved in the cutscene.
// Notice that this function would fail if oObject already has another cutscene value (any
// number greater than 0). The function returns 0 on success, -1 otherwise.
int CutSetActiveCutsceneForObject(object oObject, int nCutNum, int bMainPC = FALSE);

float GetShift(object oObject, int iShift);


int CUT_DELAY_TYPE_CUMULATIVE = 0;
int CUT_DELAY_TYPE_CONSTANT = 1;
// Set the current active cutscene. Any following delayed Cut* functions would run only if the
// initiating object has the same cutscene number as the global active one. A value of -1
// means that no cutscene is active (possible values for bDelayType: CUT_DELAY_TYPE_CUMULATIVE, CUT_DELAY_TYPE_CONSTANT.
// bSetCutsceneObject should be set to FALSE whenever calling this function more than once for the
// same cutscene but in another file. This would keep the original cutscene object that created
// all the cutscene effect so it would be possible to remove them when the cutscene ends.
void CutSetActiveCutscene(int nCutsceneNumber, int nDelayType, int bSetCutsceneObject = TRUE);

// Returns current global cutscene number.
int GetActiveCutsceneNum();

// Used to clear commandable state FALSE in the event there are too many
// Used in this include only.
void RemoveCommandable(object oPC);

// Plays voice chat nChatID for oObject.
void CutPlayVoiceChat(float fDelay, object oObject , int nChatID, int iShift = TRUE);

// Used to remove all effects from an object.
// Example: CutRemoveEffects(10.5, GetObjectByTag("guard1")) would remove all effects from guard1 after a 10.5 second delay.
// Notice that only effects created for the cutscene would be removed.
void CutRemoveEffects(float fDelay, object oObject, int iShift = TRUE);

// Jumps all associates of oPC to lLoc
void CutJumpAssociateToLocation(float fDelay, object oPC, location lLoc, int iShift = TRUE);

// Used for a conversation file when you need to have an NPC speak
// via a conversation instead of bubble text. The fDelay is used
// when timing is important.
//
///Example: CutActionStartConversation(5.0, oNPC, oPC, "my_conv"); would start the
//   conversation file "my_conv" of the NPC, after a 5 sec delay, and
//   the conversation subject would be the PC.
void CutActionStartConversation(float fDelay, object oNPC, object oPC, string szConversationFile, int iShift = TRUE);

// Use this instead of CutActionStartConversation() to start a dialog
// without one object running to the other.
void CutBeginConversation(float fDelay, object oTalker, object oTalkTo, string sConvFile, int iShift = TRUE);

// oAttacker would attack oAttackee.
void CutActionAttack(float fDelay, object oAttacker, object oAttackee, int bPassive = FALSE, int iShift = TRUE);

void CutActionCloseDoor(float fDelay, object oCloser, object oDoor, int iShift = TRUE);

void CutActionEquipItem(float fDelay, object oObject, object oItem, int InvSlot, int iShift = TRUE);

void CutActionUnequipItem(float fDelay, object oObject, object oItem, int iShift = TRUE);

void CutActionForceFollowObject(float fDelay, object oObject, object oFollow, float fFollowDistance = 0.0, int iShift = TRUE);

void CutActionLockObject(float fDelay, object oObject, object oTarget, int iShift = TRUE);

void CutActionUnLockObject(float fDelay, object oObject, object oTarget, int iShift = TRUE);

void CutActionMoveAwayFromLocation(float fDelay, object oObject, location lLoc, int bRun = FALSE, float fRange = 40.0, int iShift = TRUE);

void CutActionMoveAwayFromObject(float fDelay, object oObject, object oTarget, int bRun = FALSE, float fRange = 40.0, int iShift = TRUE);

void CutActionOpenDoor(float fDelay, object oObject, object oDoor, int iShift = TRUE);

void CutActionSit(float fDelay, object oObject, object oChair, int iShift = TRUE);

void CutSpeakString(float fDelay, object oSpeaker, string szString, int iShift = TRUE);

void CutSpeakStringByStrRef(float fDelay, object oSpeaker, int nStrRef, int iShift = TRUE);

void CutPlayAnimation(float fDelay, object oObject, int nAnimation, float fLength, int iShift = TRUE);

void CutJumpToLocation(float fDelay, object oPC, location lLoc, int iShift = TRUE);

void CutJumpToObject(float fDelay, object oPC, object oObject, int iShift = TRUE);

void CutActionMoveToObject(float fDelay, object oPC, object oTarget, int iRun, int iShift = TRUE);

void CutActionMoveToLocation(float fDelay, object oPC, location lLoc, int iRun, int iShift = TRUE);

void CutActionForceMoveToObject(float fDelay, object oPC, object oTarget, int iRun = FALSE, float fRange = 1.0, float fTimeout = 30.0, int iShift = TRUE);

void CutActionForceMoveToLocation(float fDelay, object oPC, location lLoc, int iRun = FALSE, float fTimeout = 30.0, int iShift = TRUE);

// Would create an object after the delay. Please avoid using this function as it is currently impossible
// to cancel action of objects created by it after aborting the cutscene.
void CutCreateObject(float fDelay, object oPC, int iType, string sName, location lLoc, int iEffect, int nSetActive = TRUE, int iShift = TRUE);

void CutSetFacingPoint(float fDelay, object oPC, string szTag, int iShift = TRUE);

// Combines fade-out and fade-in into one function.
void CutFadeOutAndIn(float fDelay, object oObject, float fFadeLen = 4.3, float nFadeSpeed = FADE_SPEED_FASTEST, int iShift = TRUE);

void CutFadeToBlack(float fDelay, object oObject, float nFadeSpeed = FADE_SPEED_FASTEST, int iShift = TRUE);

void CutFadeFromBlack(float fDelay, object oObject, float nFadeSpeed = FADE_SPEED_FASTEST, int iShift = TRUE);

void CutSetCamera(float fDelay, object oObject, int iCameraType, float fFacing, float fZoom, float fPitch, int nSpeed, int iShift = TRUE);

void CutClearAllActions(float fDelay, object oObject, int nClearCombatState, int iShift = TRUE);

void CutApplyEffectAtLocation(float fDelay, object oObject, int iDur, int iEffect, location lLoc, float fDur = 0.0, int iShift = TRUE);

// Applies visual effect iEffect to oObject.
// If you want to apply non-visual effect use CutApplyEffectToObject2
void CutApplyEffectToObject(float fDelay, int iDur, int iEffect, object oObject, float fDur = 0.0, int iShift = TRUE);

// Applies eEffect to Object.
void CutApplyEffectToObject2(float fDelay, int iDur, effect eEffect, object oObject, float fDur = 0.0, int iShift = TRUE);

void CutKnockdown(float fDelay, object oObject, float fDur, int iShift = TRUE);

void CutDeath(float fDelay, object oObject, int iSpec, int iShift = TRUE);

void CutActionCastFakeSpellAtObject(float fDelay, int iSpell, object oObject, object oTarget, int iPath = PROJECTILE_PATH_TYPE_DEFAULT, int iShift = TRUE);

void CutActionCastFakeSpellAtLocation(float fDelay, int iSpell, object oObject, location lLoc, int iPath = PROJECTILE_PATH_TYPE_DEFAULT, int iShift = TRUE);

void CutActionCastSpellAtObject(float fDelay, int iSpell, object oObject, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int iPath=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int iShift = TRUE);

void CutActionCastSpellAtLocation(float fDelay, int iSpell, object oObject, location lLoc, int METAMAGIC = METAMAGIC_ANY, int nCheat = FALSE, int nDomainLevel = 0, int iPath = PROJECTILE_PATH_TYPE_DEFAULT, int iShift = TRUE);

// Stores the current location of oPC to be restored later with CutRestoreLocation.
void CutSetLocation(float fDelay, object oPC, int iShift = TRUE);

// Restores the location that had been stored by CutSetLocation.
void CutRestoreLocation(float fDelay, object oPC, int iShift = TRUE);

const int VANISH = 2;
const int CUT_CAMERA_HEIGHT_VERY_LOW = 2;
const int CUT_CAMERA_HEIGHT_LOW = 3;
const int CUT_CAMERA_HEIGHT_MEDIUM = 4;
const int CUT_CAMERA_HEIGHT_HIGH = 5;
const int CUT_CAMERA_HEIGHT_VERY_HIGH = 6;

// Used to turn cutscene mode on or off.
// iValue: TRUE to start cutscene, and FALSE to exit cutscene mode.
// bInv: TRUE -  to make the player invisible.
//       FASLE - would leave the player visible.
//       CUT_CAMERA_HEIGHT_VERY_LOW - would turn the playe invisible and put the camera at a very low position.
//       CUT_CAMERA_HEIGHT_LOW - would turn the playe invisible and put the camera at a low position.
//       CUT_CAMERA_HEIGHT_MEDIUM - would turn the playe invisible and put the camera at a low position.
//       CUT_CAMERA_HEIGHT_HIGH would turn the playe invisible and put the camera at a high position.
//       CUT_CAMERA_HEIGHT_VERY_HIGH would turn the playe invisible and put the camera at a very high position.
// bKeepAssociates: would destroy all associate when set to FALSE.
// bFreezeAssociates would freeze all associates when set to TRUE, and turn them invisible when set to VANISH = 2.
void CutSetCutsceneMode(float fDelay, object oPC, int iValue, int bInv, int bKeepAssociates = TRUE, int bFreezeAssociates = TRUE, int iShift = TRUE);

void CutSetPlotFlag(float fDelay, object oObject, int iValue, int iShift = TRUE);

void CutDestroyObject(float fDelay, object oObject, int iShift = TRUE);

// Stores camera facing for oPC to be restored by CutRestoreCameraFacing.
void CutStoreCameraFacing(float fDelay, object oPC, int iShift = TRUE);

// Restored camera facing that has been stored by CutStoreCameraFacing.
void CutRestoreCameraFacing(float fDelay, object oPC, int iShift = TRUE);

void CutBlackScreen(float fDelay, object oPC, int iShift = TRUE);

void CutStopFade(float fDelay, object oPC, int iShift = TRUE);

void CutPlaySound(float fDelay, object oPC, string szSound, int iShift = TRUE);

// Sets the track nTrack as the music for the current area of oPC and plays it.
void CutSetMusic(float fDelay, object oPC, int nTrack, int iShift = TRUE);

// Stores the current music track for the area where oPC is. Use CutRestoreMusic to reset the music for the area
void CutStoreMusic(float fDelay, object oPC, int iShift = TRUE);

// Restores the music track for the area where oPC is which was stores by CutStoreMusic.
void CutRestoreMusic(float fDelay, object oPC, int iShift = TRUE);

// Sets the track nTrack as the music for the current area of oPC and plays it.
void CutSetAmbient(float fDelay, object oPC, int nTrack, int iShift = TRUE);

// Sets the main tile color for the tile at lLoc.
void CutSetTileMainColor(float fDelay, object oPC, location lLoc, int nMainColor1, int nMainColor2, int iShift = TRUE);

// Sets the source tile color for the tile at lLoc.
void CutSetTileSourceColor(float fDelay, object oPC, location lLoc, int nSourceColor1, int nSourceColor2, int iShift = TRUE);

void CutSetWeather(float fDelay, object oPC, int nWeather, int iShift = TRUE);

// Sets the delay between pressing the ESC key to actually doing the cutscene cleanup.
// This function should be used at the beginning of a cutscene only if such delay is required.
// Otherwise, there would be no cleanup delay.
void CutSetAbortDelay(int nCutscene, float fDelay);

// Retrieves the current abort delay for nCutscene after aborting.
float CutGetAbortDelay(int nCutscene);

// Sets the delay between pressing the ESC key to actually destroying the PC copy.
// This function should be used at the beginning of a cutscene only if such delay is required.
// Otherwise, there would be no delay.
void CutSetDestroyCopyDelay(int nCutscene, float fDelay);

// Retrieves the current destroy PC delay after aborting a cutscene.
float CutGetDestroyCopyDelay(int nCutscene);

// Creates a copy of oPC at lLoc with tag sTag. Older copies of oPC would be destroyed if any.
object CutCreatePCCopy(object oPC, location lLoc, string sTag);

// Creates a copy of oPC at lLoc with tag sTag. Older copies of oPC would be destroyed if any.
object CutCreateObjectCopy(float fDelay, object oObject, location lLoc, string sTag = "", int iShift = TRUE);

// Destroys the copy of oPC and restores the PC's original location if bRestorePCLocation is TRUE.
void CutDestroyPCCopy(float fDelay, object oPC, int bRestorePCLocation = TRUE, int iShift = TRUE);

const int RESTORE_TYPE_NONE = 0;
const int RESTORE_TYPE_NORMAL = 1;
const int RESTORE_TYPE_COPY = 2;
// Disables a cutscene. All generic disable functions would be called after a delay of fCleanupDelay,
//  and any PC copy object would be destroyed after a delay of fDestPCCopyDelay).
// If using the CUT_DELAY_TYPE_CUMULATIVE delay type, then each delay should be in relation to
// the previous delay (independent delays). nRestoreType should have one of the following values:
// - RESTORE_TYPE_NONE: Do not jump the player.
// - RESTORE_TYPE_NORMAL: Jump the player to the last place that he used CutSetLocation() at.
// - RESTORE_TYPE_COPY: Jupm the player to the place where the copy was created.
void CutDisableCutscene(int nCutscene, float fCleanupDelay, float fDestPCCopyDelay, int nRestoreType = RESTORE_TYPE_NORMAL);

// Disables the possibility to disable nCutscene. Pressing ESC would do nothing after calling this function.
void CutDisableAbort(int nCutscene);

// returns TRUE if it is not possible to abort nCutscene, FALSE otherwise.
int CutGetIsAbortDisabled(int nCutscene);

// Get the duration of dialog sConvName from a 2da. A value of 0.0 is returned on error.
// The value in the 2da should be set when first knowing the english length of the dialog.
float CutGetConvDuration(string sConvName);

// This adjusts Faction Reputation, how the entire faction that
// oSourceFactionMember is in, feels about oTarget.
void CutAdjustReputation(float fDelay, object oTarget, object oSource, int nAdjustment, int iShift = TRUE);

// Sets the current movement rate factor of
// the cutscene camera-man (oPC)
// fMovementRateFactor: Factor ranging between 0.1 and 2.0
void CutSetCameraSpeed(float fDelay, object oPC, float fMovementRateFactor, int iShift = TRUE);

void UnFreezeAssociate(object oPlayers);

float CutGetConvDuration(string sConvName)
{
    // first, get the row of sConvName
    int nRow = 0;
    string sName = Get2DAString("des_cutconvdur", "Dialog", nRow);
    while(sName != "")
    {
        if(sName == sConvName) // found the dialog we need, current nRow has the right value
            return StringToFloat(Get2DAString("des_cutconvdur", "Duration", nRow));
        nRow++;
        sName = Get2DAString("des_cutconvdur", "Dialog", nRow);
    }
    return 0.0; // error value
}

void CutSetActiveCutscene(int nCutsceneNumber, int nDelayType, int bSetCutsceneObject = TRUE)
{
    // Storing the delay type.
    SetLocalInt(GetModule(), "X2_DelayType" + IntToString(nCutsceneNumber), nDelayType);
    // Setting the active object, which is the object that applies all the effects for this cutscene.
    // This object is used in the cutscene abort script and at the end of the cutscene to remove all
    // the effects that this object had created.
    if(bSetCutsceneObject == TRUE)
        SetLocalObject(GetModule(), "X2_Cut" + IntToString(nCutsceneNumber) + "ActiveObject", OBJECT_SELF);
    SetLocalInt(GetModule(), "X2_ActiveCutsceneNumber", nCutsceneNumber);
}

int GetActiveCutsceneNum()
{
    return GetLocalInt(GetModule(), "X2_ActiveCutsceneNumber");
}

// Calculates the "real" delay to execute a cut* action (can be a comulative delay or a constant one)
float CutCalculateCurrentDelay(float fDelayModifier, int nCutsceneNumber)
{
    if(GetLocalInt(GetModule(), "X2_DelayType" + IntToString(nCutsceneNumber)) == CUT_DELAY_TYPE_CONSTANT)
        return fDelayModifier; // support for old system - leaving the delay the same
    // new system - each delay is the difference from the previous one.
    string sDelayVariable = "X2_fCutscene" + IntToString(nCutsceneNumber) + "Delay";
    float fCurrentDelay = GetLocalFloat(GetModule(), sDelayVariable);
    fCurrentDelay = fCurrentDelay + fDelayModifier;
    SetLocalFloat(GetModule(), sDelayVariable, fCurrentDelay);
    return fCurrentDelay;
}

float GetShift(object oObject, int iShift)
{
        float fShift;
        if(iShift != FALSE)
             fShift = GetLocalFloat(GetArea(oObject), "cut_shift");
        else
             fShift = 0.0;
        return fShift;
}

// flagging a cutscene as non-abortable. This function should be used at the begining of
// a cutscene (probably for short cutscenes).
void CutDisableAbort(int nCutscene)
{
    SetLocalInt(GetModule(), "X2_CutAbortDisabled" + IntToString(nCutscene), 1);
}

int CutGetIsAbortDisabled(int nCutscene)
{
    return GetLocalInt(GetModule(), "X2_CutAbortDisabled" + IntToString(nCutscene));
}

int CutSetActiveCutsceneForObject(object oObject, int nCutNum, int bMainPC = FALSE)
{
    /*
    // familiar check (unpossess and bring the pc here)
    if(GetIsPossessedFamiliar(oObject))
    {
        PrintString("BOOM: object is familiar");
        object oPC = GetMaster(oObject);
        AssignCommand(oPC, JumpToObject(oObject));
        UnpossessFamiliar(oObject);
        oObject = oPC;
    }*/

    // if trying to set a new cutscene number for a player and the old value is not zero
    // than the oObject is already in another cutscene and returning with failure.
    if(GetIsPC(oObject) && nCutNum != 0 && GetLocalInt(oObject, "nCutsceneNumber") != 0)
        return -1;

    SetLocalInt(oObject, "nCutsceneNumber", nCutNum);
    if(bMainPC == TRUE)
        SetLocalInt(oObject, "nCutMainPC", 1);
    else
        SetLocalInt(oObject, "nCutMainPC", 0);


    if(nCutNum == 0 || GetIsPC(oObject))
        return 0; // Not storing an object if disabling active cutscene (value of 0) or this is a pc

    // Storing the object, so that the generic abort could find it and reset it.
    // First, getting the global index for this cutscene (virtual array).
    int nCurrentIndex = GetLocalInt(GetModule(), "X2_CutsceneObjectsIndex" + IntToString(nCutNum));
    // Next, storing the object.
    SetLocalObject(GetModule(),
        "X2_Cutscene" + IntToString(nCutNum) + "Object" + IntToString(nCurrentIndex), oObject);
    // Finally, updating the index.
    nCurrentIndex++;
    SetLocalInt(GetModule(), "X2_CutsceneObjectsIndex" + IntToString(nCutNum), nCurrentIndex);
    return 0;
}

int CutGetActiveCutsceneForObject(object oObject)
{
    return GetLocalInt(oObject, "nCutsceneNumber");
}

// This function is used internally by the generic abort script.
// It finds all active objects for this cutscene and resets them so they won't execute any
// more actions.
void CutResetActiveObjectsForCutscene(int nCutscene)
{
    // Getting the size of the virtual array that stores the cutscene objects.
    // This would return an index for the "next object to be stored", so there would be no
    // object in that index
    int nMaxIndex = GetLocalInt(GetModule(), "X2_CutsceneObjectsIndex" + IntToString(nCutscene));
    int i;
    object oCurrentObject;
    // Iterating through all the cutscene objects
    for(i = 0; i < nMaxIndex; i++)
    {
        oCurrentObject = GetLocalObject(GetModule(),
            "X2_Cutscene" + IntToString(nCutscene) + "Object" + IntToString(i));
        CutSetActiveCutsceneForObject(oCurrentObject, 0);
    }
    // Initializing the index
    SetLocalInt(GetModule(), "X2_CutsceneObjectsIndex" + IntToString(nCutscene), 0);
}

void CallRestorePCCopyLocation(int nCutscene, object oPC)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        location lLoc = GetLocalLocation(oPC, "X2_PCLocation");
        DeleteLocalLocation(oPC, "X2_PCLocation");
        AssignCommand(oPC, JumpToLocation(lLoc));
    }
}

void CallRemoveEffects(int nCutscene, object oObject)
{
    if(CutGetActiveCutsceneForObject(oObject) == nCutscene)
    {   // first, get the object that created all the effects
        object oCreator = GetLocalObject(GetModule(), "X2_Cut" + IntToString(nCutscene) + "ActiveObject");

        effect eEff = GetFirstEffect(oObject);
        while(GetIsEffectValid(eEff))
        {
            if( GetEffectCreator(eEff) == oCreator)
                RemoveEffect(oObject, eEff);
            eEff = GetNextEffect(oObject);
        }
    }
}

void CutRemoveEffects(float fDelay, object oObject, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallRemoveEffects(nCutscene, oObject)));
}

void CallRemoveAssociatesEffects(int nCutscene, object oPC)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
        object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
        object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
        object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
        CutSetActiveCutsceneForObject(oAnimal, nCutscene);
        CutSetActiveCutsceneForObject(oDominated, nCutscene);
        CutSetActiveCutsceneForObject(oFamiliar, nCutscene);
        CutSetActiveCutsceneForObject(oSummoned, nCutscene);
        if(oAnimal != OBJECT_INVALID)
            CallRemoveEffects(nCutscene, oAnimal);
        if(oDominated != OBJECT_INVALID)
            CallRemoveEffects(nCutscene, oDominated);
        if(oFamiliar != OBJECT_INVALID)
            CallRemoveEffects(nCutscene, oFamiliar);
        if(oSummoned != OBJECT_INVALID)
            CallRemoveEffects(nCutscene, oSummoned);

        int i = 1;
        object oHenchman = GetHenchman(oPC, i);
        while(oHenchman != OBJECT_INVALID)
        {
            CutSetActiveCutsceneForObject(oHenchman, nCutscene);
            CallRemoveEffects(nCutscene, oHenchman);
            i++;
            oHenchman = GetHenchman(oPC, i);
        }
    }
}

void CallJumpAssociateToLocation(int nCutscene, object oPC, location lLoc)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        UnFreezeAssociate(oPC);
        object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
        object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
        object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
        object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
        if(oAnimal != OBJECT_INVALID)
            AssignCommand(oAnimal, ActionJumpToLocation(lLoc));
        if(oDominated != OBJECT_INVALID)
            AssignCommand(oDominated, ActionJumpToLocation(lLoc));
        if(oFamiliar != OBJECT_INVALID)
            AssignCommand(oFamiliar, ActionJumpToLocation(lLoc));
        if(oSummoned != OBJECT_INVALID)
            AssignCommand(oSummoned, ActionJumpToLocation(lLoc));

        int i = 1;
        object oHenchman = GetHenchman(oPC, i);
        while(oHenchman != OBJECT_INVALID)
        {
            AssignCommand(oHenchman, ActionJumpToLocation(lLoc));
            i++;
            oHenchman = GetHenchman(oPC, i);
        }
    }
}

void CutJumpAssociateToLocation(float fDelay, object oPC, location lLoc, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallJumpAssociateToLocation(nCutscene, oPC, lLoc)));
}


void CallDestroyPCCopy(int nCutscene, object oPC, int bRestorePCLocation)
{
    object oCopy = GetLocalObject(oPC, "X2_PCCopy" + IntToString(nCutscene));
    if(oCopy == OBJECT_INVALID)
        return;
    if(bRestorePCLocation == TRUE)
    {
        CallRestorePCCopyLocation(nCutscene, oPC);
    }

    SetPlotFlag(oCopy, FALSE);
    DestroyObject(oCopy);
}

// Destroys the copy of oPC. This function would work even if there is no valid cutscene for oPC.
// If bRestorePCLocation is TRUE then the PC would be jumped to original location.
void CutDestroyPCCopy(float fDelay, object oPC, int bRestorePCLocation = TRUE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallDestroyPCCopy(nCutscene, oPC, bRestorePCLocation)));
}

// Creates a copy of the pc at lLoc (and destroys an old one, if exists.
object CutCreatePCCopy(object oPC, location lLoc, string sTag)
{
    int nCutscene = GetActiveCutsceneNum();
    // first, destroy an old copy, if exists
    CallDestroyPCCopy(nCutscene, oPC, FALSE);
    // next, create the new copy.
    object oNewPC = CopyObject(oPC, lLoc, OBJECT_INVALID, sTag);
    //SetPlotFlag(oNewPC, TRUE);
    CutSetActiveCutsceneForObject(oNewPC, nCutscene);
    SetLocalObject(oPC, "X2_PCCopy" + IntToString(nCutscene), oNewPC);
    SetLocalLocation(oPC, "X2_PCLocation", GetLocation(oPC)); // Keeping location of PC so it can be restored when the copy is destroyed
    ChangeToStandardFaction(oNewPC, STANDARD_FACTION_COMMONER);
    SetActionMode(oNewPC, ACTION_MODE_STEALTH, FALSE);
    SetActionMode(oNewPC, ACTION_MODE_DETECT, FALSE);
    return oNewPC;
}


void CallCreateObjectCopy(int nCutscene, object oObject, location lLoc, string sTag)
{
    if(CutGetActiveCutsceneForObject(oObject) == nCutscene)
    {
        CopyObject(oObject, lLoc, OBJECT_INVALID, sTag);
    }
}

void CutCreateObjectCopy(float fDelay, object oObject, location lLoc, string sTag = "", int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallCreateObjectCopy(nCutscene, oObject, lLoc, sTag)));
}

// returns TRUE whether the pc is the main pc for his current cutscene, FALSE otherwise.
int CutGetIsMainPC(object oPC)
{
    if(GetLocalInt(oPC, "nCutsceneNumber") == 0)
        return FALSE; // a player is not a part of any cutscene
    return GetLocalInt(oPC, "nCutMainPC");
}

// set delay for removal of pc copy in the generic abort script (should be used
// at the begining of a cutscene)
void CutSetDestroyCopyDelay(int nCutscene, float fDelay)
{
    SetLocalFloat(GetModule(), "X2_CutDestroyCopyDelay" + IntToString(nCutscene), fDelay);
}

float CutGetDestroyCopyDelay(int nCutscene)
{
    return GetLocalFloat(GetModule(), "X2_CutDestroyCopyDelay" + IntToString(nCutscene));
}

void CutSetAbortDelay(int nCutscene, float fDelay)
{
    SetLocalFloat(GetModule(), "X2_CutAbortDelay" + IntToString(nCutscene), fDelay);
}

// get the delay for cutscene-disable funcions in the generic abort script (used only there)
float CutGetAbortDelay(int nCutscene)
{
    return GetLocalFloat(GetModule(), "X2_CutAbortDelay" + IntToString(nCutscene));
}

void RemoveAssociateEffects(object oCreature)
{
    int nCutscene = GetActiveCutsceneNum();
    effect eEff1 = GetFirstEffect(oCreature);
    object oCreator = GetLocalObject(GetModule(), "X2_Cut" + IntToString(nCutscene) + "ActiveObject");

    while(GetIsEffectValid(eEff1))
    {
        if (GetEffectCreator(eEff1) == oCreator)
        {
            RemoveEffect(oCreature, eEff1);
        }
        eEff1 = GetNextEffect(oCreature);
    }
}

object FreezeAssociate(object oPlayers, int bVanish)
{
    effect eAssociate = EffectCutsceneParalyze();
    effect eInv = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    //Cutscene Paralize any associates.
    int i = 1;
    object oHench = GetHenchman(oPlayers, i);
    while(oHench != OBJECT_INVALID)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAssociate, oHench);
        if(bVanish)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oHench);
        i++;
        oHench = GetHenchman(oPlayers, i);
    }

    object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPlayers);
    if (oCompanion != OBJECT_INVALID)
    {
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAssociate, oCompanion);
       if(bVanish)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oCompanion);
    }

    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPlayers);
    if (oFamiliar != OBJECT_INVALID)
    {
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAssociate, oFamiliar);
       if(bVanish)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oFamiliar);
    }

    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPlayers);
    if (oSummon != OBJECT_INVALID)
    {
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAssociate, oSummon);
       if(bVanish)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oSummon);
    }

    object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPlayers);
    if (oDominated != OBJECT_INVALID)
    {
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAssociate, oDominated);
       if(bVanish)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oDominated);

    }
    return oDominated;
}
void UnFreezeAssociate(object oPlayers)
{
    //Cutscene Paralize any associates.
    int i = 1;
    object oHench = GetHenchman(oPlayers, i);
    while(oHench != OBJECT_INVALID)
    {
        RemoveAssociateEffects(oHench);
        i++;
        oHench = GetHenchman(oPlayers, i);
    }

    object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPlayers);
    if (oCompanion != OBJECT_INVALID)
       RemoveAssociateEffects(oCompanion);
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPlayers);
    if (oFamiliar != OBJECT_INVALID)
       RemoveAssociateEffects(oFamiliar);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPlayers);
    if (oSummon != OBJECT_INVALID)
       RemoveAssociateEffects(oSummon);
    object oDominated = GetLocalObject(oPlayers, "oDominated");
    if (oDominated != OBJECT_INVALID)
       RemoveAssociateEffects(oDominated);
}

void RemoveCommandable(object oPC)
{
        while(GetCommandable(oPC) == FALSE)
             SetCommandable(TRUE, oPC);
}

// Helper function
void Talk(string sConvFile, object oTalkTo)
{
    BeginConversation(sConvFile, oTalkTo);
}

void CallBeginConversation(int nCutscene, object oTalker, object oTalkTo, string sConvFile)
{
        if(nCutscene == GetLocalInt(oTalker, "nCutsceneNumber"))
        {
            AssignCommand(oTalker, Talk(sConvFile, oTalkTo));
        }
}

void CutBeginConversation(float fDelay, object oTalker, object oTalkTo, string sConvFile, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oTalker, iShift), CallBeginConversation(nCutscene, oTalker, oTalkTo, sConvFile)));
}

void CallActionStartConversation(int nCutscene, object oNPC, object oPC, string szConversationFile)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {
            //CutRemoveEffects(0.0, oPC);
            //SetCommandable(TRUE, oPC);
            AssignCommand(oNPC, ActionStartConversation(oPC, szConversationFile));
            //SetCommandable(FALSE, oPC);
            //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneDominated(), oPC);
        }

}

void CutActionStartConversation(float fDelay, object oNPC, object oPC, string szConversationFile, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallActionStartConversation(nCutscene, oNPC, oPC, szConversationFile)));
}

// Used for bubble text type speaking.
/* Example: CutSpeakString(0.0, GetObjectByTag("drow_priest"), "I like
   green eggs and ham."); would have the object drow_priest speak the
   line "I like green eggs and ham." after no delay.
*/
void CallSpeakString(int nCutscene, object oSpeaker, string szString)
{
    if(nCutscene == GetLocalInt(oSpeaker, "nCutsceneNumber"))
    {
        AssignCommand(oSpeaker, SpeakString(szString));
    }
}

void CallSpeakStringByStrRef(int nCutscene, object oSpeaker, int nStrRef)
{
    if(nCutscene == GetLocalInt(oSpeaker, "nCutsceneNumber"))
    {
        AssignCommand(oSpeaker, SpeakStringByStrRef(nStrRef));
        AssignCommand(oSpeaker, PlaySoundByStrRef(nStrRef, FALSE));
    }
}

void CutSpeakString(float fDelay, object oSpeaker, string szString, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oSpeaker, iShift), CallSpeakString(nCutscene, oSpeaker, szString)));
}

void CutSpeakStringByStrRef(float fDelay, object oSpeaker, int nStrRef, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oSpeaker, iShift), CallSpeakStringByStrRef(nCutscene, oSpeaker, nStrRef)));
}


// Used if you need a cutscene participant to do an animation.
/* Example: CutPlayAnimation(26.0, oPC, ANIMATION_FIREFORGET_BOW, 3.0);
   would have the PC bow for 3 seconds after a 26 second delay.
*/
void CallPlayAnimation(int nCutscene, object oObject, int nAnimation, float fLength)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, PlayAnimation(nAnimation, 1.0, fLength));
    }
}

void CutPlayAnimation(float fDelay, object oObject, int nAnimation, float fLength, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallPlayAnimation(nCutscene, oObject, nAnimation, fLength)));
}

// Used to jump the PC to a location.
/* Example: CutJumpToLocation(20.0, oPC, GetLocation(GetWaypointByTag
   ("wp_jump")); would jump the PC to the wp_jump waypoint after a 20
   second delay.
*/
void CallJumpToLocation(int nCutscene, object oPC, location lLoc)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {
            AssignCommand(oPC, ActionJumpToLocation(lLoc));
        }
}

void CutJumpToLocation(float fDelay, object oPC, location lLoc, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallJumpToLocation(nCutscene, oPC, lLoc)));
}


// Used to jump the PC or NPC to an object.
/* Example: CutJumpToObject(20.0, oPC, GetObject(GetObjectByTag
   ("invis_object")); would jump the PC to the invis_object after a 20
   second delay.
*/
void CallJumpToObject(int nCutscene, object oPC, object oObject)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {
           if(GetCommandable(oPC) == FALSE)
           {
               //SetCommandable(TRUE, oPC);
               AssignCommand(oPC, JumpToObject(oObject));
               //AssignCommand(oPC, JumpToObject(oObject));
               //SetCommandable(FALSE, oPC);
           }
           else
               AssignCommand(oPC, JumpToObject(oObject));

        }
}

void CutJumpToObject(float fDelay, object oPC, object oObject, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallJumpToObject(nCutscene, oPC, oObject)));
}

// Used to force move the PC or NPC to an object.
void CallActionForceMoveToObject(int nCutscene, object oPC, object oTarget, int iRun, float fRange, float fTimeout)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
         if(GetCommandable(oPC) == FALSE)
         {
             SetCommandable(TRUE);
             AssignCommand(oPC, ActionForceMoveToObject(oTarget, iRun, fRange, fTimeout));
             SetCommandable(FALSE);
         }
         else
             AssignCommand(oPC, ActionForceMoveToObject(oTarget, iRun, fRange, fTimeout));
    }
}

void CutActionForceMoveToObject(float fDelay, object oPC, object oTarget, int iRun = FALSE, float fRange = 1.0, float fTimeout = 30.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallActionForceMoveToObject(nCutscene, oPC, oTarget, iRun, fRange, fTimeout)));
}

// Used to move the PC or NPC to an object.
/* Example: CutActionMoveToObject(2.0, oPC, oTable, TRUE); would have the
   PC run to oTable after a 2 second delay. TRUE = run, FALSE = walk.
*/
void CallActionMoveToObject(int nCutscene, object oPC, object oTarget, int iRun)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
         if(GetCommandable(oPC) == FALSE)
         {
             SetCommandable(TRUE);
             AssignCommand(oPC, ActionMoveToObject(oTarget, iRun));
             SetCommandable(FALSE);
         }
         else
             AssignCommand(oPC, ActionMoveToObject(oTarget, iRun));
    }
}

void CutActionMoveToObject(float fDelay, object oPC, object oTarget, int iRun, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallActionMoveToObject(nCutscene, oPC, oTarget, iRun)));
}

// Used to force move the PC or NPC to a location.
void CallActionForceMoveToLocation(int nCutscene, object oPC, location lLoc, int iRun, float fTimeout)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        if(GetCommandable(oPC) == FALSE)
        {
            SetCommandable(TRUE);
            AssignCommand(oPC, ActionForceMoveToLocation(lLoc, iRun, fTimeout));
            SetCommandable(FALSE);
         }
         else
             AssignCommand(oPC, ActionForceMoveToLocation(lLoc, iRun, fTimeout));
    }
}

void CutActionForceMoveToLocation(float fDelay, object oPC, location lLoc, int iRun = FALSE, float fTimeout = 30.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallActionForceMoveToLocation(nCutscene, oPC, lLoc, iRun, fTimeout)));
}


// Used to move the PC or NPC to a location.
/* Example: CutActionMoveToLocation(2.0, oPC, lTable, FALSE); would have the
   PC walk to lTable after a 2 second delay. TRUE = run, FALSE = walk.
*/
void CallActionMoveToLocation(int nCutscene, object oPC, location lLoc, int iRun)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        if(GetCommandable(oPC) == FALSE)
        {
            SetCommandable(TRUE);
            AssignCommand(oPC, ActionMoveToLocation(lLoc, iRun));
            SetCommandable(FALSE);
         }
         else
             AssignCommand(oPC, ActionMoveToLocation(lLoc, iRun));
    }
}

void CutActionMoveToLocation(float fDelay, object oPC, location lLoc, int iRun, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallActionMoveToLocation(nCutscene, oPC, lLoc, iRun)));
}


// Used to delay object create. Pass the type, the sTemplate, the location,
// and the effect you wish to have appear when the object is created
// (0 for no effect).  The PC is also passed to check cutscene abort.
/* EXAMPLE: CutCreateObject(2.3, oPC, OBJECT_TYPE_PLACEABLE, "resref", lLoc, VFX_FNF_HOLY_STRIKE);
   would create a placeable with the resref of "resref" at the location
   lLoc after 2.3 seconds, with the VFX_FNF_HOLY_STRIKE effect.
*/
void CallCreateObject(int nCutscene, int iType, object oPC, string sName, location lLoc, int iEffect, int nSetActive)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEffect), lLoc);
         object oObject = CreateObject(iType, sName, lLoc);
         if(nSetActive == TRUE)
         {
            CutSetActiveCutsceneForObject(oObject, nCutscene);
         }
    }

}

void CutCreateObject(float fDelay, object oPC, int iType, string sName, location lLoc, int iEffect, int nSetActive = TRUE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallCreateObject(nCutscene, iType, oPC, sName, lLoc, iEffect, nSetActive)));
}


// Used to set the facing of a creature.
/* EXAMPLE CutSetFacingPoint(22.5, oPC, "creature_tag"); would
   have the PC face "creature_tag" object after a 22.5 second delay.
*/
void CallSetFacingPoint(int nCutscene, object oPC, string szTag)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        AssignCommand(oPC, SetFacingPoint(GetPosition(GetObjectByTag(szTag))));
    }
}

void CutSetFacingPoint(float fDelay, object oPC, string szTag, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetFacingPoint(nCutscene, oPC, szTag)));
}

void CallAdjustReputation(int nCutscene, object oTarget, object oSource, int nAdjustment)
{
    if(nCutscene == GetLocalInt(oTarget, "nCutsceneNumber"))
    {
        AdjustReputation(oTarget, oSource, nAdjustment);
        if(GetIsPossessedFamiliar(oTarget))
        {
            AdjustReputation(GetMaster(oTarget), oSource, nAdjustment);
        }
        else if(GetIsPossessedFamiliar(oSource))
        {
            AdjustReputation(oSource, GetMaster(oTarget), nAdjustment);
        }
    }
}

void CutAdjustReputation(float fDelay, object oTarget, object oSource, int nAdjustment, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oTarget, iShift), CallAdjustReputation(nCutscene, oTarget, oSource, nAdjustment)));
}


// Used to fade out and back in, with a black screen section of
// fFadeLen seconds in between.
/* EXAMPLE: CallFadeOutAndIn(35.0, 2.0, oPC); would Fade the screen
   out and back in on the PC, after a delay of 35 seconds.
*/
void CallFadeOutAndIn(int nCutscene, object oObject, float fFadeLen, float fFadeSpeed)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        FadeToBlack(oObject, fFadeSpeed);
        //DelayCommand(2.3, BlackScreen(oObject));
        DelayCommand(fFadeLen, FadeFromBlack(oObject, fFadeSpeed));
    }
}

void CutFadeOutAndIn(float fDelay, object oObject, float fFadeLen = 4.3, float fFadeSpeed = FADE_SPEED_FASTEST, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallFadeOutAndIn(nCutscene, oObject, fFadeLen, fFadeSpeed)));
}

// Used to fade out.
/* EXAMPLE: CallFadeToBlack(35.0, oPC); would Fade the screen
   out on the PC, after a delay of 35 seconds.
*/
void CallFadeToBlack(int nCutscene, object oObject, float fFadeSpeed)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        FadeToBlack(oObject, fFadeSpeed);
    }
}

void CutFadeToBlack(float fDelay, object oObject, float fFadeSpeed = FADE_SPEED_FASTEST, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallFadeToBlack(nCutscene, oObject, fFadeSpeed)));
}

// Used to fade in.
/* EXAMPLE: CallFadeFromBlack(35.0, oPC); would Fade the screen
   in on the PC, after a delay of 35 seconds.
*/
void CallFadeFromBlack(int nCutscene, object oObject, float fFadeSpeed)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        FadeFromBlack(oObject, fFadeSpeed);
    }
}

void CutFadeFromBlack(float fDelay, object oObject, float fFadeSpeed  = FADE_SPEED_FASTEST, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallFadeFromBlack(nCutscene, oObject, fFadeSpeed)));
}

// Used to set the camera for cutscene dramatics.
/* EXAMPLE: To set a camera with the following settings on the PC,
   after a 30.0 second delay:
   CAMERA_MODE_TOP_DOWN
   Facing = 170.0
   Zoom = 5.0
   Pitch = 50.0
   CAMERA_TRANSITION_TYPE_MEDIUM

   CutSetCamera(30.0, oPC, CAMERA_MODE_TOP_DOWN, 170.0, 5.0, 50.0,
                CAMERA_TRANSITION_TYPE_MEDIUM);
*/
void CallSetCamera(int nCutscene, object oObject, int iCameraType, float fFacing, float fZoom, float fPitch, int nSpeed)
{
     if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
     {
        SetCameraMode(oObject, iCameraType);
        DelayCommand(0.1, AssignCommand(oObject, SetCameraFacing(fFacing, fZoom, fPitch, nSpeed)));
     }
}

void CutSetCamera(float fDelay, object oObject, int iCameraType, float fFacing, float fZoom, float fPitch, int nSpeed, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallSetCamera(nCutscene, oObject, iCameraType, fFacing, fZoom, fPitch, nSpeed)));
}

// Used to clear the actions of the subject.
/* EXAMPLE: CutClearAllActions(3.2, GetObjectByTag("guard"));
   would clear the actions of "guard" after a 3.2 second delay.
*/
void CallClearAllActions(int nCutscene, object oObject, int nClearCombatState = FALSE)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ClearAllActions(nClearCombatState));
    }
}

void CutClearAllActions(float fDelay, object oObject, int nClearCombatState = FALSE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallClearAllActions(nCutscene, oObject, nClearCombatState)));
}

// Used to apply a visual effect at a location. The PC is passed to
// determine if the cutscene has been aborted or not.
/* EXAMPLE: CutApplyEffectAtLocation(98.3, oPC, DURATION_TYPE_INSTANT,
                                     VXF_FNF_HOLY_STRIKE, lLoc, 0.0);
   would have a holy strike visual appear at lLoc after a 98.3 second delay.
   The duration is instant, lasting the default time.
*/
void CallApplyEffectAtLocation(int nCutscene, object oObject, int iDur, int iEffect, location lLoc, float fDur)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        effect eEffect = EffectVisualEffect(iEffect);
        ApplyEffectAtLocation(iDur, eEffect, lLoc, fDur);
    }

}

void CutApplyEffectAtLocation(float fDelay, object oObject, int iDur, int iEffect, location lLoc, float fDur = 0.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallApplyEffectAtLocation(nCutscene, oObject, iDur, iEffect, lLoc, fDur)));
}

// Used to apply a visual effect to an object.
/* EXAMPLE: CutApplyEffectToObject(98.3, oPC, DURATION_TYPE_TEMPORARY,
                                     VXF_DUR_PETRIFY, oPC, 4.0);
   would have a PETRIFY visual appear to the PC after a 98.3 second delay.
   The duration is temporary, lasting 4 seconds.
*/
void CallApplyEffectToObject(int nCutscene, int iDur, int iEffect, object oObject, float fDur)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        effect eEffect = EffectVisualEffect(iEffect);
        ApplyEffectToObject(iDur, eEffect, oObject, fDur);
    }
}

void CutApplyEffectToObject(float fDelay, int iDur, int iEffect, object oObject, float fDur = 0.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallApplyEffectToObject(nCutscene, iDur, iEffect, oObject, fDur)));
}

//For all other effects (NOT VISUAL EFFECTS)
//Used to apply a NON visual effect to an object.
void CallApplyEffectToObject2(int nCutscene, int iDur, effect eEffect, object oObject, float fDur)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        ApplyEffectToObject(iDur, eEffect, oObject, fDur);
    }
}

void CutApplyEffectToObject2(float fDelay, int iDur, effect eEffect, object oObject, float fDur = 0.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallApplyEffectToObject2(nCutscene, iDur, eEffect, oObject, fDur)));
}

// Used to apply a knockdown effect to an object.
/* EXAMPLE: CutKnockdown(98.3, oPC, 4.0);
   would have a knockdown appear on the PC after a 98.3 second delay.
   The duration is always temporary, this one lasting 4 seconds.
*/
void CallKnockdown(int nCutscene, object oObject, float fDur)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        effect eEffect = EffectKnockdown();
        int nTest = 0;
        if (GetPlotFlag(oObject) == TRUE)
        {
            nTest = 1;
            SetPlotFlag(oObject, FALSE);
        }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oObject, fDur);
        if (nTest == 1)
            SetPlotFlag(oObject, TRUE);
    }
}

void CutKnockdown(float fDelay, object oObject, float fDur = 3.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallKnockdown(nCutscene, oObject, fDur)));
}

void CallActionAttack(int nCutscene, object oAttacker, object oAttackee, int bPassive = FALSE)
{
    if(nCutscene == GetLocalInt(oAttacker, "nCutsceneNumber"))
    {
        AssignCommand(oAttacker, ActionAttack(oAttackee, bPassive));
    }
}

void CutActionAttack(float fDelay, object oAttacker, object oAttackee, int bPassive = FALSE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oAttacker, iShift), CallActionAttack(nCutscene, oAttacker, oAttackee, bPassive)));
}

// Used to apply a death effect to an object.
/* EXAMPLE: CutDeath(98.3, oPC, TRUE);
   would have a death appear on the PC after a 98.3 second delay.
   The duration is always instant. TRUE is used if you want a
   spectacular death. Set FALSE otherwise.
*/

void CallDeath(int nCutscene, object oObject, int iSpec)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        effect eEffect = EffectDeath(iSpec, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oObject);
    }

}

void CutDeath(float fDelay, object oObject, int iSpec = FALSE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallDeath(nCutscene, oObject, iSpec)));
}

// oObject would unlock oTarget
void CallActionUnlockObject(int nCutscene, object oObject, object oTarget)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionUnlockObject(oTarget));
    }
}

void CutActionUnlockObject(float fDelay, object oObject, object oTarget, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionUnlockObject(nCutscene, oObject, oTarget)));
}


// oObject would lock oTarget
void CallActionLockObject(int nCutscene, object oObject, object oTarget)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionLockObject(oTarget));
    }
}

void CutActionLockObject(float fDelay, object oObject, object oTarget, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionLockObject(nCutscene, oObject, oTarget)));
}

// oObject would flee lLoc
void CallActionMoveAwayFromLocation(int nCutscene, object oObject, location lLoc, int bRun, float fDistance)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionMoveAwayFromLocation(lLoc, bRun, fDistance));
    }
}

void CutActionMoveAwayFromLocation(float fDelay, object oObject, location lLoc, int bRun = FALSE, float fDistance = 40.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionMoveAwayFromLocation(nCutscene, oObject, lLoc, bRun, fDistance)));
}

// oObject would flee oTarget
void CallActionMoveAwayFromObject(int nCutscene, object oObject, object oTarget, int bRun, float fDistance)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionMoveAwayFromObject(oTarget, bRun, fDistance));
    }
}

void CutActionMoveAwayFromObject(float fDelay, object oObject, object oTarget, int bRun = FALSE, float fDistance = 40.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionMoveAwayFromObject(nCutscene, oObject, oTarget, bRun, fDistance)));
}


// oObject would follow oFollow
void CallActionForceFollowObject(int nCutscene, object oObject, object oFollow, float fFollowDistance)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionForceFollowObject(oFollow, fFollowDistance));
    }
}

void CutActionForceFollowObject(float fDelay, object oObject, object oFollow, float fFollowDistance = 0.0, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionForceFollowObject(nCutscene, oObject, oFollow, fFollowDistance)));
}


// oObject unequips oItem
void CallActionUnequipItem(int nCutscene, object oObject, object oItem)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionUnequipItem(oItem));
    }
}

void CutActionUnequipItem(float fDelay, object oObject, object oItem, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionUnequipItem(nCutscene, oObject, oItem)));
}


// oObject equips oItem in InvSlot
void CallActionEquipItem(int nCutscene, object oObject, object oItem, int nInvSlot)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionEquipItem(oItem, nInvSlot));
    }
}

void CutActionEquipItem(float fDelay, object oObject, object oItem, int nInvSlot, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionEquipItem(nCutscene, oObject, oItem, nInvSlot)));
}


// oObject would sit on oChair
void CallActionSit(int nCutscene, object oObject, object oChair)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionSit(oChair));
    }
}

void CutActionSit(float fDelay, object oObject, object oChair, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionSit(nCutscene, oObject, oChair)));
}


// oObject would open oDoor
void CallActionOpenDoor(int nCutscene, object oObject, object oDoor)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionOpenDoor(oDoor));
    }
}

void CutActionOpenDoor(float fDelay, object oObject, object oDoor, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionOpenDoor(nCutscene, oObject, oDoor)));
}

void CallActionCloseDoor(int nCutscene, object oCloser, object oDoor)
{
    if(nCutscene == GetLocalInt(oCloser, "nCutsceneNumber"))
    {
        AssignCommand(oCloser, ActionCloseDoor(oDoor));
    }
}

void CutActionCloseDoor(float fDelay, object oCloser, object oDoor, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oCloser, iShift), CallActionCloseDoor(nCutscene, oCloser, oDoor)));
}

// Used to cast a fake spell at an object.
/* EXAMPLE: CutActionCastFakeSpellAtObject(23.0, oPC, SPELL_SUNBEAM, oTarget,
            PROJECTILE_PATH_TYPE_DEFAULT); would have the
            PC cast a sunbeam at the oTarget, with a default
            projectile path. This would happen after a 23
            second delay.
*/
void CallActionCastFakeSpellAtObject(int nCutscene, int iSpell, object oObject, object oTarget, int iPath)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionCastFakeSpellAtObject(iSpell, oTarget, iPath));
    }
}

void CutActionCastFakeSpellAtObject(float fDelay, int iSpell, object oObject, object oTarget, int iPath = PROJECTILE_PATH_TYPE_DEFAULT, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionCastFakeSpellAtObject(nCutscene, iSpell, oObject, oTarget, iPath)));
}

// Used to cast a  spell at an object.
void CallActionCastSpellAtObject(int nCutscene, int iSpell, object oObject, object oTarget, int nMetaMagic, int bCheat, int nDomainLevel, int iPath, int bInstantSpell)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionCastSpellAtObject(iSpell, oTarget, nMetaMagic, nDomainLevel, iPath, bInstantSpell));
    }
}

void CutActionCastSpellAtObject(float fDelay, int iSpell, object oObject, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int iPath=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionCastSpellAtObject(nCutscene, iSpell, oObject, oTarget, nMetaMagic, bCheat, nDomainLevel, iPath, bInstantSpell)));
}

// Used to cast a fake spell at a location.
/* EXAMPLE: CutActionCastFakeSpellAtLocation(23.0, oPC, SPELL_SUNBEAM, lLoc,
            PROJECTILE_PATH_TYPE_DEFAULT); would have the
            PC cast a sunbeam at lLoc, with a default
            projectile path. This would happen after a 23
            second delay.
*/
void CallActionCastFakeSpellAtLocation(int nCutscene, int iSpell, object oObject, location lLoc, int iPath)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionCastFakeSpellAtLocation(iSpell, lLoc, iPath));
    }
}

void CutActionCastFakeSpellAtLocation(float fDelay, int iSpell, object oObject, location lLoc, int iPath = PROJECTILE_PATH_TYPE_DEFAULT, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionCastFakeSpellAtLocation(nCutscene, iSpell, oObject, lLoc, iPath)));
}

// Used to cast a spell at a location.

void CallActionCastSpellAtLocation(int nCutscene, int iSpell, object oObject, location lLoc, int nMetaMagic, int bCheat, int iPath, int bInstantSpell)
{
    if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
    {
        AssignCommand(oObject, ActionCastSpellAtLocation(iSpell, lLoc, nMetaMagic, bCheat, iPath, bInstantSpell));
    }
}

void CutActionCastSpellAtLocation(float fDelay, int iSpell, object oObject, location lLoc, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iPath=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallActionCastSpellAtLocation(nCutscene, iSpell, oObject, lLoc, nMetaMagic, bCheat, iPath, bInstantSpell)));
}

// Used to set the PC's location so they can be jumped around as though
// they are the camera.
/* EXAMPLE: CutSetLocation(23.0, oPC); would set the location
   on the PC, as a variable, as a location to be returned to later. This
   would happen after a 23 second delay.
*/
void CallSetLocation(int nCutscene, object oPC)
{
   if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
   {
       SetLocalLocation(oPC, "cut_jump_location", GetLocation(oPC));
       SetLocalInt(oPC, "X2_HasStoredLocation", 1);
   }
}

void CutSetLocation(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetLocation(nCutscene, oPC)));
}

// Used to recall the PC's location so they can be jumped back to their
// original location, stored by CutGetLocation.
/* EXAMPLE: CutRestoreLocation(23.0, oPC); would return the PC
   to their original spot. This would happen after a 23 second delay.
*/
void CallRestoreLocation(int nCutscene, object oPC)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        // Restoring location only if the pc has had a valid location set earlier.
        if(GetLocalInt(oPC, "X2_HasStoredLocation") == 1)
        {
            location lLoc = GetLocalLocation(oPC, "cut_jump_location");
            if(GetCommandable(oPC) == FALSE)
            {
               SetCommandable(TRUE, oPC);
               AssignCommand(oPC, JumpToLocation(lLoc));
               DelayCommand(0.2, SetCommandable(FALSE, oPC));
            }
            else
               AssignCommand(oPC, JumpToLocation(lLoc));
            SetLocalInt(oPC, "X2_HasStoredLocation", 0);
        }

    }
}

void CutRestoreLocation(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallRestoreLocation(nCutscene, oPC)));
}

void CutRestorePCAppearance(int nCutscene, object oPC)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        SetCameraHeight(oPC);
    }
    
    /*if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        int nChangedApp = GetLocalInt(oPC, "X2_CUT_CHANGE_APPEARANCE" + IntToString(nCutscene));
        if(nChangedApp == 0) // stay here only if the pc has changed in appearance by the cutscene system
            return;
        SetLocalInt(oPC, "X2_CUT_CHANGE_APPEARANCE" + IntToString(nCutscene), 0);
        // getting original appearance of pc
        int nOldApp = GetLocalInt(oPC, "X2_CUT_APPEARANCE");
        SetLocalInt(oPC, "X2_CUT_APPEARANCE", -1); // initializing
        if(GetAppearanceType(oPC) == nOldApp) // current appearance is the same as before changing it
        // the player has changed his appearance during the cutscene so there is no need to restore it
        // (the change was probably a run-off polymorph effect)
        {
            return;
        }

        // player has still a different appearance
        int nApp = -1;
        if(GetIsPossessedFamiliar(oPC))
            nApp = nOldApp; // a familiar should always be restored to the old appearance
        else if(GetRacialType(oPC) == RACIAL_TYPE_DWARF && GetAppearanceType(oPC) != APPEARANCE_TYPE_DWARF)
            nApp = APPEARANCE_TYPE_DWARF;
        else if(GetRacialType(oPC) == RACIAL_TYPE_ELF && GetAppearanceType(oPC) != APPEARANCE_TYPE_ELF)
            nApp = APPEARANCE_TYPE_ELF;
        else if(GetRacialType(oPC) == RACIAL_TYPE_HALFELF && GetAppearanceType(oPC) != APPEARANCE_TYPE_HALF_ELF)
            nApp = APPEARANCE_TYPE_HALF_ELF;
        else if(GetRacialType(oPC) == RACIAL_TYPE_HALFORC && GetAppearanceType(oPC) != APPEARANCE_TYPE_HALF_ORC)
            nApp = APPEARANCE_TYPE_HALF_ORC;
        else if(GetRacialType(oPC) == RACIAL_TYPE_HALFLING && GetAppearanceType(oPC) != APPEARANCE_TYPE_HALFLING)
            nApp = APPEARANCE_TYPE_HALFLING;
        else if(GetRacialType(oPC) == RACIAL_TYPE_GNOME && GetAppearanceType(oPC) != RACIAL_TYPE_GNOME)
            nApp = RACIAL_TYPE_GNOME;
        else if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN && GetAppearanceType(oPC) != RACIAL_TYPE_HUMAN)
            nApp = RACIAL_TYPE_HUMAN;
        else
            nApp = nOldApp;
        if(nApp == -1)
            return;

        SetCreatureAppearanceType(oPC, nApp);
        // apply inv effect so the player won't see the old form
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 1.5);
    }*/
}

void CutRemoveHenchmenAssociates(object oPC)
{

        object oAnimal;
        object oDominated;
        object oFamiliar;
        object oSummoned;
        int i = 1;
        object oHenchman = GetHenchman(oPC, i);
        while(oHenchman != OBJECT_INVALID)
        {
            oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oHenchman);
            oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oHenchman);
            oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oHenchman);
            oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oHenchman);
            DestroyObject(oAnimal);
            DestroyObject(oDominated);
            DestroyObject(oFamiliar);
            DestroyObject(oSummoned);
            i++;
            oHenchman = GetHenchman(oPC, i);
        }

}

void CallSetCutsceneMode(int nCutscene, object oPC, int iValue, int bInv, int bKeepAssociate = TRUE, int bFreezeAssociate = TRUE)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {
             if(iValue == FALSE) // Disable cutscene mode
             {
                  SetCutsceneMode(oPC, iValue);
                  SetPlotFlag(oPC, FALSE);
                  SetCommandable(TRUE, oPC);
                  UnFreezeAssociate(oPC);
                  CutSetActiveCutsceneForObject(oPC, 0);
                  SetCameraHeight(oPC, 0.0);
             }
             else // enable cutscene mode
             {
                  //SetLocalInt(oPC, "X2_CUT_APPEARANCE", -1);
                  AssignCommand(oPC, ClearAllActions(TRUE));
                  SetActionMode(oPC, ACTION_MODE_DETECT, FALSE);
                  SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
                  if(bInv >= TRUE)
                  {

                    //SetLocalInt(oPC, "X2_CUT_CHANGE_APPEARANCE" + IntToString(nCutscene), 1); // flagging pc as changed appearance
                    //SetLocalInt(oPC, "X2_CUT_APPEARANCE", GetAppearanceType(oPC));

                    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                        oPC, 9999.0));

                    if(bInv == CUT_CAMERA_HEIGHT_VERY_LOW)
                        DelayCommand(0.4, SetCameraHeight(oPC, 0.3));
                        //DelayCommand(0.4, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_CHICKEN));
                    if(bInv == CUT_CAMERA_HEIGHT_LOW)
                        DelayCommand(0.4, SetCameraHeight(oPC, 1.0));
                        //DelayCommand(0.4, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HALFLING_NPC_MALE));
                    if(bInv == CUT_CAMERA_HEIGHT_MEDIUM)
                        DelayCommand(0.4, SetCameraHeight(oPC, 1.25));
                        //DelayCommand(0.4, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HUMAN_NPC_MALE_01));
                    if(bInv == CUT_CAMERA_HEIGHT_HIGH)
                        DelayCommand(0.4, SetCameraHeight(oPC, 1.75));
                        //DelayCommand(0.4, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01));
                    if(bInv == CUT_CAMERA_HEIGHT_VERY_HIGH)
                        DelayCommand(0.4, SetCameraHeight(oPC, 5.0));
                        //DelayCommand(0.4, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GIANT_FROST));
                  }
                  SetCutsceneMode(oPC, iValue);
                  if(bFreezeAssociate == TRUE || bFreezeAssociate == VANISH)
                  {
                      int bVanish = FALSE;
                      if(bFreezeAssociate == VANISH)
                          bVanish = TRUE;
                      object oDominated = FreezeAssociate(oPC, bVanish);
                      if (GetIsObjectValid(oDominated) == TRUE)
                         SetLocalObject(oPC, "oDominated", oDominated);
                  }
                  // Destroy associates.
                  if (bKeepAssociate == FALSE)
                  {
                      if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC) != OBJECT_INVALID)
                         DestroyObject(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC));
                      if(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC) != OBJECT_INVALID)
                         DestroyObject(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC));
                      if(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC) != OBJECT_INVALID)
                         DestroyObject(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC));
                      if(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC) != OBJECT_INVALID)
                         DestroyObject(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC));
                  }
                  // Remove Henchmens' associates
                  CutRemoveHenchmenAssociates(oPC);
             }
        }
}

void CutSetCutsceneMode(float fDelay, object oPC, int iValue, int bInv, int bKeepAssociate = TRUE, int bFreezeAssociate = TRUE, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetCutsceneMode(nCutscene, oPC, iValue, bInv, bKeepAssociate, bFreezeAssociate)));
}

// Used to turn plot flags on or off.
/* EXAMPLE: CutSetPlotFlag(10.0, oObject, 1); would turn plot flag to
   on after 10 seconds for the object.
*/
void CallSetPlotFlag(int nCutscene, object oObject, int iValue)
{
        if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
        {

             SetPlotFlag(oObject, iValue);

        }
}

void CutSetPlotFlag(float fDelay, object oObject, int iValue, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallSetPlotFlag(nCutscene, oObject, iValue)));
}

// Used to destroy objects. Make sure they are destroyable first with the
// CutSetPlotFlag function.
/* EXAMPLE: CutDestroyObject(10.0, oObject); would destroy the object
   after 10 seconds.
*/
void CallDestroyObject(int nCutscene, object oObject)
{
        if(nCutscene == GetLocalInt(oObject, "nCutsceneNumber"))
        {

             DestroyObject(oObject);

        }
}

void CutDestroyObject(float fDelay, object oObject, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oObject, iShift), CallDestroyObject(nCutscene, oObject)));
}

// Used to store the camera position.
/* EXAMPLE: CutStoreCameraFacing(10.0, oPC); would set the current
   camera settings at the 10.0 mark.
*/
void CallStoreCameraFacing(int nCutscene, object oPC)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {

             StoreCameraFacing();

        }
}

void CutStoreCameraFacing(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallStoreCameraFacing(nCutscene, oPC)));
}

// Used to restore the camera position.
/* EXAMPLE: CutRestoreCameraFacing(10.0, oPC); would set the old
   camera settings back at the 10.0 mark.
*/
void CallRestoreCameraFacing(int nCutscene, object oPC)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {

             RestoreCameraFacing();

        }
}

void CutRestoreCameraFacing(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallRestoreCameraFacing(nCutscene, oPC)));
}

// Used to set the screen to black.  This is very useful in covering up
// and cutscene jumps that happen in the same area as the play area.
/* EXAMPLE: CutBlackScreen(10.0, oPC); would set the screen to black
   at the 10.0 mark.
*/
void CallBlackScreen(int nCutscene, object oPC)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {

             BlackScreen(oPC);

        }
}

void CutBlackScreen(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallBlackScreen(nCutscene, oPC)));
}

// Used to remove the screen to black.
/* EXAMPLE: CutStopFade(10.0, oPC); would set the screen back from black
   at the 10.0 mark.
*/
void CallStopFade(int nCutscene, object oPC)
{
        if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
        {

             StopFade(oPC);

        }
}

void CutStopFade(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallStopFade(nCutscene, oPC)));
}

void CallPlayVoiceChat(int nCutscene, object oPC, int nChatID)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        AssignCommand(oPC, PlayVoiceChat(nChatID));
    }
}

void CutPlayVoiceChat(float fDelay, object oPC, int nChatID, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallPlayVoiceChat(nCutscene, oPC, nChatID)));
}

void CallPlaySound(int nCutscene, object oPC, string szSound)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        AssignCommand(oPC, PlaySound(szSound));
    }
}

void CutPlaySound(float fDelay, object oPC, string szSound, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallPlaySound(nCutscene, oPC, szSound)));
}

// Setting a background ambient sounds and playing it for the area where oPC is in.
void CallSetAmbient(int nCutscene, object oPC, int nTrack)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        // change for both day and night
        AmbientSoundChangeDay(GetArea(oPC), nTrack);
        AmbientSoundChangeNight(GetArea(oPC), nTrack);

        // play new ambient sounds
        AmbientSoundPlay(GetArea(oPC));
    }
}

void CutSetAmbient(float fDelay, object oPC, int nTrack, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetAmbient(nCutscene, oPC, nTrack)));
}

// Setting a background music and playing it for the area where oPC is in.
void CallSetMusic(int nCutscene, object oPC, int nTrack)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        // change for both day and night
        MusicBackgroundChangeDay(GetArea(oPC), nTrack);
        MusicBackgroundChangeNight(GetArea(oPC), nTrack);

        // stop any battle music and play the new music
        MusicBattleStop(GetArea(oPC));
        MusicBackgroundPlay(GetArea(oPC));
    }

}

void CutSetMusic(float fDelay, object oPC, int nTrack, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetMusic(nCutscene, oPC, nTrack)));
}

// keep old background music
void CallStoreMusic(int nCutscene, object oPC)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        SetLocalInt(GetArea(oPC), "X2_MUSIC_DAY", MusicBackgroundGetDayTrack(GetArea(oPC)));
        SetLocalInt(GetArea(oPC), "X2_MUSIC_NIGHT", MusicBackgroundGetNightTrack(GetArea(oPC)));
    }
}

void CutStoreMusic(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallStoreMusic(nCutscene, oPC)));
}

// restore old background music. Notice that there is no cutscene number check - so music can
// be restoed after aborting a cutscene
void CallRestoreMusic(int nCutscene, object oPC)
{
    MusicBackgroundChangeDay(GetArea(oPC), GetLocalInt(GetArea(oPC), "X2_MUSIC_DAY"));
    MusicBackgroundChangeNight(GetArea(oPC), GetLocalInt(GetArea(oPC), "X2_MUSIC_NIGHT"));
}

void CutRestoreMusic(float fDelay, object oPC, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallRestoreMusic(nCutscene, oPC)));
}

void CallSetTileMainColor(int nCutscene, object oPC, location lLoc, int nMainColor1, int nMainColor2)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        vector vPos = GetPositionFromLocation(lLoc);
        vPos.x /= 10;
        vPos.y /= 10;
        lLoc = Location(GetArea(OBJECT_SELF), vPos, 0.0);
        SetTileMainLightColor(lLoc, nMainColor1, nMainColor2);
        RecomputeStaticLighting(GetArea(oPC));
    }
}

void CutSetTileMainColor(float fDelay, object oPC, location lLoc, int nMainColor1, int nMainColor2, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetTileMainColor(nCutscene, oPC, lLoc, nMainColor1, nMainColor2)));
}

void CallSetTileSourceColor(int nCutscene, object oPC, location lLoc, int nSourceColor1, int nSourceColor2)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        vector vPos = GetPositionFromLocation(lLoc);
        vPos.x /= 10;
        vPos.y /= 10;
        lLoc = Location(GetArea(OBJECT_SELF), vPos, 0.0);
        SetTileSourceLightColor(lLoc, nSourceColor1, nSourceColor2);
        RecomputeStaticLighting(GetArea(oPC));
    }
}

void CutSetTileSourceColor(float fDelay, object oPC, location lLoc, int nSourceColor1, int nSourceColor2, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetTileSourceColor(nCutscene, oPC, lLoc, nSourceColor1, nSourceColor2)));
}

void CallSetWeather(int nCutscene, object oPC, int nWeather)
{
    if(nCutscene == GetLocalInt(oPC, "nCutsceneNumber"))
    {
        SetWeather(GetArea(oPC), nWeather);
    }
}

void CutSetWeather(float fDelay, object oPC, int nWeather, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetWeather(nCutscene, oPC, nWeather)));
}

void CallSetCameraSpeed(int nCutscene, object oPC, float fMovementRateFactor)
{
    if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
    {
        SetCutsceneCameraMoveRate(oPC, fMovementRateFactor);
    }

}

void CutSetCameraSpeed(float fDelay, object oPC, float fMovementRateFactor, int iShift = TRUE)
{
    int nCutscene = GetActiveCutsceneNum();
    fDelay = CutCalculateCurrentDelay(fDelay, nCutscene);
    DelayCommand(fDelay, DelayCommand(GetShift(oPC, iShift), CallSetCameraSpeed(nCutscene, oPC, fMovementRateFactor)));
}

void CutDisableCutscene(int nCutscene, float fCleanupDelay, float fDestPCCopyDelay, int nRestoreType = RESTORE_TYPE_NORMAL)
{
    if(GetLocalInt(GetModule(), "X2_DelayType" + IntToString(nCutscene)) != CUT_DELAY_TYPE_CONSTANT)
    {
        fCleanupDelay = CutCalculateCurrentDelay(fCleanupDelay, nCutscene);
        fDestPCCopyDelay = CutCalculateCurrentDelay(fDestPCCopyDelay, nCutscene);
    }
    // Setting constant delay
    object oPC = GetFirstPC();

    while(oPC != OBJECT_INVALID)
    {
        object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
        if(oFamiliar != OBJECT_INVALID && GetIsPossessedFamiliar(oFamiliar))
            oPC = oFamiliar;

        if(CutGetActiveCutsceneForObject(oPC) == nCutscene)
        {
            // Notice that the following functions use the delay supplied
            // by the CutSetAbortDelay() function (defaults to 0)
            //CutRestoreCameraFacing(fDelay1, oPC, FALSE);
            string sDelayVariable = "X2_fCutscene" + IntToString(nCutscene) + "Delay";

            //DelayCommand(fCleanupDelay - 1.0, CutRestorePCAppearance(nCutscene, oPC));
            DelayCommand(fCleanupDelay, SetLocalFloat(GetModule(), sDelayVariable, 0.0));
            DelayCommand(fCleanupDelay, CallRemoveAssociatesEffects(nCutscene, oPC));
            DelayCommand(fCleanupDelay, CallRemoveEffects(nCutscene, oPC));
            if(nRestoreType == RESTORE_TYPE_NORMAL)
                DelayCommand(fCleanupDelay, CallRestoreLocation(nCutscene, oPC));
            DelayCommand(fCleanupDelay + 0.3, CallSetCutsceneMode(nCutscene, oPC, FALSE, FALSE, FALSE, FALSE));
            if(nRestoreType == RESTORE_TYPE_COPY)
                DelayCommand(fCleanupDelay, CallRestorePCCopyLocation(nCutscene, oPC));
            // oPC is not the main pc for the cutscene after the following line:
            // Notice that this function uses the delay supplied by the
            // CutSetDestroyCopyDelay() function (defaults to 0).

            DelayCommand(fDestPCCopyDelay, CallDestroyPCCopy(nCutscene, oPC, FALSE)); // destroys copy if it exists
        }
        oPC = GetNextPC();
    }
    DelayCommand(fCleanupDelay + 0.8, CutSetActiveCutscene(-1, CUT_DELAY_TYPE_CONSTANT));
}
