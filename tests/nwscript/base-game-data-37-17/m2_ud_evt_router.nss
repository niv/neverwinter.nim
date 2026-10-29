
//:://////////////////////////////////////////////////
//:: M2_UD_EVT_ROUTER.NSS
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
This is the user-defined event handler for the event
router object for module 2.

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

    case 2300:
        // Approach Achemon
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2124));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2124));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2112));
        break;

    case 2301:
        // Approach False Harpers (at Caravansary)
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2125));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2105));
        break;

    case 2302:
        // Approach First Head
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2126));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2106));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2125));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2113));
        break;

    case 2303:
        // Approach Formians
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2105));
        break;

    case 2304:
        // Approach Third Head
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2123));
        break;

    case 2305:
        // Destroy/Stop Third Head
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2124));
        break;

    case 2306:
        // Enter Belpheron's Lair
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2127));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2125));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2126));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2102));
        break;

    case 2307:
        // Enter Belpheron's Sanctum
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2107));
        break;

    case 2308:
        // Enter Caravansary
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2104));
        break;

    case 2309:
        // Enter Desert Edge
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2126));
        break;

    case 2310:
        // Enter Fierlen
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2105));
        break;

    case 2311:
        // Enter Fierlen Eastern Waste (Formian location)
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2101));
        break;

    case 2312:
        // Enter Fierlen Formian Lair
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2105));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2114));
        break;

    case 2313:
        // Enter Fierlen Ruin Exterior
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2115));
        break;

    case 2314:
        // Enter Fierlen Ruin Interior
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2106));
        break;

    case 2315:
        // Enter Maatar
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2114));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2116));
        break;

    case 2316:
        // Enter Maatar Zhentarim Caves
        break;

    case 2317:
        // Enter Stinger Lair
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2107));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2106));
        break;

    case 2318:
        // Get Jug
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2129));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2114));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2125));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2114));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2127));
        break;

    case 2319:
        // Killed False Harpers
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2126));
        break;

    case 2320:
        // Met Astafali (genie)
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2117));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2115));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2115));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2116));
        break;

    case 2321:
        // Met Drogan
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2108));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2115));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2128));
        break;

    case 2322:
        // Met False Harpers
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2114));
        break;

    case 2323:
        // Met Fierlen Taskmaster
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2118));
        break;

    case 2324:
        // Met Hermit
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2107));
        break;

    case 2325:
        // Met Heurodis (shadowy figure) at first head
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2105));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2126));
        break;

    case 2326:
        // Met Katriana in Guard Duty
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2106));
        break;

    case 2327:
        // Met Leomund
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2127));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2107));
        break;

    case 2328:
        // Met Rudolpho (leader of Fierlen)
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2124));
        break;

    case 2329:
        // enter monastery - Zhentarim plot
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2119));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2119));
        break;

    }

}

