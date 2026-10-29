//:://////////////////////////////////////////////////
//:: X0_C2_SPWN_DEF
/*
 * Default OnSpawn handler with XP1 revisions. 
 * This corresponds to and produces the same results
 * as the default OnSpawn handler in the OC.
 *
 * This can be used to customize creature behavior in three main ways:
 *
 * - Uncomment the existing lines of code to activate certain
 *   common desired behaviors from the moment when the creature 
 *   spawns in.
 *
 * - Uncomment the user-defined event signals to cause the 
 *   creature to fire events that you can then handle with
 *   a custom OnUserDefined event handler script. 
 *
 * - Add new code _at the end_ to alter the initial 
 *   behavior in a more customized way. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/11/2002
//:://////////////////////////////////////////////////

#include "x0_i0_walkway"
#include "x0_i0_treasure"

void main()
{
    // ***** Spawn-In Conditions ***** //
 
    // * REMOVE COMMENTS (// ) before the "Set..." functions to activate
    // * them. Do NOT touch lines commented out with // *, those are
    // * real comments for information. 

    // * This causes the creature to say a one-line greeting in their
    // * conversation file upon perceiving the player. Put [NW_D2_GenCheck] 
    // * in the "Text Seen When" field of the greeting in the conversation 
    // * file. Don't attach any player responses.
    // *
    // SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);

    // * Same as above, but for hostile creatures to make them say
    // * a line before attacking. 
    // *
    // SetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION);

    // * This NPC will attack when its allies call for help
    // *
    // SetSpawnInCondition(NW_FLAG_SHOUT_ATTACK_MY_TARGET);

    // * If the NPC has the Hide skill they will go into stealth mode
    // * while doing WalkWayPoints(). 
    // *
    // SetSpawnInCondition(NW_FLAG_STEALTH);

    // * Same, but for Search mode
    // *
    // SetSpawnInCondition(NW_FLAG_SEARCH);

    // * This will set the NPC to give a warning to non-enemies 
    // * before attacking.
    // * NN -- no clue what this really does yet
    // *
    // SetSpawnInCondition(NW_FLAG_SET_WARNINGS);

    // * Separate the NPC's waypoints into day & night. 
    // * See comment on WalkWayPoints() for use. 
    // *
    // SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING);

    // * If this is set, the NPC will appear using the "EffectAppear"
    // * animation instead of fading in, *IF* SetListeningPatterns()
    // * is called below. 
    // *
    // SetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION);

    // * This will cause an NPC to use common animations it possesses,
    // * and use social ones to any other nearby friendly NPCs. 
    // *
    // SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);

    // * Same as above, except NPC will wander randomly around the
    // * area. 
    // *
    // SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);


    // **** Escape Commands ***** //
    // * NOTE: ONLY ONE OF THE FOLLOWING SHOULD EVER BE SET AT ONE TIME.
    // * NOTE2: Not clear that these actually work. -- NN

    // * Flee to a way point and return a short time later.
    // *
    // SetSpawnInCondition(NW_FLAG_ESCAPE_RETURN);    

    // * Flee to a way point and do not return.
    // *
    // SetSpawnInCondition(NW_FLAG_ESCAPE_LEAVE);     

    // * Teleport to safety and do not return.
    // *
    // SetSpawnInCondition(NW_FLAG_TELEPORT_LEAVE);  

    // * Teleport to safety and return a short time later.
    // *
    // SetSpawnInCondition(NW_FLAG_TELEPORT_RETURN);  



    // ***** CUSTOM USER DEFINED EVENTS ***** /


    /*
      If you uncomment any of these conditions, the creature will fire
      a specific user-defined event number on each event. That will then
      allow you to write custom code in the "OnUserDefinedEvent" handler
      script to go on top of the default NPC behaviors for that event. 
      
      Example: I want to add some custom behavior to my NPC when they
      are damaged. I uncomment the "NW_FLAG_DAMAGED_EVENT", then create
      a new user-defined script that has something like this in it:
      
      if (GetUserDefinedEventNumber() == 1006) {
          // Custom code for my NPC to execute when it's damaged
      }

      These user-defined events are in the range 1001-1007.
    */
    
    // * Fire User Defined Event 1001 in the OnHeartbeat
    // *
    // SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);        

    // * Fire User Defined Event 1002
    // *
    // SetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT);         

    // * Fire User Defined Event 1005
    // *
    // SetSpawnInCondition(NW_FLAG_ATTACK_EVENT);           

    // * Fire User Defined Event 1006
    // *
    // SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);          

    // * Fire User Defined Event 1008
    // *
    // SetSpawnInCondition(NW_FLAG_DISTURBED_EVENT);        

    // * Fire User Defined Event 1003
    // *
    // SetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT); 

    // * Fire User Defined Event 1004
    // *
    // SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);      



    // ***** DEFAULT GENERIC BEHAVIOR (DO NOT TOUCH) ***** //

    // * Goes through and sets up which shouts the NPC will listen to.
    // *
    SetListeningPatterns();    

    // * Walk among a set of waypoints. 
    // * 1. Find waypoints with the tag "WP_" + NPC TAG + "_##" and walk 
    // *    among them in order. 
    // * 2. If the tag of the Way Point is "POST_" + NPC TAG, stay there 
    // *    and return to it after combat. 
    //
    // * Optional Parameters: 
    // * void WalkWayPoints(int nRun = FALSE, float fPause = 1.0)
    //
    // * If "NW_FLAG_DAY_NIGHT_POSTING" is set above, you can also
    // * create waypoints with the tags "WN_" + NPC Tag + "_##" 
    // * and those will be walked at night. (The standard waypoints
    // * will be walked during the day.) 
    // * The night "posting" waypoint tag is simply "NIGHT_" + NPC tag.
    WalkWayPoints();           


    //* Create a small amount of treasure on the creature
    CTG_GenerateNPCTreasure(TREASURE_TYPE_MONSTER, OBJECT_SELF);


    // ***** ADD ANY SPECIAL ON-SPAWN CODE HERE ***** //

}
