//::///////////////////////////////////////////////
//:: townHub
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script does the following:
    a) Tries to get a cluster of people (MAX 4)
    near it (with each person facing towards the placeable)
    b) With the current # of people it has, it will
    attempt to act out sketches.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void debugit(string s)
{
  //  SpeakString(s);
}

// * performs a sketch, with o1 getting nAnimation1 and o2+ getting nAnimation2
void PerformSketch(object o1, object o2, int nAnimation1, int nAnimation2, float fAnimDuration=0.0, int nRandomAnimation= 0)
{       //debugit("perform sketch");


    AssignCommand(o1, ClearAllActions());
    AssignCommand(o2, ClearAllActions());
    // * oFirst = Greet
    AssignCommand(o1, ActionPlayAnimation(nAnimation1, 1.0, fAnimDuration));
    Face(o1, o2);
    // * oSecond, delay, Greet
    DelayCommand(fAnimDuration+ 0.4, AssignCommand(o2, ActionPlayAnimation(nAnimation2, 1.0, fAnimDuration)));
    Face(o2, o1);
    object oThird = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, 3);
    object oFourth = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, 4);
    if (nRandomAnimation > 0 && Random(100) > 50)
    {
      nAnimation2 = nRandomAnimation;
    }

    if (CreatureValidForHubUse(oThird) == TRUE)
    {
      DelayCommand(fAnimDuration+ 0.8, AssignCommand(oThird, ActionPlayAnimation(nAnimation2, 1.0, fAnimDuration)));
      Face(oThird, o1);
    }
    if (CreatureValidForHubUse(oFourth) == TRUE)
    {
      DelayCommand(fAnimDuration+ 1.2, AssignCommand(oFourth, ActionPlayAnimation(nAnimation2, 1.0, fAnimDuration)));
      Face(oFourth, o1);
      SetLocalInt(OBJECT_SELF,"X2_BROADCASTSTOP", TRUE); // * if there are four people, stop broadcasting
    }


}


void main()
{ //  SpawnScriptDebugger();
    //debugit("test");
    // ************IMPORTANT******************
    // * Broadcast only once and then continue broadcasting if no one
    // * is near me
    if (GetLocalInt(OBJECT_SELF,  "X2_BROADCASTREADY") == FALSE)
    {
        //debugit("broadcasting");
        SpeakString("ComeHither", TALKVOLUME_SILENT_SHOUT);

    }

    SetLocalInt(OBJECT_SELF,"X2_BROADCASTSTOP", FALSE); // * always turn broadcast back on. 4 peopel will turn it off
    // ***************************************     \

      //  SpeakString("running");

    // * Each round try to make my 'people' do a sketch
    // * do greeting sketch

    object oNewPlace = OBJECT_INVALID; // * used inside switch
    object oFirst = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
    if (CreatureValidForHubUse(oFirst) == TRUE)
    {

        object oSecond =  GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, 2);
        if (CreatureValidForHubUse(oSecond) == TRUE)
        {
           // SpeakString("second creature valid");

            int nSketch = Random(14) + 1;
            // SpeakString(IntToString(nSketch));
            switch (nSketch)
            {
                case 1:
                {
                //  AskPatronToLeave(oFirst); (Removed this except for by-request from another townhub)
                 break;
                }
                case 2: case 3:PerformSketch(oFirst, oSecond, ANIMATION_FIREFORGET_GREETING, ANIMATION_FIREFORGET_GREETING);break;
                case 4: case 5:
                {
                    PerformSketch(oFirst, oSecond, ANIMATION_LOOPING_TALK_FORCEFUL, ANIMATION_LOOPING_TALK_LAUGHING, 3.0);break;
                }
                case 6: case 7: PerformSketch(oFirst, oSecond, ANIMATION_LOOPING_TALK_FORCEFUL, ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 3.0, ANIMATION_LOOPING_TALK_LAUGHING);break;
                case 8: case 9: PerformSketch(oFirst, oSecond, ANIMATION_LOOPING_TALK_PLEADING, ANIMATION_LOOPING_TALK_NORMAL, 3.0);break;
                case 10: case 11: PerformSketch(oFirst, oSecond, ANIMATION_LOOPING_TALK_FORCEFUL, ANIMATION_LOOPING_TALK_FORCEFUL, 3.0);break;
                case 12: case 13:PerformSketch(oFirst, oSecond, ANIMATION_FIREFORGET_TAUNT, ANIMATION_LOOPING_TALK_PLEADING, 3.0);break;
                case 14: case 15: break; // * do nothing
            }
        }
        else
        // * for the loner just play immobile ambients
        {
            // * if down to one participant or lessthen start broadcasting again
            SetLocalInt(OBJECT_SELF,"X2_BROADCASTSTOP", FALSE);
            AssignCommand(oFirst, ClearAllActions());
            AssignCommand(oFirst, PlayRandomImmobileAnimation());
        }
    }
    else
    {
            // * if down to one participant or lessthen start broadcasting again
            SetLocalInt(OBJECT_SELF,"X2_BROADCASTSTOP", FALSE);
    }



    // * if only two participants, ask for another from another townhub
    if (CreatureValidForHubUse(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, 4)) == FALSE)
    {
        event eShareCrowd = EventUserDefined(EVENT_NEEDMOREPATRONS);
        object oNewPlace =  GetNearestObjectByTag(GetTag(OBJECT_SELF));
        if (GetIsObjectValid(oNewPlace) == TRUE)
        {
            //debugit("requesting patrons");
            SignalEvent(oNewPlace, eShareCrowd);
        }
    }

}
