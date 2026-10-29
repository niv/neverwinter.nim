//::///////////////////////////////////////////////
//:: User Defined For Rescue Plot
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "nw_j_rescue"

void main()
{
    switch(GetUserDefinedEventNumber())
    {
        case 1002:
         if (GetObjectSeen(GetPrisoner()))
         if (GetLocalInt(Global(),"NW_Resc_Plot") != 100)
         {
            // * sets global so that the Plot Giver
            // * knows that the rescue was completed
            SetLocalInt(Global(),"NW_Resc_Plot",100);
         }
        break;
    }
}
