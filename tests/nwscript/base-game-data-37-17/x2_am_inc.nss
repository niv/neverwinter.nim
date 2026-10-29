//::///////////////////////////////////////////////
//:: x2_am_inc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    AMBIENT SYSTEM INCLUDE
    - Generic system for TownLife
    - Encapsulates all 'townie' behavior
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


//:://////////////////////////////////////////////
// * JOBS
//:://////////////////////////////////////////////

// PERFORMANCE: Actual calls to debug should be removed at end
void debug(string s, object oTarget =OBJECT_SELF)
{
 //   AssignCommand(oTarget, SpeakString("----------------"+ s));
}


// * CONSTANTS

const int LEISURE_THRESHHOLD =100; // * This is the number when NPCs will stop using Leisure objects
const int EVENT_NEEDMOREPATRONS = 5000; // * event number when one HUB asks another for extra patrons
const int  EVENT_IT_SHOUTS = 5001;
const int  EVENT_NOTIT_SHOUTS = 5002;
const int EVENT_IAMTHEHUNTER = 5003; // * tells hunter to broadcast its hunter message every second

const int LISTEN_MOVETOTOWNHUB = 999;// * Listen pattern to get people moving towards a
                                // * townhub
const int LISTEN_SOMEONEISIT = 998;   // * IT shouts this every heartbeat
const int  LISTEN_IHUNTYOU = 997; // * hunters say this to scare prey
const int LISTEN_IAMNOTIT = 996; // * if I am not it, I tell it this, so it comes and get me
const int LISTEN_GOAWAY = 995; // * stray dog goes away if told to



const int PLOT_COST_ALE = 1;
const int PLOT_COST_SPIRITS = 5;
const int PLOT_COST_WINE = 10;
const float fDelayBetweenBarmaidAskingForDrinks = 60.0;
const float FPATRONDELAY = 40.0; // * delay between patrons spawning in when others leave
const float DISTANCE_TALKHUB = 4.0;

const float DISTANCE_OBJECT_TALK = 10.0; // * Distance that objects will request works


const int JOB_BARMAID = 1000;  ////////////////////////////////
                         // JOB: Will wander around
                         // a room and serve drinks to
                         // NPCs and PCs
                         ////////////////////////////////
                            void BarmaidMakeDrink(string sDrink, int nAmount);
                            void BarmaidMakeDrunk(object oTarget, int nPoints);
                            // * sets up the drink prices for this Inn
                            void SetupInn1DrinkPrices();
const int JOB_BLACKSMITH = 1001;////////////////////////////////
                         // JOB: Moves around room.
                         //
                         //
                         ////////////////////////////////
const int JOB_GUARD1 = 1002;   ////////////////////////////////
                         // JOB: Patrols. Will occasionally interrogate
                         //  people on the street.
                         //
                         ////////////////////////////////
const int JOB_PATRON = 1003;   ////////////////////////////////
                         // JOB: Wanders
                         // Will let self be drawn into conversations
                         // Will occasionally leave and return later with more gold
                         ////////////////////////////////
const int JOB_TAG_NOTIT = 1004;
const int JOB_TAG_IT = 1005;
const int JOB_FRIEND = 1006;

const int JOB_WANDER = 1007;
const int JOB_HUNTER = 1008; // Same job as WANDER but used to differentiate them

const int JOB_GUARD2 = 1009;   ////////////////////////////////
                         // JOB: Stationary Guard. Should do nothing but stand there
                         //
                         ////////////////////////////////


const int TASK_WORK_CLEANING = 1000;    // Objects may request cleaning
const int TASK_WORK_ANVIL = 1001;       // Objects may request anvil'ing
const int TASK_WORK_LAMPPOST = 1002;    // lampposts want to be turned on/off
const int TASK_LEISURE_READBOOK = 1003; // read a book if not busy
const int TASK_LEISURE_SIT = 1004;      // sit on the chair

// * Only returns true if the object is ready
// * to be given more actions or to be interrupted
int GetReady(object oTarget);
// Will go up to a valid bar patron (not associates).
void GoToRandomPersonAndInit(object oMe, string sLocalIntName="", int nLocalIntCannotEqualThisNumber=10);
int IsAtJob(object oNPC = OBJECT_SELF);
// Can a player be seen?
int PlayerSeen(object oMe = OBJECT_SELF);
//* Returns true if the ambient is currently working on a task assigned by
// * (a) Placeable Objects
int GetAmbientBusy(object oSelf = OBJECT_SELF);
// * sets ambient on
void SetAmbientBusy(int bTrue, object oSelf = OBJECT_SELF);
// * Transit is set when the character is walking between areas
// * like the barmaid going home during the day
int GetInTransition(object oSelf = OBJECT_SELF);
// * Transit is set when the character is walking between areas
// * like the barmaid going home during the day
void SetInTransition(int bTrue, object oSelf = OBJECT_SELF);



// * Plays a random animation
void PlayRandomImmobileAnimation();
// * bar patron job task
void JobBarPatron(object oSelf);
// * CALLED FROM : Spawn In Script
// * PURPOSE: Defines why this NPC exists
void SetJob(int nJob, object oObject = OBJECT_SELF, int nTownTalker = FALSE, string sResRef="");
int GetJob(object oObject = OBJECT_SELF);

// * IMPORTANT: Main performing a job function for creatures
void DoJob(object oSelf = OBJECT_SELF);

void IncrementLeisure(int nValue,object oTarget = OBJECT_SELF);
void DecrementLeisure(int nValue,object oTarget = OBJECT_SELF);
int GetLeisure(object oTarget = OBJECT_SELF)                  ;
// * Creates a rat (called by Rat 'see baddy' and Garbage scripts)
void CreateRat();

// ******************HUB FUNCTIONS******************************
// * makes oNPC face oToFace
void Face(object oNPC, object oToFace);
// * TownHub: Makes patron leave randomly, or if another hub asks for him
void AskPatronToLeave(object oFirst);
// * Creatures true if this is an acceptable creature for use in the conversation hub
int CreatureValidForHubUse(object oCreature);
// * returns true if there is no player in the area
// * has to be ran from an object
int NoPlayerInArea();


/////////////////OBJECT FUNCTIONS///////////////////////////////

// * Asks the appropriate creature to perform a LEISURE or WORK task
// * The object MUST be the nearest object to be able to comply with the request
void Request(int nTask, float fActivationThreshold, float fMoveThisClose, object oSelf = OBJECT_SELF);



/////////////////IMPLEMENTATION////////////////////////////////




// * CALLED FROM : Spawn In Script
// * PURPOSE: Defines why this NPC exists
// * nResRef = This is used for certain things (like hunters) that need
// *  to spawnthings
void SetJob(int nJob, object oObject = OBJECT_SELF, int nTownTalker = FALSE, string sResRef="")
{

    SetLocalInt(oObject,"X2_G_JOB", nJob);
    if (nJob == JOB_BARMAID) SetupInn1DrinkPrices();

    // * Town Talkers like to conglomerate near town hubs
    if (nTownTalker == TRUE)
    {
        SetListening(oObject, TRUE);
        SetListenPattern(oObject, "ComeHither", LISTEN_MOVETOTOWNHUB);
    }

    if (sResRef != "")
    {
        int i = 1;
        for (i=1; i<= Random(3) + 2; i++)
        {
            object oCritter = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));
            SetLocalInt(oCritter, "X2_G_NEVERIT", TRUE);
            SetJob(JOB_TAG_NOTIT, oCritter);
        }
    }

    //* set up tag shouts
    if (nJob == JOB_TAG_NOTIT || nJob == JOB_TAG_IT)
    {
        SetListening(oObject, TRUE);
        SetListenPattern(oObject, "IAMIT", LISTEN_SOMEONEISIT);
        SetListenPattern(oObject, "IAMnotIT", LISTEN_IAMNOTIT);
        if (nJob == JOB_TAG_NOTIT)
        {
            // * do nothing
            // * the it child will cause me to run in
            // * my user defined event
            event eShout = EventUserDefined(EVENT_NOTIT_SHOUTS);
            DelayCommand(6.0, SignalEvent(oObject, eShout));
        }
        else
        {
            event eShout = EventUserDefined(EVENT_IT_SHOUTS);
            DelayCommand(6.0,SignalEvent(oObject, eShout));
        }


    }

    if (nJob == JOB_HUNTER)
    {
      SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_IAMTHEHUNTER));
    }

    if (nJob == JOB_WANDER)
    {
        SetListening(oObject, TRUE);
        SetListenPattern(oObject, "HUNTER", LISTEN_IHUNTYOU);
    }
    if (nJob == JOB_PATRON)
    {
         return; // * bar patrons are not really at 'work'
    }

    // * This local is used by IsAtJob
    // * If 'yourtag' is set to 10 on the
    // * the area it means that this area is
    // * your 'at work' area
    SetLocalInt(GetArea(oObject), GetTag(oObject), 10);

    // * Sets the 'zone', if there is one. This is the trigger
    // * that the NPC is spawned into
    object oTrigger = GetNearestObject(OBJECT_TYPE_TRIGGER);
    object oInTrigger = GetFirstInPersistentObject(oTrigger);
    int bInTrigger = FALSE;
    while (GetIsObjectValid(oInTrigger) == TRUE)
    {
        if (oInTrigger == OBJECT_SELF)
            bInTrigger = TRUE;
        oInTrigger = GetNextInPersistentObject(oTrigger);
    }
    if (bInTrigger == TRUE)
    {
        SetLocalObject(OBJECT_SELF, "NW_L_MYZONE", oTrigger);
    }
}
// * CALLED FROM:
// * PURPOSE: Returns the Job that this NPC should perform
int GetJob(object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "X2_G_JOB");
}

void DoJob(object oSelf = OBJECT_SELF)
{


    int nAction = GetCurrentAction(oSelf);
    if (
       //(PlayerSeen(oSelf) == FALSE) || REMOVING THIS UNTIL WE GET LEVEL OF AI
       (GetReady(oSelf) == FALSE)
       )
    {
        return;
    }
    if (IsAtJob(oSelf) == FALSE)
    {
        // * Leisure Jobs
        if (GetJob(oSelf) == JOB_PATRON)
        {
         JobBarPatron(oSelf);
         return;
        }
        return; // * If no leisure job then exit right out of here
    }


    switch (GetJob())
    {
        // * Barmaid Behavior
        case 1000: GoToRandomPersonAndInit(oSelf,"NW_L_NODRINKSFORME",10); break;
        // * Blacksmith
        case 1001: PlayRandomImmobileAnimation();  break;
        // * Patrol guard who talks to people
        case 1002: GoToRandomPersonAndInit(oSelf,"X2_L_GIVEMEABREAK",10); break;
        // * Not it
        case 1004:
        {
            // * userdefined events...
            break;
        }
        // * It
        case 1005:
        {
            // * user defined events
            break;
        }
        // * Faithful companion: bonds to a nearby creature and will follow them
        case 1006:
        {
            object oFriend = GetLocalObject(OBJECT_SELF, "X2_L_FRIEND");
            if (GetIsObjectValid(oFriend) == FALSE)
            {
                object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
                if (GetIsObjectValid(oCreature) == TRUE)
                {
                    SetLocalObject(OBJECT_SELF, "X2_L_FRIEND", oCreature);
                }
            }
            else
            // * friend is valid, follow it
            {
                if (GetCurrentAction(OBJECT_SELF) != ACTION_FOLLOW)
                {
                    ClearAllActions();
                    ActionForceFollowObject(oFriend, 1.5);
                }
            }
         break;
         }
         // * random walk (used by rat and wandering dog)
         case 1007: case 1008:
         {
            if (GetJob() == JOB_HUNTER)
            {

            }
            if (GetCurrentAction() != ACTION_MOVETOPOINT)
            {
                ClearAllActions();
                ActionRandomWalk();
            }
            break;
         }
         //Stationary guard
         case 1009:
         {
            break;
         }

    }


}
//::///////////////////////////////////////////////
//:: JobBarPatron
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Bar patron will wander if not
    near a 'CONVERSATION HUB'

    Will leave if run low on gold.

    Door he leaves by will recreate him in an arbitrary
    amount of time.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

// * Create creature creates sResref at lLoc and tells it go to lGoHere
// * nGold is the amount of new gold spawned on the creature
void CreateCritter(string sResRef, location lLoc, location lGoHere, int nGold)
{
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
    GiveGoldToCreature(oCreature, nGold + 4); // * always insure that enough gold for him to stay
    AssignCommand(oCreature, ActionMoveToLocation(lGoHere));

}
void JobBarPatron(object oSelf)
{

    object oMyConversationHub = GetLocalObject(oSelf, "X2_MYHUB");
    if (GetIsObjectValid(oMyConversationHub) == TRUE)
    {
        // * do nothing, the HUB is my master now
        return;
    }
    else
    {

       ClearAllActions();

        int ACT_WANDER = 0;
        int ACT_LEAVE = 1;

        int nAction = ACT_WANDER;

        if (GetGold(oSelf) <= 4)
        {
            nAction = ACT_LEAVE;
        }

        if (nAction == ACT_LEAVE)
        {
            object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
            if (GetIsObjectValid(oDoor) == TRUE)
            {
                // * sets the creature as busy so they are not interrupted on their way out
                SetLocalInt(oSelf, "X2_G_IAMBUSY",10);
                location lMyLoc = GetLocation(oSelf);
                ActionMoveToObject(oDoor);
                string sResRef = GetResRef(oSelf);
                location lLoc = GetLocation(oDoor);
                object oInvisiblePlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc);
                AssignCommand(oInvisiblePlaceable, ActionDoCommand(DelayCommand(FPATRONDELAY, ActionDoCommand(CreateCritter(sResRef, lLoc, lMyLoc, Random(10) + 1)))));
                AssignCommand(oInvisiblePlaceable, DestroyObject(oInvisiblePlaceable, FPATRONDELAY + 1.0));
                ActionDoCommand(DestroyObject(oSelf));

            }
            else
                nAction = ACT_WANDER; // * wander if no place to leave by

        }


        if (nAction == ACT_WANDER)
        {
            object oBar = GetNearestObjectByTag("TOWN_BAR");
            if (GetIsObjectValid(oBar) == TRUE)
            {
                if (GetDistanceToObject(oBar) > 12.0)
                {
                    ActionMoveToObject(oBar);
                    return;
                }
            }
            if (Random(100) > 25)
            {
                PlayRandomImmobileAnimation();
            }
            else
            {
               // ActionRandomWalk();
            }
        }
    }

}
// * Plays a random animation
void PlayRandomImmobileAnimation()
{
    ClearAllActions();
    int nAnimationType, nAnimation;
    float fSpeed = 0.75;
    nAnimationType = Random (8) + 1;
    switch (nAnimationType)
    {
        case 1: nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_LEFT; break;
        case 2: nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_RIGHT; break;
        // * combo, head to the Left, then Head to the Right
        case 3: nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_LEFT;
                ActionPlayAnimation(nAnimation, 0.75);
                nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_RIGHT;
                break;
        case 4: nAnimation = ANIMATION_FIREFORGET_SALUTE; break;
        case 5: nAnimation = ANIMATION_FIREFORGET_PAUSE_BORED; break;
        case 6: nAnimation = ANIMATION_LOOPING_LISTEN; break;
        case 7: nAnimation = ANIMATION_LOOPING_PAUSE_TIRED; break;
        case 8: nAnimation = ANIMATION_LOOPING_PAUSE_DRUNK; break;
    }
     ActionPlayAnimation(nAnimation, fSpeed);
}
// * called from objects when NPC's leisure is too high to want to use object
void HeadTurn(object oTarget)
{
    int nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_LEFT;
    AssignCommand(oTarget, ActionPlayAnimation(nAnimation, 0.75));

    nAnimation = ANIMATION_FIREFORGET_HEAD_TURN_RIGHT;
    AssignCommand(oTarget, ActionPlayAnimation(nAnimation, 0.75));
}

//////////////BARMAID FUNCTIONS/////////////////////////////////////

// * sets up the drink prices for this Inn
void SetupInn1DrinkPrices()
{
    SetCustomToken(104, IntToString(PLOT_COST_ALE));
    SetCustomToken(105, IntToString(PLOT_COST_SPIRITS));
    SetCustomToken(106, IntToString(PLOT_COST_WINE));
}


//::///////////////////////////////////////////////
//:: Make Drunk
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
loses a few points of int.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void BarmaidMakeDrunk(object oTarget, int nPoints)
{
    effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nPoints);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0);
}
//::///////////////////////////////////////////////
//:: MakeDrink
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
NPC will drink from a bottle or player will
be given the specified template.
Can only be ran from conversation
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void BarmaidMakeDrink(string sDrink, int nAmount)
{
   object oTalker = GetPCSpeaker();
   if (GetIsObjectValid(oTalker) == FALSE)
    {
        // * Try to find the last person I spoke to
        oTalker = GetLocalObject(OBJECT_SELF, "X2_L_LASTPERSONISPOKETO");
        if (GetIsObjectValid(oTalker) == FALSE)
        {
            GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
        }
        // * Fake 'drinking'
        AssignCommand(oTalker, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0, 4.0));
        AssignCommand(oTalker, BarmaidMakeDrunk(oTalker, d6(1)));
    }
    else
    // * if a PC give the PC a bottle of ale
    {
        CreateItemOnObject(sDrink, GetPCSpeaker());
    }
    TakeGoldFromCreature(nAmount, oTalker, TRUE) ;

        // * if a variable has been passed into this
    // * function (i.e., in the barmaid case)
    // * then set this variable for a short period of time
    // * so that the person doesn't harass the same NPC over and over.
    SetLocalInt(oTalker, "NW_L_NODRINKSFORM", 10);
    DelayCommand(fDelayBetweenBarmaidAskingForDrinks, ActionDoCommand(SetLocalInt(oTalker, "NW_L_NODRINKSFORME", 0)));


}

/////////////////ENDBARMAID//////////////////////////////////////


//////////////OBJECT FUNCTIONS/////////////////////////////////////

//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// * Asks the appropriate creature to perform a LEISURE or WORK task
// * The object MUST be the nearest object to be able to comply with the request

    ACTIVATION:
        1. Only if the NPC is of the appropriate job, close enough, not involved in conversation
           and not currently busy performing another task


    November 6 2002:
    Animal racial t ype are not allowed to perform any tasks.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void Request(int nTask, float fActivationThreshold, float fMoveThisClose, object oSelf = OBJECT_SELF)
{
    if (NoPlayerInArea() == TRUE) return; // * don't run this if no one is around


    object oClosest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
    //debug("Request work from " + GetName(oClosest) + FloatToString(GetDistanceToObject(oClosest)));
    // * Nov1: Added a check to prevent objects from bothering busy characters
    if (GetIsObjectValid(oClosest) == TRUE)
    if (GetAmbientBusy(oClosest) == FALSE)
    if (GetDistanceToObject(oClosest) <= fActivationThreshold)
    if (GetReady(oClosest) == TRUE)
    if (GetRacialType(oClosest) != RACIAL_TYPE_ANIMAL)
    {
        // * Used by TABLE object
        if ((nTask == TASK_WORK_CLEANING) && (GetJob(oClosest) == JOB_BARMAID))
        {
            AssignCommand(oClosest, ClearAllActions());
            AssignCommand(oClosest, ActionMoveToObject(oSelf, FALSE, fMoveThisClose));
            AssignCommand(oClosest, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, fActivationThreshold, 3.5));
            AssignCommand(oClosest, ActionMoveAwayFromObject(oSelf, FALSE, fActivationThreshold + 0.5));
        }
        else
        // * Used by ANVIL object
        if ((nTask == TASK_WORK_ANVIL) && (GetJob(oClosest) == JOB_BLACKSMITH))
        {

            AssignCommand(oClosest, ClearAllActions());
            //AssignCommand(oClosest, ActionMoveToObject(oSelf, FALSE, fMoveThisClose));
            AssignCommand(oClosest, ActionAttack(oSelf));
            DelayCommand(6.0, AssignCommand(oClosest, ClearAllActions()));
            DelayCommand(6.1, AssignCommand(oClosest, SurrenderToEnemies()));
        }
        else
        // * Used by LampPost object
        if ((nTask == TASK_WORK_LAMPPOST) && (GetIsPC(oClosest) == FALSE)  &&  (GetJob(oClosest) != JOB_TAG_IT) && (GetJob(oClosest) != JOB_TAG_NOTIT))
        {
            //debug("!!Lamp Target", oClosest);
            AssignCommand(oClosest, ClearAllActions());
            //AssignCommand(oClosest, ActionMoveToObject(oSelf, FALSE, fMoveThisClose));
            AssignCommand(oClosest, ActionInteractObject(oSelf));
            AssignCommand(oClosest, ActionDoCommand(ExecuteScript("nw_d2_walkways", oClosest)));

        }
        else
        // * Used by bookshelf
        if ((nTask == TASK_LEISURE_READBOOK) && (GetIsPC(oClosest) == FALSE) && (IsAtJob(oClosest) == FALSE))
        {
            if (GetLeisure(oClosest) < LEISURE_THRESHHOLD)
            {
                AssignCommand(oClosest, ClearAllActions());
                AssignCommand(oClosest, ActionMoveToObject(oSelf, FALSE, fMoveThisClose));
                if (GetAbilityScore(oClosest, ABILITY_INTELLIGENCE) >= 9)
                {
                    AssignCommand(oClosest, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
                }
                else
                // * just scratch head
                {
                   AssignCommand(oClosest, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD));
                   AssignCommand(oClosest, ActionMoveAwayFromObject(OBJECT_SELF));
                }
                AssignCommand(oClosest, ActionDoCommand(ExecuteScript("nw_d2_walkways", oClosest)));
                IncrementLeisure(Random(50), oClosest);
            }
            else
            {
                DecrementLeisure(10, oClosest);
                HeadTurn(oClosest);
                object oSelf = OBJECT_SELF;
                AssignCommand(oClosest, ActionMoveAwayFromObject(oSelf, FALSE, 10.0));

            }
        }
        else
        // * Used by Sitting object
        if ((nTask == TASK_LEISURE_SIT) && (IsAtJob(oClosest) == FALSE))
        {
           if (GetLeisure(oClosest) < LEISURE_THRESHHOLD)
            {
                AssignCommand(oClosest, ClearAllActions());
                AssignCommand(oClosest, ActionInteractObject(oSelf));
                DecrementLeisure(25, oClosest); // * decrement leisure by a large
                                                // * number when you first sit down,
                                                // * since it will grow each heartbeat
           }
          else
          {
            DecrementLeisure(10, oClosest);
            HeadTurn(oClosest);
          }
        }


       SetLocalInt(oClosest, "X2_G_IAMBUSY", 10);
       // * marks self as busy
       DelayCommand(6.0, SetLocalInt(oClosest, "X2_G_IAMBUSY", 0));


    }
}

// ************LEISURE FUNCTIONS*********************
/* Certain objects increase a character's Leisure
rating. Once this rating gets above the LEISURE_THRESHHOLD
they do not want to do leisure things anymore
*/
void IncrementLeisure(int nValue,object oTarget = OBJECT_SELF)
{
    int nCurrentLeisure = GetLocalInt(oTarget, "X2_L_MYLEISURE");
    SetLocalInt(oTarget,"X2_L_MYLEISURE", nCurrentLeisure + nValue);
}
void DecrementLeisure(int nValue,object oTarget = OBJECT_SELF)
{
    int nCurrentLeisure = GetLocalInt(oTarget, "X2_L_MYLEISURE");
    SetLocalInt(oTarget,"X2_L_MYLEISURE", nCurrentLeisure - nValue);
}
int GetLeisure(object oTarget = OBJECT_SELF)
{

    int nLeisure = GetLocalInt(oTarget, "X2_L_MYLEISURE");
    return nLeisure;
}

/////////////////ENDOBJECTFUNCTIONS//////////////////////////////////////





//::///////////////////////////////////////////////
//:: PlayerSeen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if a player can be seen
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int PlayerSeen(object oMe = OBJECT_SELF)
{
    // * Exit userdefined script if cannot see a player
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oMe, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    if (GetIsObjectValid(oPC) == FALSE)
    {
        return FALSE;
    }
    return TRUE;

}

//::///////////////////////////////////////////////
//:: IsAtJob
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the NPC is in their 'at work'
    area.

    This is a variable set on the Area with the Tag of the NPC.
    If the tag is 10, it means the NPC is at work.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int IsAtJob(object oNPC = OBJECT_SELF)
{
    if (GetLocalInt(GetArea(oNPC), GetTag(oNPC)) == 10)
    {
        return TRUE;
    }
    return FALSE;
}


///////////////////////////////////////////////////
//:: Utility Functions
///////////////////////////////////////////////////


//* Returns true if the ambient is currently working on a task assigned by
// * (a) Placeable Objects
int GetAmbientBusy(object oSelf = OBJECT_SELF)
{
    if (GetLocalInt(oSelf, "X2_G_IAMBUSY") == 10)
    {
        //debug(GetName(OBJECT_SELF) + " says that AMBIENT BUSY is 10 for " + GetName(oSelf));
        return TRUE;
    }
    //debug(GetName(oSelf) + "NOT AMBIENT BUSY");
    return FALSE;
}
// * sets ambient on
void SetAmbientBusy(int bTrue, object oSelf = OBJECT_SELF)
{
    if (bTrue == TRUE)
        SetLocalInt(oSelf, "X2_G_IAMBUSY", 10);
    else
        SetLocalInt(oSelf, "X2_G_IAMBUSY", 0);
}

// * Transit is set when the character is walking between areas
// * like the barmaid going home during the day
int GetInTransition(object oSelf = OBJECT_SELF)
{
    if (GetLocalInt(oSelf, "X2_G_TRAN") == 10)
    {
        //debug(GetName(OBJECT_SELF) + " says that TRANSIT BUSY is 10 for " + GetName(oSelf));
        return TRUE;
    }
    //debug(GetName(oSelf) + "NOT TRANSIT BUSY");
    return FALSE;
}
// * Transit is set when the character is walking between areas
// * like the barmaid going home during the day
void SetInTransition(int bTrue, object oSelf = OBJECT_SELF)
{
    if (bTrue == TRUE)
        SetLocalInt(oSelf, "X2_G_TRAN", 10);
    else
        SetLocalInt(oSelf, "X2_G_TRAN", 0);
}

// * Only returns true if the object is ready
// * to be given more actions or to be interrupted
//*    "X2_G_LEAVEMEALONE": Set this value on characters that don't want to
//*       be bugged by tasks or jobs
int GetReady(object oTarget)
{
    int nIsInConv = IsInConversation(oTarget);

    if (
       (GetAmbientBusy(oTarget) == FALSE) &&
       (nIsInConv == FALSE) &&
       (GetIsInCombat(oTarget) == FALSE)
       && (GetCurrentAction(oTarget) != ACTION_DIALOGOBJECT)
       && (GetLocalInt(oTarget, "X2_G_LEAVEMEALONE") == 0)
       && (GetInTransition(oTarget) == FALSE)
       )
    {
        //debug("get ready returning true for " + GetName(oTarget));
        return TRUE;
    }
    //debug("get ready returning false for " + GetName(oTarget));
    return FALSE;
}



//::///////////////////////////////////////////////
//:: GoToRandomPersonAndInit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Will go up to a valid bar patron (not associates).
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// Will go up to a valid bar patron (not associates).
void GoToRandomPersonAndInit(object oMe, string sLocalIntName="", int nLocalIntCannotEqualThisNumber=10)
{
    //debug("In random person init");
    int nCount = 0; // * Number of people near barmaid
    object oNearest = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oMe, nCount + 1);

    // * Count number of people
    while (GetIsObjectValid(oNearest) == TRUE)
    {
        nCount++;
        oNearest = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oMe, nCount + 1);
    }
    int nPerson = Random(nCount) + 1; // Go to this person
    oNearest = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, nPerson);

    // * only go up to creatures that are not busy, not in combat, not talking,
    // * and have never refused a drink
    // * anyone with a master cannot buy drinks

    if (GetJob(oNearest) != JOB_TAG_IT && GetJob(oNearest) != JOB_GUARD2 && GetJob(oNearest) != JOB_TAG_NOTIT
    && (GetIsObjectValid(GetMaster(oNearest)) == FALSE) &&
    (GetLocalInt(oNearest, sLocalIntName)!= nLocalIntCannotEqualThisNumber) &&
    (GetReady(oNearest) == TRUE)
    && GetRacialType(oNearest) != RACIAL_TYPE_ANIMAL
      )
    {

      // SpawnScriptDebugger();

        // * temporary make it so the person won't try initing to this
        // * particular target again, for a while
        SetLocalInt(oNearest, sLocalIntName, nLocalIntCannotEqualThisNumber);
        DelayCommand(100.0, SetLocalInt(oNearest, sLocalIntName, 0));
        ClearAllActions();
        ActionMoveToObject(oNearest);
        // * Store the person I last spoke with (will use it for barmaid when
        // * they go to take  drink)
        SetLocalObject(OBJECT_SELF, "X2_L_LASTPERSONISPOKETO", oNearest);
        ActionStartConversation(oNearest);
    }
 // * Took this out because it broke walk way points
 //   else
 //       PlayRandomImmobileAnimation();
}

// * Creates a rat (called by Rat 'see baddy' and Garbage scripts)
void CreateRat()
{
    object oRat = CreateObject(OBJECT_TYPE_CREATURE, "townrat", GetLocation(OBJECT_SELF));
    SetLocalInt(OBJECT_SELF, "X2_L_RATSMADE", GetLocalInt(OBJECT_SELF, "X2_L_RATSMADE") + 1);
    // * the rat stores the filth that created it
    SetLocalObject(oRat, "X2_L_HOUSE", OBJECT_SELF);
    object oSelf = OBJECT_SELF;
    AssignCommand(oRat, ActionMoveAwayFromObject(oSelf));
}
// * makes oNPC face oToFace
void Face(object oNPC, object oToFace)
{
    AssignCommand(oNPC, SetFacingPoint(GetPositionFromLocation(GetLocation(oToFace))));
}
// * TownHub: Makes patron leave randomly, or if another hub asks for him
void AskPatronToLeave(object oFirst)
{
    // * Random chance that the closest person just walks away
    // * trying moving the fellow to the next nearest conversation hub
    object oNewPlace =  GetNearestObjectByTag(GetTag(OBJECT_SELF));
    if (GetIsObjectValid(oNewPlace) == TRUE)
    {
        SetLocalObject(oFirst, "X2_MYHUB", oNewPlace);
        AssignCommand(oFirst, ActionMoveToObject(oNewPlace));
        object oPersonAtOther =  GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oNewPlace);
        if (GetIsObjectValid(oPersonAtOther) == TRUE)
        {
            // * make them face each other
            Face(oFirst, oPersonAtOther);
        }
    }
    else
    {
    }
}
// * Creatures true if this is an acceptable creature for use in the conversation hub
int CreatureValidForHubUse(object oCreature)
{
 return  (GetIsObjectValid(oCreature) == TRUE && GetDistanceToObject(oCreature) < DISTANCE_TALKHUB
        && GetLocalObject(oCreature, "X2_MYHUB") == OBJECT_SELF
        && GetReady(oCreature) == TRUE && GetCurrentAction(oCreature) != ACTION_SIT );
}
// * returns true if there is no player in the area
// * has to be ran from an object
int NoPlayerInArea()
{
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    if (GetIsObjectValid(oPC) == TRUE)
        return FALSE;
    return TRUE; // * no player in area
}
