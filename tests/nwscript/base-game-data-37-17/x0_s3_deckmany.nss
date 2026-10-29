//:://////////////////////////////////////////////////
//:: X0_S3_DECKMANY
/*

Spell script for Deck of Many Things object.

NOTES:
- user must decide to draw 1, 2, 3 cards at the outset (done via
  radial menu), and once this decision is made, the cards will all
  be drawn one after another, inexorably.
- user can only get more than 3 cards via the Joker or the Fool
- user can only use the deck once per character per module

See the library x0_i0_deckmany for how the individual cards
are implemented, and for ways to add your own cards.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/25/2002
//:://////////////////////////////////////////////////

// This library holds all of the functions for the
// individual cards.
#include "x0_i0_deckmany"

// Run the multiple-card draw
void DoDeck(object oCaster);

void main()
{
    // This is the person using the deck
    object oCaster = OBJECT_SELF;
    // This is the number of cards being drawn
    int nCards = GetCasterLevel(OBJECT_SELF);
    //DBG_msg("Cards to draw: " + IntToString(nCards));

    // Create an invisible object to actually run the draws
    object oDeck = CreateObject(OBJECT_TYPE_PLACEABLE,
                                "plc_invisobj",
                                GetLocation(oCaster));

    SetNumberDeckDraws(oCaster, nCards);
    AssignCommand(oDeck, DoDeck(oCaster));

    // Clean up the deck object
    DestroyObject(oDeck, DECK_DELAY * 20);
}

void DoDeck(object oCaster)
{



    // Randomly start with a positive or negative card
    int bNegative = Random(2);

    // Keep track of how many we've drawn so far
    // so we can delay effects
    int nTurn = 0;

    // No interrupting the deck!
    int nDrawsLeft = GetNumberDeckDraws(oCaster);

    while (nDrawsLeft > 0) {
        SetNumberDeckDraws(oCaster, nDrawsLeft-1);
        if (bNegative) {
            DoDeckDrawNegative(oCaster, nTurn);
        } else {
            DoDeckDrawPositive(oCaster, nTurn);
        }

        // We use this just to space out the card draws
        nTurn++;

        // Flip the negative setting so the next card will
        // be the opposite type
        bNegative = (bNegative + 1) % 2;

        // We have to get this off the caster again because it may have
        // been modified by the card drawn
        nDrawsLeft = GetNumberDeckDraws(oCaster);

    }
}
