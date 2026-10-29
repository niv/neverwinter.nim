//:://////////////////////////////////////////////////
//:: X0_I0_BEHAVIOR
/*
  Library holding code for creature behaviors.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Special behavior
const int NW_FLAG_BEHAVIOR_SPECIAL       = 0x00000001;

//Will always attack regardless of faction
const int NW_FLAG_BEHAVIOR_CARNIVORE     = 0x00000002;

//Will only attack if approached
const int NW_FLAG_BEHAVIOR_OMNIVORE      = 0x00000004;

//Will never attack.  Will alway flee.
const int NW_FLAG_BEHAVIOR_HERBIVORE     = 0x00000008;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Add the specified condition flag to the behavior state of the caller
void SetBehaviorState(int nCondition, int bValid = TRUE);

// Returns TRUE if the specified behavior flag is set on the caller
int GetBehaviorState(int nCondition);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Add the specified condition flag to the behavior state of the caller
void SetBehaviorState(int nCondition, int bValid = TRUE)
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_BEHAVIOR_MASTER");
    if(bValid == TRUE)
    {
        nPlot = nPlot | nCondition;
        SetLocalInt(OBJECT_SELF, "NW_BEHAVIOR_MASTER", nPlot);
    }
    else if (bValid == FALSE)
    {
        nPlot = nPlot & ~nCondition;
        SetLocalInt(OBJECT_SELF, "NW_BEHAVIOR_MASTER", nPlot);
    }
}

// Returns TRUE if the specified behavior flag is set on the caller
int GetBehaviorState(int nCondition)
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_BEHAVIOR_MASTER");
    if(nPlot & nCondition)
    {
        return TRUE;
    }
    return FALSE;
}


/* DO NOT CLOSE THIS TOP COMMENT!
   This main() function is here only for compilation testing.
void main() {}
/* */
