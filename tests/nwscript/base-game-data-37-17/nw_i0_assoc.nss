//::///////////////////////////////////////////////
//:: Generic Associate Commands
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a wrapper route all associate
    behavior through some common routines.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  October 22, 2001
//:://////////////////////////////////////////////


#include "nw_i0_generic"

// * Function Declarations
void SpeakQuickChat(string sVoice);
void DebugSTR(string s);
int IsBusy();
void SetIsBusy(int bIsBusy);
void DetermineAssociateCombatRound();
void OpenNearestLock();
void DoFollowMaster();
void GetBehind();

// * Function Implementation


void DebugSTR(string s)
{
    SpeakString("DEBUG: " + s);
}


void DetermineAssociateCombatRound()
{
        int nClass = GetClassByPosition(1);
        DetermineCombatRound(nClass);
        DebugSTR("I should be fighting");
}

//::///////////////////////////////////////////////
//:: OpenNearestLock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will try to unlock the lock.
    
    ------------
    Interaction:
    ------------
    Will check in User Defined in 3 seconds to see
    if lockpick was succesful, otherwise
    will say a I failed message
*/
//:://////////////////////////////////////////////
//:: Created By:    Brent
//:: Created On:    October 23, 2001
//:://////////////////////////////////////////////

void OpenNearestLock()
{
    object oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR,GetLocation(GetMaster()));
    // * don't try if have no open lock skill
    if (GetSkillRank(SKILL_OPEN_LOCK) <= 0)
    {
        return;
    }
    SetIsBusy(TRUE);

    if (GetIsObjectValid(oLastObject) == FALSE)
    {
        DebugSTR("invalid unlocking object");
       return; // no valid door or placeable nearby
    }

    // *
    // * If blocked, ask the player to move aside
    // *
    event evOrder = EventUserDefined(9);
    DelayCommand(5.0,SignalEvent(OBJECT_SELF, evOrder));

    DebugSTR("Unlocking");
    // * delay command to give master chance to move aside
    DelayCommand(0.5,ActionUseSkill(SKILL_OPEN_LOCK,oLastObject));
    DelayCommand(0.5,SpeakQuickChat("Task, Can do"));

    DelayCommand(3.0, SetIsBusy(FALSE));
    // * move away from object
    
//Delay?    ActionMoveAwayFromObject(oLastObject);

}

//::///////////////////////////////////////////////
//:: DoFollowMaster
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Follows the master.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoFollowMaster()
{
    object oMaster = GetMaster();
    float SOCIAL_RANGE = GetLocalFloat(OBJECT_SELF,"NW_MINION_DISTANCE");
    DebugSTR("in dofollowmaster");
    if ( (IsBusy() == FALSE) && (GetDistanceToObject(oMaster) > SOCIAL_RANGE )    )
    {
        ClearAllActions();
        // * Need ActionForceMoveToObject
        ActionMoveToObject(GetMaster(), TRUE, SOCIAL_RANGE);
//        GetBehind();
    }
}

//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does not
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int IsBusy()
{
	// *
	// * if no valid attack targets then I am not in combat
	if (GetIsObjectValid(GetAttackTarget()) == FALSE && GetIsObjectValid(GetAttemptedAttackTarget()) == FALSE && GetLocalInt(OBJECT_SELF,"NW_ASSOCAMIBUSY") == FALSE)
	{
		return FALSE;
	}
	return TRUE;

}

//::///////////////////////////////////////////////
//:: SetIsBusy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Certain operations (like unlocking objects)
    will put a henchman into a busy state.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SetIsBusy(int bIsBusy)
{
    SetLocalInt(OBJECT_SELF,"NW_ASSOCAMIBUSY", bIsBusy);
}

//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SpeakQuickChat(string sVoice)
{
	SpeakString("FAKEQUICKCHAT: " + sVoice);
}

//::///////////////////////////////////////////////
//:: GetBehind
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Moves behind the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan
//:: Created On: Winter 2001
//:://////////////////////////////////////////////

void GetBehind()
{

      	object oTarget = GetMaster();
    	float fFacing = GetFacing(oTarget);

	location vPosition = GetLocation(oTarget);
    location vOldPosition = vPosition;
    vector vPos = GetPositionFromLocation(vPosition);

    DebugSTR("moving behind");

	if (fFacing >= DIRECTION_EAST && fFacing < DIRECTION_NORTH)
// facing relative (cartisian quadrent) Q I with PC at origin.  Creature moves to QIII
	{
		vPos.x = vPos.x - 1.0;
		vPos.y = vPos.y - 1.0;
	}
	if(fFacing >= DIRECTION_NORTH && fFacing < DIRECTION_WEST)
// facing relative Q II with PC at origin. Creature moves to Q IV
	{
		vPos.x = vPos.x + 1.0;
		vPos.y = vPos.y - 1.0;
	}
	if(fFacing >= DIRECTION_WEST && fFacing < DIRECTION_SOUTH)
// facing relative Q III with PC at origin. Creature moves to Q I
	{
		vPos.x = vPos.x + 1.0;
		vPos.y = vPos.y + 1.0;
	}
	if(fFacing >= DIRECTION_SOUTH && fFacing < DIRECTION_SOUTH + 90)
// facing relative Q IV with PC at origin. Creature moves to Q II
	{
		vPos.x = vPos.x - 1.0;
		vPos.y = vPos.y + 1.0;
	}

    vPosition = Location(GetAreaFromLocation(vPosition), vPos,GetFacingFromLocation(vPosition));
    ActionMoveToLocation(vPosition);
    // * didn't actually find a valid location
    if (vPosition == vOldPosition)
    {
        DebugSTR("nowhere to move behind to");
    }
}// end of Script

