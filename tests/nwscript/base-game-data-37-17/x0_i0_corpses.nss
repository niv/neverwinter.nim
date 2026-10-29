//:://////////////////////////////////////////////////
//:: X0_I0_CORPSES
/*
  Include library for creating corpses, blowing things
  up, etc. Always a good time.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////

// We use this library to get positions to drop things at
#include "x0_i0_position"

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// This blueprint is necessary for lootable corpses.
// It is an invisible object with inventory, named "Corpse"
string sCorpseResRef = "x0_plc_corpse";

// This blueprint is necessary for exploding corpses.
// It is an invisible, non-static object, named "Corpse"
string sBombResRef = "x0_plc_bomb";

// Time delay in seconds before decaying corpses vanish
float CORPSE_DECAY_TIME = 120.0f;

// Time delay in seconds before exploding corpses blow up
float CORPSE_EXPLODE_TIME = 2.0f;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Convenience function to set another object destroyable
void SetObjectIsDestroyable(object oVictim, int bCanDestroy, int bCanRaise=TRUE, int bCanSelect=FALSE);


// Loot all the droppable items from the inventory slots of the
// victim into the inventory of the corpse object.
// If bDropWielded is TRUE, the items the victim is wielding in
// its right and left hands will be dropped to either side
// of it, otherwise they will simply be placed into inventory.
void LootInventorySlots(object oVictim, object oCorpse, int bDecay=TRUE, int bDropWielded=TRUE);

// Strip everything droppable in the regular inventory.
// Use LootInventorySlots to strip equipped items.
void LootInventory(object oVictim, object oCorpse);

// Die young, leave a lootable corpse. (ha ha ha... okay, been working too long)
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
// If bDecay is TRUE, the corpse will decay to a bag after a brief delay.
// If bDropWielded is TRUE, the corpse will drop its right/left hand items
// to either side (making the body more decorative, but the items harder
// to see).
void KillAndReplaceLootable(object oVictim, int bDecay=TRUE, int bDropWielded=TRUE);

// Kill and leave a decorative corpse that will decay
// after a short while.
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
void KillAndReplaceDecay(object oVictim);

// Kill and leave a raiseable & selectable corpse
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
void KillAndReplaceRaiseable(object oVictim);

// Kill and leave a corpse with the corpse's name
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
void KillAndReplaceSelectable(object oVictim);

// Kill and leave a purely decorative corpse (no name,
// not raiseable).
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
void KillAndReplaceDecorative(object oVictim);

// Kill and leave an exploding corpse
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
// Any spell can be used.
void KillAndExplode(object oVictim, int nSpell=SPELL_FIREBALL);

// Blow up an object with the given spell (actually
// casts the spell, injuring those around the object)
void ExplodeObject(object oOrigin, int nSpell=SPELL_FIREBALL);

// Blow up the nearest object with a matching tag with the specified
// spell.
// This should be called by the trigger object! It ASSUMES
// that GetEnteringObject() will work for OBJECT_SELF here.
// This destroys the trigger after it is successfully invoked
// by the PC.
void TriggerExplodeObject(int nSpell=SPELL_FIREBALL);

// Raise a given corpse from the dead with given visual effect.
// Unless bDestroyable is set to FALSE, the newly-raised corpse will
// be changed so it will be destroyed on its next death.
void RaiseCorpse(object oVictim, int nVisualEffect = VFX_IMP_RAISE_DEAD, int bDestroyable=TRUE);

// Return the nearest corpse object
object GetNearestCorpse(object oSource = OBJECT_SELF);

// Raise the nearest corpse from the dead.
// This should be called by the trigger object! It ASSUMES
// that GetEnteringObject() will work for OBJECT_SELF here.
void TriggerRaiseCorpse(int nVisualEffect=VFX_IMP_RAISE_DEAD);



/**********************************************************************
 * **PRIVATE** FUNCTION DEFINITIONS
 *
 * These functions are deliberately not prototyped and are only
 * intended for use internal to this library. Do not use outside!
 **********************************************************************/

// Actually kill off a victim, regardless of plot flag.
void DoActualKilling(object oVictim)
{
    if (!GetIsDead(oVictim)) {
        SetPlotFlag(oVictim, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oVictim);
    }
}


// This function is used to determine if the victim is the type
// of creature that "wears" its clothing, so we don't strip them
// naked.
int GetIsVictimDressed(object oVictim)
{
    int nAppearance = GetAppearanceType(oVictim);
    switch (nAppearance) {
    case APPEARANCE_TYPE_DWARF:
    case APPEARANCE_TYPE_ELF:
    case APPEARANCE_TYPE_GNOME:
    case APPEARANCE_TYPE_HALF_ELF:
    case APPEARANCE_TYPE_HALF_ORC:
    case APPEARANCE_TYPE_HALFLING:
    case APPEARANCE_TYPE_HUMAN:
        return TRUE;
    }

    return FALSE;
}

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/
// * convenience function for copying objects properly
void CopyItem2(object oSource, object oInventory)
{
                int bWasPlot = GetPlotFlag(oSource);
                object oNewItem = CopyItem(oSource, oInventory);
                if (bWasPlot == TRUE)
                {
                    SetPlotFlag(oNewItem,TRUE);
                }

}


// Convenience function to set another object destroyable
void SetObjectIsDestroyable(object oVictim, int bCanDestroy,
                          int bCanRaise=TRUE, int bCanSelect=FALSE)
{
    AssignCommand(oVictim, SetIsDestroyable(bCanDestroy, bCanRaise, bCanSelect));
}


// If bDropWielded is TRUE, the items the victim is wielding in
// its right and left hands will be dropped to either side
// of it, otherwise they will simply be placed into inventory.
void LootInventorySlots(object oVictim, object oCorpse, int bDecay=TRUE, 
                        int bDropWielded=TRUE)
{
    int i=0;
    object oItem = OBJECT_INVALID;
    location locItem;


    int bWasPlot = FALSE;
    
    for (i=0; i < NUM_INVENTORY_SLOTS; i++) {
        oItem = GetItemInSlot(i, oVictim);

        // See if we're going to allow looting of this item.
        if (GetIsObjectValid(oItem) && GetDroppableFlag(oItem)) {
            // Handle different items slightly differently.

            if (i == INVENTORY_SLOT_CHEST && GetIsVictimDressed(oVictim)) {
                // The victim is wearing the armor. We don't want to destroy
                // it while the corpse is around, since that would leave the
                // body naked.
                CopyItem2(oItem, oCorpse);
                if (bDecay) {
                    // Destroy after we destroy the corpse.
                    DestroyObject(oItem, CORPSE_DECAY_TIME+1.0);
                }

            } else if (i == INVENTORY_SLOT_RIGHTHAND && bDropWielded) {
                // This is a wielded item. Drop it nearby.
                locItem = GetStepRightLocation(oVictim);
                CreateObject(OBJECT_TYPE_ITEM, GetResRef(oItem), locItem);
                DestroyObject(oItem, 0.1);

            } else if (i == INVENTORY_SLOT_LEFTHAND && bDropWielded) {
                // This is a wielded item. Drop it nearby.
                locItem = GetStepLeftLocation(oVictim);
                CreateObject(OBJECT_TYPE_ITEM, GetResRef(oItem), locItem);
                DestroyObject(oItem, 0.1);

            } else
            {
                CopyItem2(oItem, oCorpse);
                DestroyObject(oItem, 0.1);
            }
        }
    }
}

// Strip everything droppable in the regular inventory, too.
void LootInventory(object oVictim, object oCorpse)
{
    object oItem = GetFirstItemInInventory(oVictim);
    while (GetIsObjectValid(oItem)) {
        if (GetDroppableFlag(oItem)) {
            // Copy to the corpse and destroy
            CopyItem2(oItem, oCorpse);
            DestroyObject(oItem, 0.1);
        }
        oItem = GetNextItemInInventory(oVictim);
    }
}


// If bDecay is TRUE, the corpse will decay to a bag after a brief delay.
// If bDropWielded is TRUE, the corpse will drop its right/left hand items
// to either side (making the body more decorative, but the items harder
// to see).
void KillAndReplaceLootable(object oVictim, int bDecay=TRUE, int bDropWielded=TRUE)
{
    if (bDecay) {
        KillAndReplaceDecay(oVictim);
    } else {
        KillAndReplaceDecorative(oVictim);
    }

    // Create the "corpse" placeholder
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  sCorpseResRef,
                                  GetLocation(oVictim));

    // Put everything lootable from the victim into the placeholder
    LootInventorySlots(oVictim, oCorpse, bDecay, bDropWielded);
    LootInventory(oVictim, oCorpse);

    // If we're decaying, destroy the 'corpse' object too,
    // which will drop its contents in the standard "bag" form
    if (bDecay)  {
        DelayCommand(CORPSE_DECAY_TIME, SetPlotFlag(oCorpse, FALSE));
        DestroyObject(oCorpse, CORPSE_DECAY_TIME);
    }

}


// Kill and leave a decorative corpse that will decay
// after a short while.
void KillAndReplaceDecay(object oVictim)
{
    KillAndReplaceDecorative(oVictim);
    DelayCommand(CORPSE_DECAY_TIME, SetObjectIsDestroyable(oVictim, TRUE));
    DestroyObject(oVictim, CORPSE_DECAY_TIME+0.2);
}

// Kill and leave a raiseable & selectable corpse
void KillAndReplaceRaiseable(object oVictim)
{
    SetObjectIsDestroyable(oVictim, FALSE, TRUE, TRUE);
    DoActualKilling(oVictim);
}

// Kill and leave a corpse with the corpse's name
void KillAndReplaceSelectable(object oVictim)
{
    SetObjectIsDestroyable(oVictim, FALSE, FALSE, TRUE);
    DoActualKilling(oVictim);
}

// Kill and leave a purely decorative corpse (no name,
// not raiseable).
void KillAndReplaceDecorative(object oVictim)
{
    SetObjectIsDestroyable(oVictim, FALSE, FALSE);
    DoActualKilling(oVictim);
}

// Kill and leave an exploding corpse
// Despite the name, can be used in an OnDeath script;
// it won't kill the victim twice.
// Any spell can be used.
void KillAndExplode(object oVictim, int nSpell=SPELL_FIREBALL)
{
    KillAndReplaceDecorative(oVictim);

    DelayCommand(CORPSE_EXPLODE_TIME, SetObjectIsDestroyable(oVictim, TRUE));
    DelayCommand(CORPSE_EXPLODE_TIME, ExplodeObject(oVictim, nSpell));
}

// Blow up an object with the given spell (actually
// casts the spell, injuring those around the object)
void ExplodeObject(object oOrigin, int nSpell=SPELL_FIREBALL)
{
    // Create the 'bomb' object
    object oBomb = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  sBombResRef,
                                  GetLocation(oOrigin));

    location locOrigin = GetLocation(oOrigin);

    AssignCommand(oBomb,
                  DelayCommand(0.5,
                        ActionCastSpellAtLocation(nSpell,
                                                  locOrigin,
                                                  METAMAGIC_ANY,
                                                  TRUE,
                                                  PROJECTILE_PATH_TYPE_DEFAULT,
                                                  TRUE)));

    // Destroy the origin spectacularly
    if (!GetIsDead(oOrigin)) {
        DelayCommand(0.1, DoActualKilling(oOrigin));
    } else {
        DestroyObject(oOrigin, 0.1);
    }

    // Destroy the bomb
    DestroyObject(oBomb, 7.0);
}

// Blow up the nearest object with a matching tag,
// using the specified spell.
void TriggerExplodeObject(int nSpell=SPELL_FIREBALL)
{
    object oPC = GetEnteringObject();
    if ( ! GetIsPC(oPC) ) { return; }
    object oOrigin = GetNearestObjectByTag(GetTag(OBJECT_SELF));
    ExplodeObject(oOrigin, nSpell);
    DestroyObject(OBJECT_SELF, 5.0);
}


// Raise a given corpse from the dead with given visual effect.
// Unless bDestroyable is set to FALSE, the newly-raised corpse will
// be changed so it will be destroyed on its next death.
void RaiseCorpse(object oVictim, int nVisualEffect = VFX_IMP_RAISE_DEAD, int bDestroyable=TRUE)
{
    effect eVis = EffectVisualEffect(nVisualEffect);
    effect eResur = EffectResurrection();
    effect eHeal = EffectHeal(GetMaxHitPoints(oVictim));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oVictim);
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eResur, oVictim));
    DelayCommand(0.7, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oVictim));

    if (bDestroyable)
        DelayCommand(0.9,SetObjectIsDestroyable(oVictim, TRUE));
}

// Return the nearest corpse object
object GetNearestCorpse(object oSource = OBJECT_SELF)
{
        return GetNearestCreature(CREATURE_TYPE_IS_ALIVE, FALSE,
                                  oSource);

/*
    February 2003: Old workaround, no longer needed
   int nNth = 1;
    object oCorpse = GetNearestObject(OBJECT_TYPE_CREATURE, oSource);
    while (GetIsObjectValid(oCorpse)
        && !GetIsDead(oCorpse)
        && GetArea(oCorpse) == GetArea(oSource))
    {
        nNth++;
        oCorpse = GetNearestObject(OBJECT_TYPE_CREATURE, oSource, nNth);
    }
    if (GetArea(oCorpse) != GetArea(oSource))
        return OBJECT_INVALID;

    return oCorpse;    */
}

// Raise the nearest corpse from the dead.
// This should be called by the trigger object! It ASSUMES
// that GetEnteringObject() will work for OBJECT_SELF here.
void TriggerRaiseCorpse(int nVisualEffect=VFX_IMP_RAISE_DEAD)
{
    object oPC = GetEnteringObject();
    if ( ! GetIsPC(oPC) ) { return; }
    object oCorpse = GetNearestCorpse();
    RaiseCorpse(oCorpse, nVisualEffect);
    DestroyObject(OBJECT_SELF, 5.0);
}



/* Just for testing, don't close this comment.
void main() {}
/* */
