//::///////////////////////////////////////////////
//:: XP3 Portable Encampment Script
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in general purpose treasure and gold
    usable by all classes.

*/
//:://////////////////////////////////////////////
//:: Created By:   Peter Thomas
//:: Adapted for core game by: Craig Welburn
//:: Created On:   2008-01-07
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if ( nEvent == X2_ITEM_EVENT_ACTIVATE )
    {
        // get the player
        object oPC = GetItemActivator();
        //WriteTimestampedLogEntry("Player for portable camp is " + GetName(oPC));

        // check to see if player is in combat
        if (GetIsInCombat(oPC) == FALSE)
        {
            //WriteTimestampedLogEntry("Player is not in combat.");

            // check to see if a monster can be seen within 10.0
            int nCount = 1;
            int bHostile = FALSE;
            object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nCount);
            string sTag = GetTag(oCreature);
            float fDistance = GetDistanceBetween(oPC, oCreature);
            int bLOS;

            if (oCreature != OBJECT_INVALID)
            {
                //WriteTimestampedLogEntry("Examining creature " + sTag + " at distance " + FloatToString(fDistance));
            }

            if ((oCreature != OBJECT_INVALID) && (GetIsEnemy(oPC, oCreature) == TRUE) && (fDistance <= 10.0))
            {
                //WriteTimestampedLogEntry(GetName(oCreature) + " : Creature is hostile. LOS still needs to be checked.");
                bLOS = LineOfSightObject(oPC, oCreature);
                if (bLOS == TRUE)
                {
                    //WriteTimestampedLogEntry("    Creature has line of sight.");
                    bHostile = TRUE;
                }
            }
            if (bHostile == FALSE)
            {
                nCount++;
            }
            while ((bHostile == FALSE) && (oCreature != OBJECT_INVALID) && (fabs(fDistance) <= 10.0))
            {
                oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nCount);
                sTag = GetTag(oCreature);
                fDistance = GetDistanceBetween(oPC, oCreature);
                //WriteTimestampedLogEntry("Examining creature " + sTag + " at distance " + FloatToString(fDistance));
                if ((GetIsEnemy(oPC, oCreature) == TRUE) && (fDistance <= 10.0))
                {
                    //WriteTimestampedLogEntry("  Creature is hostile.");
                    bLOS = LineOfSightObject(oPC, oCreature);
                    if (bLOS == TRUE)
                    {
                        //WriteTimestampedLogEntry("    Creature has line of sight.");
                        bHostile = TRUE;
                    }
                }
                if (bHostile == FALSE)
                {
                    nCount++;
                }
            }

            if (bHostile == FALSE)
            {
                //WriteTimestampedLogEntry("Letting player rest.");

                // let player rest
                SetLocalInt(oPC, "bCanRest", TRUE);
                DelayCommand(0.5, SetLocalInt(oPC, "bCanRest", FALSE));
                //WriteTimestampedLogEntry("Clearing actions.");
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, ActionRest(TRUE));

                // rest henchmen
                int nCount = 1;
                object oHenchman = GetHenchman(oPC, nCount);
                while (oHenchman != OBJECT_INVALID)
                {
                    SetLocalInt(oHenchman, "bCanRest", TRUE);
                    DelayCommand(0.5, SetLocalInt(oHenchman, "bCanRest", FALSE));
                    //WriteTimestampedLogEntry("Clearing actions.");
                    AssignCommand(oHenchman, ClearAllActions());
                    AssignCommand(oHenchman, ActionRest(TRUE));

                    nCount++;
                    oHenchman = GetHenchman(oPC, nCount);
                }

                // destroy camp object
                DestroyObject(OBJECT_SELF);
            }
            else
            {
                //WriteTimestampedLogEntry("Not letting player rest.");

                AssignCommand(oPC, SpeakString(GetStringByStrRef(66234), TALKVOLUME_WHISPER));
            }
        }
        else
        {
            //WriteTimestampedLogEntry("Player is in combat.");

            AssignCommand(oPC, SpeakString(GetStringByStrRef(111957), TALKVOLUME_WHISPER));
        }
    }
}
