//::///////////////////////////////////////////////////////
// X2_EVT_TRIGGER
/*
  This is the OnEntered script for the henchman trigger objects.
  It signals the event router that a given event has occured,
  by obtaining the key tag from the trigger and using that as
  the event number.

  Each trigger will only be activated once, and can only be
  activated by a PC.

  AUGUST 2003
  1. Code split. New script for new XP2 functionality
  

  MODIFIED BY BRENT, APRIL 2003
  1. Henchmen now trigger the trigger, not players
  2. Henchmen will only attempt to do the popup or intjereciton
      if the player and the henchmen meet he following requirements
        (a) Neither in combat
        (b) Neither in Conversation
        (c) Within 10 meters of each other
*/
//::///////////////////////////////////////////////////////
// May 26 2003: Make player trigger the interjection.
//    If henchmen is able to move, move them to player and
//    start interjection.
//    Destroy trigger regardless.

#include "x0_i0_common"
#include "x2_inc_banter"


void main()
{
    object oTrigger = GetEnteringObject();
    string sTag = GetTag(OBJECT_SELF); // What kind of trigger am I?
    AttemptInterjectionOrPopup(OBJECT_SELF, sTag, oTrigger);
    
}


