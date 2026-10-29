//:://////////////////////////////////////////////////
//:: X0_I0_DECKMANY
/*

Library for the deck of many things.

See the spell script x0_s3_deckmany for an example of
combining these functions to create a deck.

To make your own deck, just add a "Do<whatever>DeckCard" function
for any custom cards you want, then put those cards into the
DoDeckDrawPositive/Negative functions. Then recompile the
spell script x0_s3_deckmany inside your module and a deck inside
your module will use your cards.

*/

#include "x0_i0_treasure"
#include "x0_i0_henchman"

/*************************************************************************
 * CONSTANTS
 *************************************************************************/
const int TOKEN_NAME = 9323;
const int TOKEN_CARD_NAME = 9324;

// This controls how long to delay the actual card effects for
// in order to make the message pop up before it happens
float DECK_DELAY = 8.0;

/*************************************************************************
 * FUNCTION PROTOTYPES
 *************************************************************************/

// Check if the deck has been used before by this creature
int GetHasUsedDeck(object oCaster);

// Mark that the deck has been used by this creature
void SetHasUsedDeck(object oCaster);

// Get the number of draws remaining
int GetNumberDeckDraws(object oCaster);

// Set the number of draws remaining
void SetNumberDeckDraws(object oCaster, int nDraws);

// Do a positive card draw
void DoDeckDrawPositive(object oCaster, int nTurn=0);

// Do a negative card draw
void DoDeckDrawNegative(object oCaster, int nTurn=0);

// Get a special deck-specific area if it exists and is available.
// This will start by checking for an area with just the given area
// tag. If that doesn't exist or is taken, it will start looking
// for areas tagged sAreaTag + number, until it finds one that is available.
// X0_DECK_DONJON1, X0_DECK_DONJON2, etc
// Returns OBJECT_INVALID if no area found.
object GetSpecialAreaForDeckCard(string sAreaTag);

// Get a special area and transport the caster (with
// associates but without party members) to the
// X0_DECK_START waypoint inside it.
//
// Returns TRUE on success, FALSE otherwise.
int DoSpecialAreaDeckCard(object oCaster, string sAreaTag, int nTurn=0);

/*************************************************************************
 * CARD FUNCTIONS
 * If a card draw fails, it will return FALSE, otherwise will return TRUE.
 *************************************************************************/


// ------- NEGATIVE CARDS

// The Fool card (negative)
// Lose 10,000 XP and get 2 extra cards.
int DoFoolDeckCard(object oCaster, int nTurn=0);

// The Donjon card (negative)
// If a donjon area is available, the caster and associates are transported
// there.
// The area should be tagged X0_DECK_DONJON1.
// The starting location should be tagged X0_DECK_START.
// See the Gauntlet area in module 3 of XP1 as an example.
// (This is a good model to use if you want to create a "Keep" or
// "Void" type card for your own module.)
int DoDonjonDeckCard(object oCaster, int nTurn=0);

// The Traitor card (negative)
// Change to diametrically-opposed alignment instantly.
int DoTraitorDeckCard(object oCaster, int nTurn=0);

// The Knave card (negative)
// All non-plot possessions not currently equipped are destroyed.
int DoKnaveDeckCard(object oCaster, int nTurn=0);

// The Plague card (negative)
// Permanent disease effect applied for duration of the module.
int DoPlagueDeckCard(object oCaster, int nTurn=0);

// The Looking Glass card (negative)
// Caster's henchman is replaced with an evil doppelganger.
int DoLookingGlassDeckCard(object oCaster, int nTurn=0);

// The Wyrm card (negative)
// A hostile ancient dragon is lured to the caster.
int DoWyrmDeckCard(object oCaster, int nTurn=0);


// ------- POSITIVE CARDS

// The Joker card (positive)
// Gain 10,000 XP and get 2 extra cards.
int DoJokerDeckCard(object oCaster, int nTurn=0);

// The Hoard card (positive)
// Gain 50-100,000 gold instantly
int DoHoardDeckCard(object oCaster, int nTurn=0);

// The Oracle card (positive)
// Gain permanent premonition effect for duration of the module
int DoOracleDeckCard(object oCaster, int nTurn=0);

// The Avatar card (positive)
// Caster is transformed into an avatar of their alignment.
int DoAvatarDeckCard(object oCaster, int nTurn=0);

// The Fountain card (positive)
// All of caster's items are recharged and all stacked items are
// filled up to the maximum possible number.
int DoFountainDeckCard(object oCaster, int nTurn=0);

// The Hatchling card (positive)
// A wyrmling of alignment-appropriate color appears and follows
// the caster as a summoned creature until damaged, at which point
// it transforms into an adult dragon and fights on the caster's behalf
// until all enemies are slain, then vanishes.
int DoHatchlingDeckCard(object oCaster, int nTurn=0);

// The Bequest card (positive)
// Gain a major unique magical item (this will respect the
// XP1 treasure system if it is used in the module, otherwise
// random boss-level treasure will be generated).
int DoBequestDeckCard(object oCaster, int nTurn=0);

/*************************************************************************
 * FUNCTION DEFINITIONS
 *************************************************************************/


// Check if the deck has been used before by this creature
int GetHasUsedDeck(object oCaster)
{
    return GetLocalInt(oCaster, "X0_DECK_USED");
}

// Mark that the deck has been used by this creature
void SetHasUsedDeck(object oCaster)
{
    SetLocalInt(oCaster, "X0_DECK_USED", TRUE);
}

// Get the number of draws remaining
int GetNumberDeckDraws(object oCaster)
{
    return GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");
}

// Set the number of draws remaining
void SetNumberDeckDraws(object oCaster, int nDraws)
{
    SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nDraws);
}


// Do a positive card draw
void DoDeckDrawPositive(object oCaster, int nTurn=0)
{
    int bDone = FALSE;
    int nTriesMax = 10; // Just as a failsafe
    int nTries = 0;
    string sCardName = "";

    // If a card draw succeeds, bDone will be set to TRUE
    // and this loop will exit.
    while (!bDone && nTries < nTriesMax) {
        nTries++;
        int nCard = Random(7);

        //DBG_msg("nCard positive: " + IntToString(nCard));

        // For each card, we set the custom token 1 to
        // be the name we want to assign to the card.
        switch (nCard) {
        case 0: bDone = DoJokerDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9255); // "Mentor";
                break;
        case 1: bDone = DoHoardDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9258); // "Hoard";
                break;
        case 2: bDone = DoOracleDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9261); //"Oracle";
                break;
        case 3: bDone = DoAvatarDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9248); //"Avatar";
                break;
        case 4: bDone = DoFountainDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9257); //"Fountain";
                break;
        case 5: bDone = DoHatchlingDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9254); //"Hatchling";
                break;
        case 6: bDone = DoBequestDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9249); //"Bequest";
                break;
        }
    }

    // Set the caster name and card name as tokens
    SetCustomToken(TOKEN_NAME, GetName(oCaster));
    DelayCommand(DECK_DELAY*nTurn - 3.0, SetCustomToken(TOKEN_CARD_NAME, sCardName));

    // Apply the visual effect
    int nDeckEffect = 322;
    effect eDraw = EffectVisualEffect(nDeckEffect);
    DelayCommand(DECK_DELAY * nTurn - 2.0,
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                     eDraw,
                                     oCaster));


    if (!bDone)
    {
        // ugh, send error message
        DelayCommand(DECK_DELAY * nTurn - 2.0,
                     FloatingTextStrRefOnCreature(9239, oCaster));
        return;
    }

    // Print out the message
    DelayCommand(DECK_DELAY * nTurn - 2.0,
                 FloatingTextStrRefOnCreature(9238, oCaster));
}

// Do a negative card draw
void DoDeckDrawNegative(object oCaster, int nTurn=0)
{
    int bDone = FALSE;
    int nTriesMax = 10; // Just as a failsafe
    int nTries = 0;
    string sCardName = "";

    // If a card draw succeeds, bDone will be set to TRUE
    // and this loop will exit.
    while (!bDone && nTries < nTriesMax) {
        nTries++;
        int nCard = Random(7);
        //DBG_msg("nCard negative: " + IntToString(nCard));
        switch (nCard) {
        case 0: bDone = DoFoolDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9256); //"Prince of Lies";
                break;
        case 1: bDone = DoDonjonDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9250); //"Gauntlet";
                break;
        case 2: bDone = DoTraitorDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9263); //"Traitor";
                break;
        case 3: bDone = DoKnaveDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9259); //"Knave";
                break;
        case 4: bDone = DoPlagueDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9262); //"Plague";
                break;
        case 5: bDone = DoLookingGlassDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9260); //"Looking Glass";
                break;
        case 6: bDone = DoWyrmDeckCard(oCaster, nTurn);
                sCardName = GetStringByStrRef(9264); //"Wyrm";
                break;
        }
    }

    // Set the caster name and card name as tokens
    SetCustomToken(TOKEN_NAME, GetName(oCaster));
    DelayCommand(DECK_DELAY*nTurn - 3.0, SetCustomToken(TOKEN_CARD_NAME, sCardName));


    // Apply the visual effect
    int nDeckEffect = 322;
    effect eDraw = EffectVisualEffect(nDeckEffect);
    DelayCommand(DECK_DELAY * nTurn - 2.0,
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                     eDraw,
                                     oCaster));


    if (!bDone) {
        // ugh, send error message
        DelayCommand(DECK_DELAY * nTurn - 2.0,
                     FloatingTextStrRefOnCreature(9239, oCaster));
        return;
    }

    // Print out the message
    DelayCommand(DECK_DELAY * nTurn - 2.0,
                 FloatingTextStrRefOnCreature(9238, oCaster));
}



// Get a special deck-specific area if it exists and is available.
// This will start by checking for an area with just the given area
// tag. If that doesn't exist or is taken, it will start looking
// for areas tagged sAreaTag + number, until it finds one that is available.
// X0_DECK_DONJON1, X0_DECK_DONJON2, etc
// Returns OBJECT_INVALID if no area found.
object GetSpecialAreaForDeck(string sAreaTag)
{
    object oArea = GetObjectByTag(sAreaTag);
    if (GetIsObjectValid(oArea) && !GetLocalInt(oArea, "X0_DECK_USED")) {
        SetLocalInt(oArea, "X0_DECK_USED", TRUE);
        return oArea;
    }

    // We didn't find one with the base tag, so start tacking on
    // numbers.
    int nNth = 1;
    oArea = GetObjectByTag(sAreaTag + IntToString(nNth));
    while (GetIsObjectValid(oArea) && GetLocalInt(oArea, "X0_DECK_USED")) {
        nNth++;
        oArea = GetObjectByTag(sAreaTag + IntToString(nNth));
    }

    if (GetIsObjectValid(oArea))
        SetLocalInt(oArea, "X0_DECK_USED", TRUE);

    // Valid or not, return it
    return oArea;
}


// Get a special area and transport the caster (with
// associates but without party members) to the
// X0_DECK_START waypoint inside it.
//
// Returns TRUE on success, FALSE otherwise.
int DoSpecialAreaDeckCard(object oCaster, string sAreaTag, int nTurn=0)
{
    object oArea = GetSpecialAreaForDeck(sAreaTag);
    if (!GetIsObjectValid(oArea)) return FALSE;

    // We have an area, find the X0_DECK_START waypoint inside it
    object oWay;
    object oTmp = GetFirstObjectInArea(oArea);
    if (GetTag(oTmp) == "X0_DECK_START")
    oWay = oTmp;
    else
    oWay = GetNearestObjectByTag("X0_DECK_START", oTmp);

    if (!GetIsObjectValid(oWay)) return FALSE;
    DelayCommand(DECK_DELAY * nTurn, TransportToWaypoint(oCaster, oWay));
    return TRUE;
}


// The Fool card (negative)
// Lose 10,000 XP and get 2 extra cards.
int DoFoolDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_FOOL_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_FOOL_CARD", TRUE);

    int nXP = GetXP(oCaster);
    DelayCommand(DECK_DELAY * nTurn, SetXP(oCaster, nXP-10000));
    int nCards = GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");
    string sMess = GetStringByStrRef(40562);
    DelayCommand(DECK_DELAY * nTurn, SendMessageToPC(oCaster, sMess));
    SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nCards+2);
    return TRUE;
}

// The Donjon card (negative)
// If a donjon area is available, the caster and associates are transported
// there.
// The area should be tagged X0_DECK_DONJON1.
// The starting location should be tagged X0_DECK_START.
// See the Gauntlet area in module 3 of XP1 as an example.
// (This is a good model to use if you want to create a "Keep" or
// "Void" type card for your own module.)
int DoDonjonDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_DONJON_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_DONJON_CARD", TRUE);

    int nSucc = DoSpecialAreaDeckCard(oCaster, "X0_DECK_DONJON", nTurn);
    if (nSucc) {
        // don't get to draw any more cards!
        SetNumberDeckDraws(oCaster, 0);
        string sMessage = GetStringByStrRef(9247);
        //string sMessage = "The remaining cards vanish from your hands!";
        SendMessageToPC(oCaster, sMessage);
    }


    return nSucc;
}

// The Traitor card (negative)
// Change to diametrically-opposed alignment instantly.
int DoTraitorDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_TRAITOR_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_TRAITOR_CARD", TRUE);

    int nGoodEvil = GetAlignmentGoodEvil(oCaster);
    int nLawChaos = GetAlignmentLawChaos(oCaster);
    if (nGoodEvil == ALIGNMENT_GOOD
        || (nGoodEvil == ALIGNMENT_NEUTRAL && Random(2)) ) {
        // make evil
        DelayCommand(DECK_DELAY * nTurn,
                 AdjustAlignment(oCaster, ALIGNMENT_EVIL, 100));
    } else {
        // make good
        DelayCommand(DECK_DELAY * nTurn,
                 AdjustAlignment(oCaster, ALIGNMENT_GOOD, 100));
    }

    if (nLawChaos == ALIGNMENT_LAWFUL
        || (nLawChaos == ALIGNMENT_NEUTRAL && Random(2)) ) {
        // make chaotic
        DelayCommand(DECK_DELAY * nTurn,
                 AdjustAlignment(oCaster, ALIGNMENT_CHAOTIC, 100));
    } else {
        // make lawful
        DelayCommand(DECK_DELAY * nTurn,
                 AdjustAlignment(oCaster, ALIGNMENT_LAWFUL, 100));
    }

    return TRUE;
}

// The Knave card (negative)
// All non-plot possessions not currently equipped are destroyed.
int DoKnaveDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_KNAVE_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_KNAVE_CARD", TRUE);

    object oItem = GetFirstItemInInventory(oCaster);
    while (GetIsObjectValid(oItem)) {
        if (!GetPlotFlag(oItem)) {
            DestroyObject(oItem, DECK_DELAY * nTurn);
        }
        oItem = GetNextItemInInventory(oCaster);
    }
    return TRUE;
}

// Private function used to apply the initial plague effect
void DoPlagueDeckCardEffect(object oCaster)
{
    effect eImp = EffectVisualEffect(VFX_IMP_DISEASE_S);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eImp,
                        oCaster);

    // Apply damage
    int nDam = d10() + 10;
    if (nDam > GetCurrentHitPoints(oCaster)) {
        nDam = GetCurrentHitPoints(oCaster) - 1;
    }
    effect eDam = EffectDamage(nDam,
                   DAMAGE_TYPE_MAGICAL,
                   DAMAGE_POWER_PLUS_FIVE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eDam,
                        oCaster);
}

// The Plague card (negative)
// Permanent disease effect applied for duration of the module.
int DoPlagueDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_PLAGUE_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_PLAGUE_CARD", TRUE);

    // Create the plague object, which will keep applying the
    // nasty plague permanently, even after a restoration spell,
    // muahaha ha ha.... cough, cough.
    object oPlague = CreateObject(OBJECT_TYPE_PLACEABLE,
                  "x0_deck_plague",
                  GetLocation(oCaster));

    if (!GetIsObjectValid(oPlague)) return FALSE;

    SetLocalObject(oPlague, "X0_DECK_TARGET", oCaster);

    DelayCommand(DECK_DELAY * nTurn,
                 AssignCommand(oPlague, DoPlagueDeckCardEffect(oCaster)));

    return TRUE;
}

// Private function to run the actual henchman change after a delay
void DoLookingGlassDeckCardEffect(object oCaster, object oHench)
{
    effect eReplace = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eReplace, oHench);

    FireHenchman(oCaster, oHench);
    ChangeToStandardFaction(oHench, STANDARD_FACTION_HOSTILE);
    DelayCommand(1.0, AssignCommand(oHench, DetermineCombatRound(oCaster)));
}

// The Looking Glass card (negative)
// Caster's henchman is turned hostile.
int DoLookingGlassDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_LOOKGLASS_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_LOOKGLASS_CARD", TRUE);

    object oHench = GetHenchman(oCaster);
    if (!GetIsObjectValid(oHench) || GetArea(oHench) != GetArea(oCaster))
    return FALSE;

    DelayCommand(DECK_DELAY * nTurn,
                 DoLookingGlassDeckCardEffect(oCaster, oHench));
    return TRUE;
}

// Private function to run the actual wyrm summon after a delay
void DoWyrmDeckCardEffect(object oCaster, string sResRef)
{
    object oDrag = CreateObject(OBJECT_TYPE_CREATURE,
                sResRef,
                GetLocation(oCaster),
                TRUE);
    SetIsTemporaryEnemy(oCaster, oDrag);
    DelayCommand(1.0, AssignCommand(oDrag, DetermineCombatRound(oCaster)));
}

// The Wyrm card (negative)
// A dragon is lured to the caster and attacks
int DoWyrmDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_WYRM_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_WYRM_CARD", TRUE);

    int nGoodEvil = GetAlignmentGoodEvil(oCaster);
    string sResRef;
    if (nGoodEvil == ALIGNMENT_EVIL) {
        sResRef = "nw_drgsilv001";
        if (Random(2))
            sResRef = "nw_drggold001";
    } else {
        sResRef = "nw_drgblue001";
        if (Random(2))
            sResRef = "nw_drgred001";
    }

    DelayCommand(DECK_DELAY * nTurn,
                 DoWyrmDeckCardEffect(oCaster, sResRef));

    return TRUE;
}


// ------- POSITIVE CARDS

// The Joker card (positive)
// Gain 10,000 XP and get 2 extra cards.
int DoJokerDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_JOKER_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_JOKER_CARD", TRUE);

    DelayCommand(DECK_DELAY * nTurn, GiveXPToCreature(oCaster, 10000));
    int nCards = GetLocalInt(oCaster, "X0_DECK_CARDS_LEFT");

        string sMess = GetStringByStrRef(40562);
    SendMessageToPC(oCaster, sMess);

    SetLocalInt(oCaster, "X0_DECK_CARDS_LEFT", nCards+2);
    return TRUE;
}

// The Hoard card (positive)
// Gain 50,000 gold instantly
int DoHoardDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_HOARD_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_HOARD_CARD", TRUE);

    DelayCommand(DECK_DELAY * nTurn, GiveGoldToCreature(oCaster, 50000));
    return TRUE;
}

// The Oracle card (positive)
// Gain permanent premonition effect for duration of the module
int DoOracleDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_ORACLE_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_ORACLE_CARD", TRUE);

    // Create the oracle object, which will keep applying the
    // oracle effect permanently, even after resting.
    object oOracle = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  "x0_deck_oracle",
                                  GetLocation(oCaster));

    if (!GetIsObjectValid(oOracle))
        return FALSE;

    SetLocalObject(oOracle, "X0_DECK_TARGET", oCaster);

    effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, 0);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(ePrem, eVis);

    DelayCommand(DECK_DELAY * nTurn,
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster));
    return TRUE;
}

// Private function to create the avatar item on the caster
void DoAvatarDeckCardEffect(object oCaster)
{
    CreateItemOnObject("x0_deck_avatar", oCaster);
}

// Private function to do the avatar transformation effect
void DoAvatarDeckCardTransform(object oCaster)
{
    int nGoodEvil = GetAlignmentGoodEvil(oCaster);
    int nGender = GetGender(oCaster);

    effect ePoly;
    int nVFX;

    // Temporary vars here to avoid magic numbers
    // replace with POLYMORPH_TYPE constants when added to nwscript
    if (nGoodEvil == ALIGNMENT_GOOD) {
        // transform into celestial avenger
        nVFX = VFX_IMP_MAGIC_PROTECTION;
        ePoly = EffectPolymorph(POLYMORPH_TYPE_CELESTIAL_AVENGER);
    } else if (nGoodEvil == ALIGNMENT_EVIL) {
        // transform into vrock or succubus
        nVFX = VFX_IMP_REDUCE_ABILITY_SCORE;
        if (nGender == GENDER_MALE)
            ePoly = EffectPolymorph(POLYMORPH_TYPE_VROCK);
        else
            ePoly = EffectPolymorph(POLYMORPH_TYPE_SUCCUBUS);
    } else {
        // transform into fire or water elemental
        if (nGender == GENDER_MALE) {
            ePoly = EffectPolymorph(POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL);
            nVFX = VFX_IMP_FLAME_M;
        } else {
            ePoly = EffectPolymorph(POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL);
            nVFX = VFX_IMP_MAGIC_PROTECTION;
        }
    }

    effect eVis = EffectVisualEffect(nVFX);

    SetCustomToken(TOKEN_NAME, GetName(oCaster));
    FloatingTextStrRefOnCreature(9246, oCaster);
    //FloatingTextStringOnCreature(GetName(oCaster)
    //                             + " transforms into an avatar.",
    //                             oCaster);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oCaster);
}

// The Avatar card (positive)
// Caster is transformed into an avatar of their alignment.
int DoAvatarDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_AVATAR_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_AVATAR_CARD", TRUE);

    // Create the avatar object, which will allow the user
    // to become the avatar at will.
    DelayCommand(DECK_DELAY * nTurn, DoAvatarDeckCardEffect(oCaster));
    DelayCommand(DECK_DELAY * nTurn, DoAvatarDeckCardTransform(oCaster));

    return TRUE;
}

// The Fountain card (positive)
// All of caster's items are recharged and all stacked items are
// filled up to the maximum possible number.
int DoFountainDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_FOUNTAIN_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_FOUNTAIN_CARD", TRUE);

    object oItem = GetFirstItemInInventory(oCaster);
    while (GetIsObjectValid(oItem)) {
        if (!GetPlotFlag(oItem)) {
            // Set maximum charges & stack
            DelayCommand(DECK_DELAY * nTurn, SetItemCharges(oItem, 50));
            DelayCommand(DECK_DELAY * nTurn, SetItemStackSize(oItem, 99));
        }
        oItem = GetNextItemInInventory(oCaster);
    }
    return TRUE;
}

// Private function used to create the hatchling-summoning object
void DoHatchlingDeckCardEffect(object oCaster)
{
    object oHatchObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                       "x0_deck_hatch",
                                       GetLocation(oCaster));

    SetLocalObject(oHatchObject, "X0_DECK_TARGET", oCaster);
    SetLocalObject(oCaster, "X0_DECK_HATCH_OBJECT", oHatchObject);
}

// Private function used to record the hatchling object
void DoHatchlingDeckCardRecord(string sTag)
{
    object oHatch = GetNearestObjectByTag(sTag);
    SetLocalObject(OBJECT_SELF, "X0_DECK_HATCH", oHatch);

    //DBG_msg("Hatchling summoned: " + GetTag(oHatch));
}

// Private function -- this is assigned to the caster as an action
// to cause them to summon the hatchling.
void DoHatchlingDeckCardSummon()
{
    // Summon the hatchling
    string sResRef;
    int nGoodEvil = GetAlignmentGoodEvil(OBJECT_SELF);
    if (nGoodEvil == ALIGNMENT_EVIL) {
        sResRef = "X0_HATCH_EVIL";
    } else {
        sResRef = "X0_HATCH_GOOD";
    }

    //DBG_msg("Attempting to summon hatchling: " + sResRef);

    effect eSummon = EffectSummonCreature(sResRef,
                                          VFX_IMP_DIVINE_STRIKE_HOLY,
                                          0.5);

    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                          eSummon,
                          GetOppositeLocation(OBJECT_SELF));

    DelayCommand(3.0, DoHatchlingDeckCardRecord(sResRef));
}


// The Hatchling card (positive)
// A wyrmling of alignment-appropriate color appears and follows
// the caster as a summoned creature until damaged, at which point
// it transforms into an adult dragon and fights on the caster's behalf
// until all enemies are slain, then vanishes.
int DoHatchlingDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_HATCHLING_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_HATCHLING_CARD", TRUE);

    // Summon the hatchling
    DelayCommand(DECK_DELAY * nTurn,
                 AssignCommand(oCaster,
                               DoHatchlingDeckCardSummon()));

    // Create the hatchling object, which will resummon
    // the hatchling.
    DelayCommand(DECK_DELAY * nTurn, DoHatchlingDeckCardEffect(oCaster));

    return TRUE;
}

// The Bequest card (positive)
// Gain a major unique magical item (this will respect the
// XP1 treasure system if it is used).
int DoBequestDeckCard(object oCaster, int nTurn=0)
{
    if (GetLocalInt(oCaster, "X0_DECK_BEQUEST_CARD")) return FALSE;
    SetLocalInt(oCaster, "X0_DECK_BEQUEST_CARD", TRUE);

    DelayCommand(DECK_DELAY * nTurn,
         CTG_CreateTreasure(TREASURE_TYPE_UNIQUE, oCaster, oCaster));
    return TRUE;
}

/*  void main() {} /* */
