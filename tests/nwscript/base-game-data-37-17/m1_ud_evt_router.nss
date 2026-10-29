
//:://////////////////////////////////////////////////
//:: M1_UD_EVT_ROUTER.NSS
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
This is the user-defined event handler for the event
router object for module 1.

The code here is generated from the Excel spreadsheet
events.xls and will be completely replaced when the
code is re-generated; do not hand-edit this except for
testing.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////


#include "x0_i0_henchman"

void main()
{
    int nEvent = GetUserDefinedEventNumber();
    switch (nEvent) {

    case 2200:
        // Approach Abandoned Mine
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2101));
        break;

    case 2201:
        // Approach Hall of Bones
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2104));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2121));
        break;

    case 2202:
        // Approach Kobold Caves
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2122));
        break;

    case 2203:
        // Approach puzzle in Nurwrath's tomb
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2111));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2111));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2111));
        break;

    case 2204:
        // Enter Barrow Downs
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2102));
        break;

    case 2205:
        // Enter Gnomish Fortress (J'Nah's lair)
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2103));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2101));
        break;

    case 2206:
        // Enter Razed Village of Blumberg
        break;

    case 2207:
        // Get dragon's tooth
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2109));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2123));
        break;

    case 2208:
        // Get mask
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2123));
        break;

    case 2209:
        // Get mummified hand
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2124));
        break;

    case 2210:
        // Go on artifact quest
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2107));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2112));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2111));
        break;

    case 2211:
        // Leaving dragon body
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2103));
        break;

    case 2212:
        // Leaving Hilltop
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2101));
        break;

    case 2213:
        // Met barrow druid
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2121));
        break;

    case 2214:
        // Met dragon
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2123));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2102));
        break;

    case 2215:
        // Met false harpers
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2121));
        break;

    case 2216:
        // Met Gretti (Uppsala's doorman)
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2112));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2113));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2112));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2112));
        break;

    case 2217:
        // Met J'Nah
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2113));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2102));
        break;

    case 2218:
        // Met Jorunn
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2115));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2104));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2122));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2103));
        break;

    case 2219:
        // Met kobold chieftain
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2122));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2104));
        break;

    case 2220:
        // Met Nurwrath
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2106));
        break;

    case 2221:
        // Met Rumgut
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2113));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2113));
        break;

    case 2222:
        // Met Uppsala
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2123));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2104));
        break;

    }

}

