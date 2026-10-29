
//:://////////////////////////////////////////////////
//:: M3_UD_EVT_ROUTER.NSS
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
This is the user-defined event handler for the event
router object for module 3.

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

    case 2400:
        // Approach South Quarter: Gauntlet
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2114));
        break;

    case 2401:
        // Approach spa
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2128));
        break;

    case 2402:
        // Depetrified
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2103));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2116));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2117));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2116));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2109));
        break;

    case 2403:
        // Enter Ancient Crypt
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2108));
        break;

    case 2404:
        // Enter Ancient Crypt Level 2
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2111));
        break;

    case 2405:
        // Enter Desert Caves (see ritual remains)
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2128));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2109));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2127));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2103));
        break;

    case 2406:
        // Enter East Quarter
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2116));
        break;

    case 2407:
        // Enter East Quarter: good/evil choice (give item) 1
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2125));
        break;

    case 2408:
        // Enter East Quarter: good/evil choice (hunter/grey render) 2
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2119));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2126));
        break;

    case 2409:
        // Enter East Quarter: Inner Sanctum
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2117));
        break;

    case 2410:
        // Enter East Quarter: law/chaos choice (kill/turn in) 1
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2127));
        break;

    case 2411:
        // Enter North Quarter
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2107));
        break;

    case 2412:
        // Enter South Quarter
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2118));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2108));
        break;

    case 2413:
        // Enter summit first
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2101));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2117));
        break;

    case 2414:
        // "Enter Tower, Heurodis first"
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2122));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2127));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2110));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2108));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2122));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2110));
        break;

    case 2415:
        // "Enter Tower, PC first"
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2121));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2110));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2110));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2109));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2121));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2110));
        break;

    case 2416:
        // Enter Undrentide
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2110));
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2128));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2108));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2127));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2111));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2101));
        break;

    case 2417:
        // Enter West Quarter
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2118));
        break;

    case 2418:
        // Enter West Quarter: hell
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2118));
        break;

    case 2419:
        // Enter West Quarter: pirate book
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2110));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2105));
        break;

    case 2420:
        // Enter West Quarter: romance novel
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2129));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2128));
        break;

    case 2421:
        // Got ritual dagger for summoning demon
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2116));
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2129));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2115));
        break;

    case 2422:
        // Got South Quarter: create item quest (need to kill grey slaad)
        SignalEvent(GetObjectByTag("X0_HEN_XAN"), EventUserDefined(2119));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2117));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2113));
        break;

    case 2423:
        // Killed Corith
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2128));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2123));
        break;

    case 2424:
        // Learned about Asabi quest to kill Corith
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2121));
        break;

    case 2425:
        // Met Asabi
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2129));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2108));
        break;

    case 2426:
        // Met Css'ki'kil
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2110));
        break;

    case 2427:
        // Met Ethrazar
        break;

    case 2428:
        // Met Heurodis (outside of tower)
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2102));
        break;

    case 2429:
        // Met Karsus
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2109));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2129));
        break;

    case 2430:
        // Met moon rat (not knowing secret)
        SignalEvent(GetObjectByTag("X0_HEN_DOR"), EventUserDefined(2118));
        SignalEvent(GetObjectByTag("X0_HEN_DEE"), EventUserDefined(2118));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2118));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2106));
        break;

    case 2431:
        // Met Shadovar
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2129));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2112));
        break;

    case 2432:
        // Rescued Corith
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2124));
        break;

    case 2433:
        // See Heurodis complete a mastery
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2103));
        break;

    case 2434:
        // See Heurodis complete the final mastery
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2104));
        break;

    case 2435:
        // Took Asabi quest to kill Corith
        SignalEvent(GetObjectByTag("X0_HEN_MIS"), EventUserDefined(2128));
        SignalEvent(GetObjectByTag("X0_HEN_ASS"), EventUserDefined(2119));
        SignalEvent(GetObjectByTag("X0_HEN_MAL"), EventUserDefined(2122));
        break;

    }

}

