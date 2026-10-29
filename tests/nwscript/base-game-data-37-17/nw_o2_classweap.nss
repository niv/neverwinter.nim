//::///////////////////////////////////////////////
//:: Weapon Spawn Script for Martial Classes
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in a magical SPECIFIC weapon suited for that class.
    Will spawn in either a generic or specific, depending on the
    value.

    NOTE: Only works on containers
*/
//:://////////////////////////////////////////////
//:: Created By:   Andrew, Brent
//:: Created On:   February 2002
//:://////////////////////////////////////////////

#include "NW_O2_CONINCLUDE"



void CreateBastardSword(object oTarget, object oAdventurer)
{
	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs002"; break;
                   }
        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs002"; break;
                   }
        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs002"; break;
                       case 2: sItem = "nw_wswmbs009"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs009"; break;
                       case 2: sItem = "nw_wswmbs005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                   int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs005"; break;
                       case 2: sItem = "nw_wswmbs010"; break;
                       case 3: sItem = "nw_wswmbs006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmbs010"; break;
                       case 2: sItem = "nw_wswmbs006"; break;
                       case 3: sItem = "nw_wswmbs007"; break;
                       case 4: sItem = "nw_wswmbs003"; break;
                       case 5: sItem = "nw_wswmbs004"; break;
                   }
        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateBattleAxe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt002"; break;
                  }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt002"; break;
                       case 2: sItem = "nw_waxmbt010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt010"; break;
                       case 2: sItem = "nw_waxmbt011"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt011"; break;
                       case 2: sItem = "nw_waxmbt006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                   int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmbt011"; break;
                       case 2: sItem = "nw_waxmbt006"; break;
                       case 3: sItem = "nw_waxmbt003"; break;
                       case 4: sItem = "nw_waxmbt004"; break;
                       case 5: sItem = "nw_waxmbt005"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateClub(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                    int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl002"; break;
                       case 2: sItem = "nw_wblmcl010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                   int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl010"; break;
                       case 2: sItem = "nw_wblmcl004"; break;
                       case 3: sItem = "nw_wblmcl003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl004"; break;
                       case 2: sItem = "nw_wblmcl003"; break;
                       case 3: sItem = "nw_wblmcl011"; break;
                       case 4: sItem = "nw_wblmcl005"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl011"; break;
                       case 2: sItem = "nw_wblmcl005"; break;
                       case 3: sItem = "nw_wblmcl006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}

void CreateDagger(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {

                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg002"; break;
                   }
        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg002"; break;
                       case 2: sItem = "nw_wswmdg008"; break;
                       case 3: sItem = "nw_wswmdg006"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg008"; break;
                       case 2: sItem = "nw_wswmdg006"; break;
                       case 3: sItem = "nw_wswmdg009"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg009"; break;
                       case 2: sItem = "nw_wswmdg004"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmdg009"; break;
                       case 2: sItem = "nw_wswmdg004"; break;
                       case 3: sItem = "nw_wswmdg003"; break;
                       case 4: sItem = "nw_wswmdg007"; break;
                       case 5: sItem = "nw_wswmdg005"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateDart(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt002"; break;
                       case 2: sItem = "nw_wthmdt002"; break;
                       case 3: sItem = "nw_wthmdt008"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt008"; break;
                       case 2: sItem = "nw_wthmdt009"; break;
                       case 3: sItem = "nw_wthmdt003"; break;
                   }

        }
        else
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt009"; break;
                       case 2: sItem = "nw_wthmdt003"; break;
                       case 3: sItem = "nw_wthmdt007"; break;
                   }

        }

	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, Random(40) + 1);
}
void CreateDireMace(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma002"; break;
                       case 2: sItem = "nw_wdbmma003"; break;
                       case 3: sItem = "nw_wdbmma010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma003"; break;
                       case 2: sItem = "nw_wdbmma010"; break;
                       case 3: sItem = "nw_wdbmma005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma005"; break;
                       case 2: sItem = "nw_wdbmma011"; break;
                       case 3: sItem = "nw_wdbmma004"; break;
                       case 4: sItem = "nw_wdbmma006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma005"; break;
                       case 2: sItem = "nw_wdbmma011"; break;
                       case 3: sItem = "nw_wdbmma004"; break;
                       case 4: sItem = "nw_wdbmma006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateDoubleAxe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax002"; break;
                       case 2: sItem = "nw_wdbmax010"; break;
                       case 3: sItem = "nw_wdbmax006"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax010"; break;
                       case 2: sItem = "nw_wdbmax006"; break;
                       case 3: sItem = "nw_wdbmax005"; break;
                   }

        }
        else  if (GetRange(5, nHD))
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax005"; break;
                       case 2: sItem = "nw_wdbmax011"; break;
                       case 3: sItem = "nw_wdbmax004"; break;
                       case 4: sItem = "nw_wdbmax007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmax011"; break;
                       case 2: sItem = "nw_wdbmax004"; break;
                       case 3: sItem = "nw_wdbmax007"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateGreatAxe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr002"; break;
                       case 2: sItem = "nw_waxmgr009"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr002"; break;
                       case 2: sItem = "nw_waxmgr009"; break;
                       case 3: sItem = "nw_waxmgr003"; break;
                       case 4: sItem = "nw_waxmgr006"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {

                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr003"; break;
                       case 2: sItem = "nw_waxmgr006"; break;
                       case 3: sItem = "nw_waxmgr011"; break;
                   }
        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmgr011"; break;
                       case 2: sItem = "nw_waxmgr005"; break;
                       case 3: sItem = "nw_waxmgr004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateGreatSword(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs002"; break;
                       case 2: sItem = "nw_wswmgs011"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs011"; break;
                       case 2: sItem = "nw_wswmgs006"; break;
                       case 3: sItem = "nw_wswmgs004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs006"; break;
                       case 2: sItem = "nw_wswmgs004"; break;
                       case 3: sItem = "nw_wswmgs012"; break;
                       case 4: sItem = "nw_wswmgs005"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {

                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmgs012"; break;
                       case 2: sItem = "nw_wswmgs005"; break;
                       case 3: sItem = "nw_wswmgs003"; break;
                   }
        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateHalberd(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb002"; break;
                       case 2: sItem = "nw_wplmhb010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb010"; break;
                       case 2: sItem = "nw_wplmhb004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb004"; break;
                       case 2: sItem = "nw_wplmhb011"; break;
                       case 3: sItem = "nw_wplmhb003"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmhb011"; break;
                       case 2: sItem = "nw_wplmhb003"; break;
                       case 3: sItem = "nw_wplmhb007"; break;
                       case 4: sItem = "nw_wplmhb006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateHandAxe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn002"; break;
                       case 2: sItem = "nw_waxmhn010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn010"; break;
                       case 2: sItem = "nw_waxmhn004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn004"; break;
                       case 2: sItem = "nw_waxmhn011"; break;
                       case 3: sItem = "nw_waxmhn003"; break;
                       case 4: sItem = "nw_waxmhn005"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_waxmhn011"; break;
                       case 2: sItem = "nw_waxmhn003"; break;
                       case 3: sItem = "nw_waxmhn005"; break;
                       case 4: sItem = "nw_waxmhn006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateHeavyCrossbow(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh002"; break;
                       case 2: sItem = "nw_wbwmxh002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh002"; break;
                       case 2: sItem = "nw_wbwmxh008"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh002"; break;
                       case 2: sItem = "nw_wbwmxh008"; break;
                       case 3: sItem = "nw_wbwmxh009"; break;
                       case 4: sItem = "nw_wbwmxh005"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh009"; break;
                       case 2: sItem = "nw_wbwmxh005"; break;
                       case 3: sItem = "nw_wbwmxh003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh003"; break;
                       case 2: sItem = "nw_wbwmxh004"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh004"; break;
                       case 2: sItem = "nw_wbwmxh007"; break;
                       case 3: sItem = "nw_wbwmxh006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateHeavyFlail(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh002"; break;
                       case 2: sItem = "nw_wblmfh007"; break;
                       case 3: sItem = "nw_wblmfh010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh002"; break;
                       case 2: sItem = "nw_wblmfh007"; break;
                       case 3: sItem = "nw_wblmfh010"; break;
                       case 4: sItem = "nw_wblmfh004"; break;
                       case 5: sItem = "nw_wblmfh008"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh004"; break;
                       case 2: sItem = "nw_wblmfh008"; break;
                       case 3: sItem = "nw_wblmfh011"; break;
                       case 4: sItem = "nw_wblmfh006"; break;
                       case 5: sItem = "nw_wblmfh003"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                   int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfh011"; break;
                       case 2: sItem = "nw_wblmfh006"; break;
                       case 3: sItem = "nw_wblmfh003"; break;
                       case 4: sItem = "nw_wblmfh005"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateKama(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka002"; break;
                       case 2: sItem = "nw_wspmka004"; break;
                       case 3: sItem = "nw_wspmka007"; break;
                       case 4: sItem = "nw_wspmka008"; break;
                       case 5: sItem = "nw_wspmka005"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka004"; break;
                       case 2: sItem = "nw_wspmka007"; break;
                       case 3: sItem = "nw_wspmka008"; break;
                       case 4: sItem = "nw_wspmka005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka005"; break;
                       case 2: sItem = "nw_wspmka009"; break;
                       case 3: sItem = "nw_wspmka006"; break;
                       case 4: sItem = "nw_wspmka003"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka009"; break;
                       case 2: sItem = "nw_wspmka006"; break;
                       case 3: sItem = "nw_wspmka003"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateKatana(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                   int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka002"; break;
                       case 2: sItem = "nw_wswmka005"; break;
                       case 3: sItem = "nw_wswmka010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka005"; break;
                       case 2: sItem = "nw_wswmka010"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka011"; break;
                       case 2: sItem = "nw_wswmka007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmka011"; break;
                       case 2: sItem = "nw_wswmka007"; break;
                       case 3: sItem = "nw_wswmka006"; break;
                       case 4: sItem = "nw_wswmka004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateKukri(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku002"; break;
                       case 2: sItem = "nw_wspmku006"; break;
                       case 3: sItem = "nw_wspmku008"; break;
                       case 4: sItem = "nw_wspmku005"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku006"; break;
                       case 2: sItem = "nw_wspmku008"; break;
                       case 3: sItem = "nw_wspmku005"; break;
                       case 4: sItem = "nw_wspmku004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku004"; break;
                       case 2: sItem = "nw_wspmku009"; break;
                       case 3: sItem = "nw_wspmku007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmku009"; break;
                       case 2: sItem = "nw_wspmku007"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateLightCrossbow(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwxl001"; break;
                       case 2: sItem = "nw_wbwmxl002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl002"; break;
                       case 2: sItem = "nw_wbwmxl008"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl008"; break;
                       case 2: sItem = "nw_wbwmxl009"; break;
                       case 3: sItem = "nw_wbwmxl005"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl009"; break;
                       case 2: sItem = "nw_wbwmxl005"; break;
                       case 3: sItem = "nw_wbwmxl003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wbwmxl004"; break;
                       case 3: sItem = "nw_wbwmxl007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wbwmxl004"; break;
                       case 3: sItem = "nw_wbwmxl007"; break;
                       case 4: sItem = "nw_wbwmxl006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}

void CreateLightFlail(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl002"; break;
                       case 2: sItem = "nw_wblmfl010"; break;
                       case 3: sItem = "nw_wblmfl004"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl010"; break;
                       case 2: sItem = "nw_wblmfl004"; break;
                       case 3: sItem = "nw_wblmfl005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl005"; break;
                       case 2: sItem = "nw_wblmfl011"; break;
                       case 3: sItem = "nw_wblmfl007"; break;
                       case 4: sItem = "nw_wblmfl006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl011"; break;
                       case 2: sItem = "nw_wblmfl007"; break;
                       case 3: sItem = "nw_wblmfl006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}

void CreateLightHammer(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl002"; break;
                       case 2: sItem = "nw_wblmhl010"; break;
                       case 3: sItem = "nw_wblmhl004"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl010"; break;
                       case 2: sItem = "nw_wblmhl004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl005"; break;
                       case 2: sItem = "nw_wblmhl011"; break;
                       case 3: sItem = "nw_wblmhl006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl005"; break;
                       case 2: sItem = "nw_wblmhl011"; break;
                       case 3: sItem = "nw_wblmhl006"; break;
                       case 4: sItem = "nw_wblmhl009"; break;
                       case 5: sItem = "nw_wblmhl003"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateLightMace(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml002"; break;
                       case 2: sItem = "nw_wblmml011"; break;
                       case 3: sItem = "nw_wblmml006"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml011"; break;
                       case 2: sItem = "nw_wblmml006"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml012"; break;
                       case 2: sItem = "nw_wblmml004"; break;
                       case 3: sItem = "nw_wblmml005"; break;
                       case 4: sItem = "nw_wblmml007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmml012"; break;
                       case 2: sItem = "nw_wblmml004"; break;
                       case 3: sItem = "nw_wblmml005"; break;
                       case 4: sItem = "nw_wblmml007"; break;
                       case 5: sItem = "nw_wblmml008"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateLongSword(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls002"; break;
                       case 2: sItem = "nw_wswmls010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls010"; break;
                       case 2: sItem = "nw_wswmls007"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls007"; break;
                       case 2: sItem = "nw_wswmls012"; break;
                       case 3: sItem = "nw_wswmls005"; break;
                       case 4: sItem = "nw_wswmls006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmls012"; break;
                       case 2: sItem = "nw_wswmls005"; break;
                       case 3: sItem = "nw_wswmls006"; break;
                       case 4: sItem = "nw_wswmls004"; break;
                       case 5: sItem = "nw_wswmls013"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateLongbow(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln002"; break;
                       case 2: sItem = "nw_wbwmln002"; break;
                       case 3: sItem = "nw_wbwmln008"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                   int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln002"; break;
                       case 2: sItem = "nw_wbwmln008"; break;
                       case 3: sItem = "nw_wbwmln009"; break;
                       case 4: sItem = "nw_wbwmln004"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln009"; break;
                       case 2: sItem = "nw_wbwmln004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln004"; break;
                       case 2: sItem = "nw_wbwmln007"; break;
                       case 3: sItem = "nw_wbwmln006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmln007"; break;
                       case 2: sItem = "nw_wbwmln006"; break;
                       case 3: sItem = "nw_wbwmln005"; break;
                       case 4: sItem = "nw_wbwmln003"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateMorningstar(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms002"; break;
                       case 2: sItem = "nw_wblmms010"; break;
                       case 3: sItem = "nw_wblmms007"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms007"; break;
                       case 2: sItem = "nw_wblmms003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms003"; break;
                       case 2: sItem = "nw_wblmms011"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms011"; break;
                       case 2: sItem = "nw_wblmms006"; break;
                       case 3: sItem = "nw_wblmms004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateRapier(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp002"; break;
                       case 2: sItem = "nw_wswmrp004"; break;
                       case 3: sItem = "nw_wswmrp010"; break;
                       case 4: sItem = "nw_wswmrp003"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp004"; break;
                       case 2: sItem = "nw_wswmrp010"; break;
                       case 3: sItem = "nw_wswmrp003"; break;
                       case 4: sItem = "nw_wswmrp005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp003"; break;
                       case 2: sItem = "nw_wswmrp005"; break;
                       case 3: sItem = "nw_wswmrp011"; break;
                       case 4: sItem = "nw_wswmrp007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmrp011"; break;
                       case 2: sItem = "nw_wswmrp007"; break;
                       case 3: sItem = "nw_wswmrp006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateScimitar(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc002"; break;
                       case 2: sItem = "nw_wswmsc010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc010"; break;
                       case 2: sItem = "nw_wswmsc004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc004"; break;
                       case 2: sItem = "nw_wswmsc011"; break;
                       case 3: sItem = "nw_wswmsc006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmsc011"; break;
                       case 2: sItem = "nw_wswmsc006"; break;
                       case 3: sItem = "nw_wswmsc007"; break;
                       case 4: sItem = "nw_wswmsc005"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateScythe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc002"; break;
                       case 2: sItem = "nw_wplmsc010"; break;
                       case 3: sItem = "nw_wplmsc003"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc010"; break;
                       case 2: sItem = "nw_wplmsc003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc003"; break;
                       case 2: sItem = "nw_wplmsc011"; break;
                       case 3: sItem = "nw_wplmsc006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc011"; break;
                       case 2: sItem = "nw_wplmsc006"; break;
                       case 3: sItem = "nw_wplmsc005"; break;
                       case 4: sItem = "nw_wplmsc004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateShortsword(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss002"; break;
                       case 2: sItem = "nw_wswmss009"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss009"; break;
                       case 2: sItem = "nw_wswmss011"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss011"; break;
                       case 2: sItem = "nw_wswmss005"; break;
                       case 3: sItem = "nw_wswmss004"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wswmss011"; break;
                       case 2: sItem = "nw_wswmss005"; break;
                       case 3: sItem = "nw_wswmss004"; break;
                       case 4: sItem = "nw_wswmss006"; break;
                       case 5: sItem = "nw_wswmss003"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateShortbow(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                   int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh002"; break;
                       case 2: sItem = "nw_wbwmsh002"; break;
                   }
       }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh002"; break;
                       case 2: sItem = "nw_wbwmsh008"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh008"; break;
                       case 2: sItem = "nw_wbwmsh009"; break;
                       case 3: sItem = "nw_wbwmsh003"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh009"; break;
                       case 2: sItem = "nw_wbwmsh003"; break;
                       case 3: sItem = "nw_wbwmsh006"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh006"; break;
                       case 2: sItem = "nw_wbwmsh007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh007"; break;
                       case 2: sItem = "nw_wbwmsh005"; break;
                       case 3: sItem = "nw_wbwmsh004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateShuriken(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh002"; break;
                       case 2: sItem = "nw_wthmsh002"; break;
                       case 3: sItem = "nw_wthmsh003"; break;
                       case 4: sItem = "nw_wthmsh008"; break;
                       case 5: sItem = "nw_wthmsh006"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh002"; break;
                       case 2: sItem = "nw_wthmsh003"; break;
                       case 3: sItem = "nw_wthmsh008"; break;
                       case 4: sItem = "nw_wthmsh006"; break;
                       case 5: sItem = "nw_wthmsh009"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh006"; break;
                       case 2: sItem = "nw_wthmsh009"; break;
                       case 3: sItem = "nw_wthmsh005"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh009"; break;
                       case 2: sItem = "nw_wthmsh005"; break;
                       case 3: sItem = "nw_wthmsh004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh005"; break;
                       case 2: sItem = "nw_wthmsh004"; break;
                       case 3: sItem = "nw_wthmsh007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh005"; break;
                       case 2: sItem = "nw_wthmsh004"; break;
                       case 3: sItem = "nw_wthmsh007"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, Random(40) + 1);
}
void CreateSickle(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc002"; break;
                       case 2: sItem = "nw_wspmsc010"; break;
                       case 3: sItem = "nw_wspmsc004"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc010"; break;
                       case 2: sItem = "nw_wspmsc004"; break;
                       case 3: sItem = "nw_wspmsc005"; break;
                       case 4: sItem = "nw_wspmsc006"; break;
                       case 5: sItem = "nw_wspmsc003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc005"; break;
                       case 2: sItem = "nw_wspmsc006"; break;
                       case 3: sItem = "nw_wspmsc003"; break;
                       case 4: sItem = "nw_wspmsc011"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmsc011"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateSling(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl001"; break;
                       case 2: sItem = "nw_wbwmsl001"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                   int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl001"; break;
                       case 2: sItem = "nw_wbwmsl009"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl009"; break;
                       case 2: sItem = "nw_wbwmsl010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl010"; break;
                       case 2: sItem = "nw_wbwmsl003"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl003"; break;
                       case 2: sItem = "nw_wbwmsl007"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl007"; break;
                       case 2: sItem = "nw_wbwmsl006"; break;
                       case 3: sItem = "nw_wbwmsl008"; break;
                       case 4: sItem = "nw_wbwmsl004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateSpear(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmss002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmss002"; break;
                   }
        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmss002"; break;
                       case 2: sItem = "nw_wbwmsl005"; break;
                       case 3: sItem = "nw_wplmss010"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl005"; break;
                       case 2: sItem = "nw_wplmss010"; break;
                       case 3: sItem = "nw_wplmss005"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmss005"; break;
                       case 2: sItem = "nw_wplmss011"; break;
                       case 3: sItem = "nw_wplmss007"; break;
                       case 4: sItem = "nw_wplmss006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmss011"; break;
                       case 2: sItem = "nw_wplmss007"; break;
                       case 3: sItem = "nw_wplmss006"; break;
                       case 4: sItem = "nw_wplmss004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateStaff(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs002"; break;
                       case 2: sItem = "nw_wdbmqs005"; break;
                       case 3: sItem = "nw_wdbmqs006"; break;
                       case 4: sItem = "nw_wdbmqs008"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wdbmqs008"; break;
                       case 4: sItem = "nw_wdbmqs004"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs004"; break;
                       case 2: sItem = "nw_wdbmqs009"; break;
                       case 3: sItem = "nw_wdbmqs003"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs009"; break;
                       case 2: sItem = "nw_wdbmqs003"; break;
                       case 3: sItem = "nw_wdbmqs007"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateThrowingAxe(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax002"; break;
                       case 2: sItem = "nw_wthmax008"; break;
                       case 3: sItem = "nw_wthmax005"; break;
                       case 4: sItem = "nw_wthmax007"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax008"; break;
                       case 2: sItem = "nw_wthmax005"; break;
                       case 3: sItem = "nw_wthmax007"; break;
                       case 4: sItem = "nw_wthmax003"; break;
                       case 5: sItem = "nw_wthmax004"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax007"; break;
                       case 2: sItem = "nw_wthmax003"; break;
                       case 3: sItem = "nw_wthmax004"; break;
                       case 4: sItem = "nw_wthmax009"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax003"; break;
                       case 2: sItem = "nw_wthmax004"; break;
                       case 3: sItem = "nw_wthmax009"; break;
                       case 4: sItem = "nw_wthmax006"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax009"; break;
                       case 2: sItem = "nw_wthmax006"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, Random(40) + 1);
}
void CreateTwoBladedSword(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw002"; break;
                       case 2: sItem = "nw_wdbmsw002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw002"; break;
                       case 2: sItem = "nw_wdbmsw010"; break;
                       case 3: sItem = "nw_wdbmsw006"; break;
                       case 4: sItem = "nw_wdbmsw007"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw010"; break;
                       case 2: sItem = "nw_wdbmsw006"; break;
                       case 3: sItem = "nw_wdbmsw007"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw011"; break;
                       case 2: sItem = "nw_wdbmsw005"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmsw011"; break;
                       case 2: sItem = "nw_wdbmsw005"; break;
                       case 3: sItem = "nw_wdbmsw004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
void CreateWarhammer(object oTarget, object oAdventurer)
{

	    string sItem = "";
        int nHD = GetHitDice(oAdventurer);

        if (GetRange(1, nHD))    // * 800
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw002"; break;
                   }

        }
        else if (GetRange(2, nHD))   // * 200 - 2500
        {
                  int nRandom = Random(1) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw002"; break;
                   }

        }
        else if (GetRange(3, nHD))   // * 800 - 10000
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw002"; break;
                       case 2: sItem = "nw_wblmhw011"; break;
                       case 3: sItem = "nw_wblmhw006"; break;
                   }

        }
        else if (GetRange(4, nHD))   // * 2500 - 16500
        {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw011"; break;
                       case 2: sItem = "nw_wblmhw006"; break;
                   }

        }
        else if (GetRange(5, nHD))   // * 8000 - 25000
        {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw006"; break;
                       case 2: sItem = "nw_wblmhw005"; break;
                       case 3: sItem = "nw_wblmhw012"; break;
                       case 4: sItem = "nw_wblmhw003"; break;
                   }

        }
        else if (GetRange(6, nHD))   // * 16000 and up
        {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw012"; break;
                       case 2: sItem = "nw_wblmhw003"; break;
                       case 3: sItem = "nw_wblmhw004"; break;
                   }

        }
	    if (sItem != "")
          dbCreateItemOnObject(sItem, oTarget, 1);
}
//::///////////////////////////////////////////////
//:: Prefers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if oAdventurer prefers using
    this weapon.
    CRITERIA: They have Weapon Focus
    nFeatWeaponType: Uses the feat constants
    to differentiate the weapon types
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: March 2002
//:://////////////////////////////////////////////
int Prefers(int nFeatWeaponType, object oAdventurer)
{
    if (GetHasFeat(nFeatWeaponType, oAdventurer) == TRUE)
    return TRUE;
    else
    return FALSE;
}

void main()
{
    object oLastOpener = GetLastOpener();
    object oContainer = OBJECT_SELF;

    if (GetLocalInt(OBJECT_SELF, "NW_L_OPENONCE") > 0 || GetIsObjectValid(oLastOpener) == FALSE)
    {
        return; // * abort treasure if no one opened the container
    }
    SetLocalInt(OBJECT_SELF, "NW_L_OPENONCE",1);
    ShoutDisturbed();

    // * CHoose the weapon type to create
    if (Prefers(FEAT_WEAPON_FOCUS_BASTARD_SWORD, oLastOpener) == TRUE)
    {
        CreateBastardSword(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_BATTLE_AXE,oLastOpener))
    {
        CreateBattleAxe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_CLUB,oLastOpener))
    {
        CreateClub(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_DAGGER,oLastOpener))
    {
        CreateDagger(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_DART,oLastOpener))
    {
        CreateDart(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_DIRE_MACE,oLastOpener))
    {
        CreateDireMace(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oLastOpener))
    {
        CreateDoubleAxe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_GREAT_AXE,oLastOpener))
    {
        CreateGreatAxe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_GREAT_SWORD,oLastOpener))
    {
        CreateGreatSword(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_HALBERD,oLastOpener))
    {
        CreateHalberd(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_HAND_AXE,oLastOpener))
    {
        CreateHandAxe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oLastOpener))
    {
        CreateHeavyCrossbow(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oLastOpener))
    {
        CreateHeavyFlail(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_KAMA,oLastOpener))
    {
        CreateKama(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_KATANA,oLastOpener))
    {
        CreateKatana(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_KUKRI,oLastOpener))
    {
        CreateKukri(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oLastOpener))
    {
        CreateLightCrossbow(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oLastOpener))
    {
        CreateLightFlail(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oLastOpener))
    {
        CreateLightHammer(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LIGHT_MACE,oLastOpener))
    {
        CreateLightMace(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LONG_SWORD,oLastOpener))
    {
        CreateLongSword(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_LONGBOW,oLastOpener))
    {
        CreateLongbow(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_MORNING_STAR,oLastOpener))
    {
        CreateMorningstar(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_RAPIER,oLastOpener))
    {
        CreateRapier(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SCIMITAR,oLastOpener))
    {
        CreateScimitar(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SCYTHE,oLastOpener))
    {
        CreateScythe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SHORT_SWORD,oLastOpener))
    {
        CreateShortsword(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SHORTBOW,oLastOpener))
    {
        CreateShortbow(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SHURIKEN,oLastOpener))
    {
        CreateShuriken(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SICKLE,oLastOpener))
    {
        CreateSickle(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SLING,oLastOpener))
    {
        CreateSling(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_SPEAR,oLastOpener))
    {
        CreateSpear(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_STAFF,oLastOpener))
    {
        CreateStaff(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_THROWING_AXE,oLastOpener))
    {
        CreateThrowingAxe(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oLastOpener))
    {
        CreateTwoBladedSword(oContainer, oLastOpener);
    }
    else if (Prefers(FEAT_WEAPON_FOCUS_WAR_HAMMER,oLastOpener))
    {
        CreateWarhammer(oContainer, oLastOpener);
    }
    else
    {
        // * if get to this point then the PC did not have Weapon Focus
        // * in anything then do additional logic to give an appropriate weapon
        if (GetLevelByClass(CLASS_TYPE_DRUID, oLastOpener) >= 1)
        {
            CreateSpecificDruidWeapon(oContainer, oLastOpener);

        }
        else
        if (GetLevelByClass(CLASS_TYPE_WIZARD, oLastOpener) >= 1)
        {
            CreateSpecificWizardWeapon(oContainer, oLastOpener);

        }
        else
        if (GetLevelByClass(CLASS_TYPE_SORCERER, oLastOpener) >= 1)
        {
            CreateDagger(oContainer, oLastOpener);
        }
        else
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oLastOpener) >= 1 || GetLevelByClass(CLASS_TYPE_FIGHTER, oLastOpener) >= 1 || GetLevelByClass(CLASS_TYPE_RANGER, oLastOpener) >= 1)
        {
            CreateLongSword(oContainer, oLastOpener);
        }
        else
        if (GetLevelByClass(CLASS_TYPE_BARBARIAN, oLastOpener) >= 1 || GetLevelByClass(CLASS_TYPE_DRUID, oLastOpener) >= 1)
        {
            CreateClub(oContainer, oLastOpener);
        }
        else
        if (GetLevelByClass(CLASS_TYPE_MONK, oLastOpener) >= 1)
        {
            CreateSpecificMonkWeapon(oContainer, oLastOpener);
        }
        else
        if (GetLevelByClass(CLASS_TYPE_CLERIC, oLastOpener) >= 1)
        {
            CreateLightMace(oContainer, oLastOpener);
        }
        else
        if (GetLevelByClass(CLASS_TYPE_ROGUE, oLastOpener) >= 1 || GetLevelByClass(CLASS_TYPE_BARD, oLastOpener) >= 1)
        {
            CreateShortsword(oContainer, oLastOpener);
        }
    }
}


