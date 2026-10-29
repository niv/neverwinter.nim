//::///////////////////////////////////////////////
//:: x2_act_ws_makeit
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Modifies the current item with the currently
    selected item property.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"
#include "x2_inc_cutscene"



void StartCutscene(object oPC);
void StartCutscene2(object oPC);
void CopyUpgradeItem(object oItem, object oPC);
void MakeNewWeapon(object oPC);

int nCutsceneNumber = 114;

void main()
{
    object oPC = GetPCSpeaker();

    object oItem = GetRightHandWeapon(oPC);
    // * Oct 15: If the player has unequipped his item for some bizarre reason just
    // * abort the entire thing
    if (GetIsObjectValid(oItem) == FALSE)
    {
        return;
    }

    ActionPauseConversation();

    if(GetTag(GetArea(oPC)) != "HellbreathTavern")
    {
        //Only show the cutscene once
        if (GetLocalInt(oPC, "X2_Chapter2SmithCut") == 1)
        {
            MakeNewWeapon(oPC);
            return;
        }
        SetLocalInt(oPC, "X2_Chapter2SmithCut", 1);
        DelayCommand(0.7, StartCutscene(oPC));
    }
    else
    {
        //Only show the cutscene once
        if (GetLocalInt(oPC, "X2_Chapter3SmithCut") == 1)
        {
            MakeNewWeapon(oPC);
            return;
        }
        SetLocalInt(oPC, "X2_Chapter3SmithCut", 1);
        DelayCommand(0.7, StartCutscene2(oPC));
    }

    //Set Cutscene 114 as active for all future calls to Cut_ commands
    CutSetActiveCutscene(nCutsceneNumber, CUT_DELAY_TYPE_CONSTANT);

    AssignCommand(oPC, ClearAllActions());
    //Fade PCs to black
    BlackScreen(oPC);
    CutSetActiveCutsceneForObject(oPC, nCutsceneNumber, TRUE);
    CutDisableAbort(nCutsceneNumber);

    CutSetCutsceneMode(0.5, oPC, TRUE, TRUE, TRUE, TRUE); // pc invis - keep and freeze associates

    CutFadeFromBlack(1.5, oPC, FADE_SPEED_MEDIUM, FALSE);


}

void StartCutscene(object oPC)
{

    //Change the Music
    object oArea = GetArea(oPC);
    MusicBattlePlay(oArea);
    // Cutscene actors and objects.
    // Invisible creature "takes" item

    location lLoc = GetLocation(GetNearestObjectByTag("SpawnHere"));
    object oHelper = CreateObject(OBJECT_TYPE_CREATURE, "x2_helper", lLoc);
    object oSmith = OBJECT_SELF;
    object oForge = GetNearestObjectByTag("x2_magic_forge");

    CutSetActiveCutsceneForObject(oHelper, nCutsceneNumber);
    CutSetActiveCutsceneForObject(oSmith, nCutsceneNumber);
    CutSetActiveCutsceneForObject(oForge, nCutsceneNumber);

    CutApplyEffectToObject2(0.0, DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oHelper);
    //Locations
    location lForge = GetLocation(GetNearestObjectByTag("X2_Forge"));

    //Camera waypoints
    object oCamera1 = GetNearestObjectByTag("wp_cut114_camera1");
    location lCamera1 = GetLocation(GetNearestObjectByTag("wp_cut114_camera1"));
    location lCamera2 = GetLocation(GetNearestObjectByTag("wp_cut114_camera2"));

    //Make a copy of the PC to move about
    location lStart = GetLocation(oPC);
    object oCopy =  CutCreatePCCopy(oPC, lStart, "Cut114PCCopy");
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    CutSetActiveCutsceneForObject(oCopy, nCutsceneNumber);

    // Camera movements (includes moving the PC as the camera.
    //////////////////////////////////////////////////////////
    CutJumpToObject(0.0, oPC, oCamera1, TRUE);
    CutSetCamera(0.0, oPC, CAMERA_MODE_TOP_DOWN, 90.0, 10.0, 75.0,
                 CAMERA_TRANSITION_TYPE_SNAP);
    CutSetCamera(0.2, oPC, CAMERA_MODE_TOP_DOWN, 150.0, 13.0, 50.0,
                 CAMERA_TRANSITION_TYPE_SLOW);

    CutActionMoveToLocation(0.2, oPC, lCamera2, FALSE, FALSE);
    // Smith chants
    //CutPlayAnimation(0.7, oSmith, ANIMATION_LOOPING_MEDITATE, 6.0, FALSE);
    CutPlaySound(0.5, oSmith, "al_mg_chntmagic1", FALSE);


    // * Make creature invisible and non bumpable
   // effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
   // ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oHelper);
    effect eNoBump = EffectCutsceneGhost();
    CutApplyEffectToObject2(0.0, DURATION_TYPE_PERMANENT, eNoBump, oHelper);

    object oItem = GetRightHandWeapon(oCopy);
    object oItem2 = GetRightHandWeapon(oPC);

//    SpeakString("OLD " + GetName(oItem));
//    object oNewItem = CopyItem(oItem, oHelper, TRUE);
//    SpeakString("NEW " + GetName(oNewItem));

    //AssignCommand(oPC, ActionUnequipItem(oItem)); // * unequip the item
    object oNewItem = CopyItem(oItem, oCopy, TRUE);

    DelayCommand(2.0, AssignCommand(oCopy, ActionGiveItem(oNewItem, oHelper)));

    DestroyObject(oItem, 2.0);
    DestroyObject(oItem2, 2.0);
    CutClearAllActions(1.5, oHelper, FALSE);
    CutActionEquipItem(2.4, oHelper, oNewItem, INVENTORY_SLOT_RIGHTHAND);

    // Runs up to forge

    CutActionMoveToLocation(3.0, oHelper, lForge, FALSE, FALSE);

    // * Need visual effects to hide the sword moving from you to the object
    // Light up Forge
    effect eStrike = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    effect eLink = EffectLinkEffects(eStrike, eShake);
    CutApplyEffectToObject2(5.0, DURATION_TYPE_INSTANT, eLink, oForge);
    CutPlayAnimation(5.0, oForge, ANIMATION_PLACEABLE_ACTIVATE, 5.0, FALSE);

    effect eRing = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    CutApplyEffectToObject(6.1, DURATION_TYPE_TEMPORARY, VFX_DUR_ELEMENTAL_SHIELD, oHelper, 0.7);

    // Item is enhanced
    DelayCommand(6.0, wsEnhanceItem(oHelper, oPC));

    //Copy the upgraded item into the PCs inventory
    DelayCommand(7.0, CopyUpgradeItem(oNewItem, oPC));

    CutPlayAnimation(6.0, oHelper, ANIMATION_FIREFORGET_VICTORY2, 3.0, FALSE);

    // Weapon Given back to player
    CutClearAllActions(7.5, oHelper, FALSE, FALSE);
    CutActionMoveToObject(8.0, oHelper, oCopy, TRUE);
    DelayCommand(9.7, AssignCommand(oHelper, ActionGiveItem(oNewItem, oCopy)));
    DelayCommand(11.0, AssignCommand(oCopy, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND)));
    CutPlayAnimation(12.0, oCopy, ANIMATION_FIREFORGET_VICTORY2, 2.0);
    // End Cutscene

    CutFadeOutAndIn(13.0, oPC);


    //Clean up actors...
    CutDestroyObject(14.3, oHelper);

    CutDisableCutscene(nCutsceneNumber, 14.5, 14.5, RESTORE_TYPE_COPY);

    // * Resume conversation    - Cleanup

    DelayCommand(15.5, ActionResumeConversation());

}

void StartCutscene2(object oPC)
{
    //Change the Music
    object oArea = GetArea(oPC);
    MusicBattlePlay(oArea);
    // Cutscene actors and objects.
    // Invisible creature "takes" item

    location lLoc = GetLocation(GetNearestObjectByTag("SpawnHere"));
    object oHelper = CreateObject(OBJECT_TYPE_CREATURE, "x2_helper", lLoc);
    object oSmith = OBJECT_SELF;
    object oForge = GetNearestObjectByTag("x2_magic_forge");

    CutSetActiveCutsceneForObject(oHelper, nCutsceneNumber);
    CutSetActiveCutsceneForObject(oSmith, nCutsceneNumber);
    CutSetActiveCutsceneForObject(oForge, nCutsceneNumber);
    //Locations
    location lForge = GetLocation(GetNearestObjectByTag("X2_Forge"));

    //Camera waypoints
    object oCamera1 = GetNearestObjectByTag("wp_cut114_camera1");
    location lCamera1 = GetLocation(GetNearestObjectByTag("wp_cut114_camera1"));
    location lCamera2 = GetLocation(GetNearestObjectByTag("wp_cut114_camera2"));

    //Make a copy of the PC to move about
    location lStart = GetLocation(GetNearestObjectByTag("hx_smith_wp", oPC));
    object oCopy =  CutCreatePCCopy(oPC, lStart, "Cut114PCCopy");
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    CutSetActiveCutsceneForObject(oCopy, nCutsceneNumber);

    // Camera movements (includes moving the PC as the camera.
    //////////////////////////////////////////////////////////
    CutJumpToObject(0.0, oPC, oCamera1, TRUE);
    CutSetCamera(0.0, oPC, CAMERA_MODE_TOP_DOWN, 40.0, 6.0, 80.0,
                 CAMERA_TRANSITION_TYPE_SNAP);
    CutSetCamera(0.2, oPC, CAMERA_MODE_TOP_DOWN, 40.0, 3.0, 80.0,
                 CAMERA_TRANSITION_TYPE_VERY_SLOW);
    // Smith chants
    //CutPlayAnimation(0.7, oSmith, ANIMATION_LOOPING_MEDITATE, 6.0, FALSE);
    CutPlaySound(0.5, oSmith, "al_mg_chntmagic1", FALSE);


    // * Make creature invisible and non bumpable
   // effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
   // ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oHelper);
    effect eNoBump = EffectCutsceneGhost();
    CutApplyEffectToObject2(0.0, DURATION_TYPE_PERMANENT, eNoBump, oHelper);

    object oItem = GetRightHandWeapon(oCopy);
    object oItem2 = GetRightHandWeapon(oPC);

//    SpeakString("OLD " + GetName(oItem));
//    object oNewItem = CopyItem(oItem, oHelper, TRUE);
//    SpeakString("NEW " + GetName(oNewItem));

    //AssignCommand(oPC, ActionUnequipItem(oItem)); // * unequip the item
    object oNewItem = CopyItem(oItem, oCopy, TRUE);


    DelayCommand(2.0, AssignCommand(oCopy, ActionGiveItem(oNewItem, oHelper)));

    DestroyObject(oItem, 2.0);
    DestroyObject(oItem2, 2.0);
    CutClearAllActions(1.5, oHelper, FALSE);
    CutActionEquipItem(2.4, oHelper, oNewItem, INVENTORY_SLOT_RIGHTHAND);

    // Runs up to forge

    CutActionMoveToLocation(3.0, oHelper, lForge, FALSE, FALSE);

    // * Need visual effects to hide the sword moving from you to the object
    // Light up Forge
    effect eStrike = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    effect eLink = EffectLinkEffects(eStrike, eShake);
    CutApplyEffectToObject2(5.0, DURATION_TYPE_INSTANT, eLink, oForge);
    CutPlayAnimation(5.0, oForge, ANIMATION_PLACEABLE_ACTIVATE, 5.0, FALSE);

    effect eRing = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    CutApplyEffectToObject(6.1, DURATION_TYPE_TEMPORARY, VFX_DUR_ELEMENTAL_SHIELD, oHelper, 0.7);

    // Item is enhanced
    DelayCommand(6.0, wsEnhanceItem(oHelper, oPC));

    //Copy the upgraded item into the PCs inventory
    DelayCommand(7.0, CopyUpgradeItem(oNewItem, oPC));

    CutPlayAnimation(6.0, oHelper, ANIMATION_FIREFORGET_VICTORY2, 3.0, FALSE);

    // Weapon Given back to player
    CutClearAllActions(7.5, oHelper, FALSE, FALSE);
    CutActionMoveToObject(8.0, oHelper, oCopy, TRUE);
    DelayCommand(9.7, AssignCommand(oHelper, ActionGiveItem(oNewItem, oCopy)));
    DelayCommand(11.0, AssignCommand(oCopy, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND)));
    CutPlayAnimation(12.0, oCopy, ANIMATION_FIREFORGET_VICTORY2, 2.0);
    // End Cutscene

    CutFadeOutAndIn(13.0, oPC);


    //Clean up actors...
    CutDestroyObject(14.3, oHelper);

    CutDisableCutscene(nCutsceneNumber, 14.5, 14.5, RESTORE_TYPE_COPY);

    // * Resume conversation    - Cleanup

    DelayCommand(15.5, ActionResumeConversation());
}

void CopyUpgradeItem(object oItem, object oPC)
{
   object oNewItem = CopyItem(oItem, oPC, TRUE);
   //---------------------------------------------------------------------------
   // GZ: Bugfix for #35259 - Item properties staying around
   //---------------------------------------------------------------------------
   IPRemoveAllItemProperties(oNewItem,DURATION_TYPE_TEMPORARY);
   DelayCommand(1.0, AssignCommand(oPC, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND)));

}

void MakeNewWeapon(object oPC)
{
    wsEnhanceItem(oPC, oPC);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
    PlaySound("sim_bonholy");
    location lPC = GetLocation(oPC);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), lPC);
}
