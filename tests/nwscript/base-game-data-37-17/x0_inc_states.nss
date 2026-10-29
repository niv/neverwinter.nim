// x0_inc_states
//:://////////////////////////////////////////////////////////////////////////////////////////////
//:: Associate Include Functions
//:: NW_I0_ASSOCIATE
//:: Copyright (c) 2001 Bioware Corp.
//:://///////////////////////////////////////////////////////////////////////////////////////////
/*
    Determines and stores the behavior of the
    associates used by the PC

    nw_i0_generic links to x0_inc_generic which links to x0_inc_states
*/
//:://///////////////////////////////////////////////////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 16, 2001
//:://///////////////////////////////////////////////////////////////////////////////////////////

//Distance
const int NW_ASC_DISTANCE_2_METERS =   0x00000001;
const int NW_ASC_DISTANCE_4_METERS =   0x00000002;
const int NW_ASC_DISTANCE_6_METERS =   0x00000004;
//Heal when
const int NW_ASC_HEAL_AT_75 =          0x00000008;
const int NW_ASC_HEAL_AT_50 =          0x00000010;
const int NW_ASC_HEAL_AT_25 =          0x00000020;
//Auto AI
const int NW_ASC_AGGRESSIVE_BUFF =     0x00000040;
const int NW_ASC_AGGRESSIVE_SEARCH =   0x00000080;
const int NW_ASC_AGGRESSIVE_STEALTH =  0x00000100;
//Open Locks on master fail
const int NW_ASC_RETRY_OPEN_LOCKS =    0x00000200;
//Casting power
const int NW_ASC_OVERKIll_CASTING =    0x00000400; // GetMax Spell
const int NW_ASC_POWER_CASTING =       0x00000800; // Get Double CR or max 4 casting
const int NW_ASC_SCALED_CASTING =      0x00001000; // CR + 4;

const int NW_ASC_USE_CUSTOM_DIALOGUE = 0x00002000;
const int NW_ASC_DISARM_TRAPS =        0x00004000;
const int NW_ASC_USE_RANGED_WEAPON   = 0x00008000;
const int NW_ASC_MODE_DEFEND_MASTER =  0x04000000; //Guard Me Mode, Attack Nearest sets this to FALSE.
const int NW_ASC_MODE_STAND_GROUND =   0x08000000; //The Henchman will ignore move to object in the heartbeat
                                             //If this is set to FALSE then they are in follow mode
const int NW_ASC_MASTER_GONE =         0x10000000;
const int NW_ASC_MASTER_REVOKED =      0x20000000;
const int NW_ASC_IS_BUSY =             0x40000000; //Only busy if attempting to bash or pick a lock
const int NW_ASC_HAVE_MASTER =         0x80000000; //Not actually used, here for system continuity

void SetAssociateState(int nCondition, int bValid = TRUE)
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER");
    if(bValid == TRUE)
    {
        nPlot = nPlot | nCondition;
        SetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER", nPlot);
    }
    else if (bValid == FALSE)
    {
        nPlot = nPlot & ~nCondition;
        SetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER", nPlot);
    }
}

int GetAssociateState(int nCondition)
{
    if(nCondition == NW_ASC_HAVE_MASTER)
    {
        if(GetIsObjectValid(GetMaster()))
        {
            return TRUE;
        }
    }
    else
    {
        int nPlot = GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER");
        if(nPlot & nCondition)
        {
            return TRUE;
        }
    }
    return FALSE;
}
