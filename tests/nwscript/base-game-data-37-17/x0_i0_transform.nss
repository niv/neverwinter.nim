//:://////////////////////////////////////////////////
//:: X0_I0_TRANSFORM
/*
  SUMMARY:
  Small include library for "transforming" objects -- ie,
  placeables that 'transform' into a creature, like
  the skeleton bones object.

  //-----------------------------------------------------//

  CHANGE: 12/7/2002 -- added similar functions for 
  transforming objects into placeables, and made the
  functions more generic. 

  //-----------------------------------------------------//

  INITIAL: 12/6/2002

  This system will actually work on any object, not just a 
  placeable -- creatures can easily be transformed into other
  creatures, for instance. 

  For efficiency's sake, we don't want to do this with an
  OnHeartbeat script. It's much better to instead have a 
  trigger nearby with the same tag as the placeable
  that triggers the changeover when a PC enters it, then 
  destroys itself. 

  To set up one of these: 

  - Put down the placeable (or creature) that you want to have
    transformed. 

  - Give this object a unique tag, say "TRANSFORM_ORIGIN_FOR_BALOR" 
    or some such. 

  - Put down a generic trigger and give it the same exact tag
    as the origin object. Remember, tags are cAsE-sEnSiTive!

  - Create a unique script for the generic trigger object's
    OnEntered handler and paste in the code below between the 
    "CUT HERE" lines.

  - Replace "resref_of_creature_here" with the ResRef value 
    of the creature you want to create. (See the NWN Lexicon
    for a very convenient list of these blueprints. URL:

          http://www.reapers.org/nwn/reference/ 

    at the time of this script creation.)
    
  - You can also change "VFX_IMP_DISPEL" to any IMP/FNF effect
    constant you like, and that effect will be applied when 
    the transform happens. You can also remove that argument
    completely if you don't want any effect applied.

  - That's it!

// ---- CUT HERE ----

// Manually uncomment this next line after cutting &
// pasting -- it has to be commented out because of
// a compiler bug.
//  #include "x0_i0_transform"

  void main()
  {
      TriggerObjectTransform("resref_of_creature_here", VFX_IMP_DISPEL);
  }

// ---- CUT HERE ---- 
  
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/05/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

string sItemResrefSuffix = "_i";
string sItemPickupSoundResref = "it_genericsmall";

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Wrapper around CreateObject.
// This also optionally takes a direction to face.
void ActionCreateObject(string sResRef, location lLoc, float fDir=361.0, int nObjType=OBJECT_TYPE_CREATURE);

// Transform one object into another, using the specified visual effect
// (if any) at the original object's location.
void TransformObject(object oOrigin, string sNewObjResRef, int nVisualEffect=VFX_NONE, int nNewObjType=OBJECT_TYPE_CREATURE);

// ** See comments at the top of x0_i0_transform for usage advice. **
// 
// Transform the given object into the creature of the specified type,
// using the specified visual effect (if any) at the object location.
// Some nice effects that work well:
//          VFX_IMP_RAISE_DEAD, VFX_IMP_DISPEL, VFX_FNF_SUMMON_MONSTER_2
//
// Any VFX_IMP or VFX_FNF constant should work.  
void TransformObjectToCreature(object oOrigin, string sCreature, int nVisualEffect=VFX_NONE);

// Transform the given object into the placeable of the specified type,
// using the specified visual effect (if any) at the object location.
// Works largely like TransformObjectToCreature, see comments for that.
void TransformObjectToPlaceable(object oOrigin, string sPlaceable, int nVisualEffect=VFX_NONE);

// Trigger the nearest object with matching tag to convert.
// This should be called by the trigger object! It ASSUMES
// that GetEnteringObject() will work for OBJECT_SELF here.
// This destroys the trigger after it is successfully invoked
// by the PC.
void TriggerObjectTransform(string sCreature, int nVisualEffect=VFX_NONE);

// This causes an object to be transformed into an item.
// This is useful for special placeables, 
// where you want to be able to leave an "item" lying around
// on the ground that doesn't look like a bag but still can be
// picked up (without creating a new base item type).
void TransformObjectToItem(object oOrigin, string sItem, object oInventory=OBJECT_INVALID);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Private convenience function -- 
object GetNearestSeenEnemyForTransform(object oSource)
{
    return (GetNearestCreature(CREATURE_TYPE_REPUTATION, 
                               REPUTATION_TYPE_ENEMY, 
                               oSource, 1, 
                               CREATURE_TYPE_PERCEPTION, 
                               PERCEPTION_SEEN));
}


// Wrapper around CreateObject.
// This also optionally takes a direction to face.
// If the object created is a creature, a check for enemies will
// be done so it will attack properly.
void ActionCreateObject(string sResRef, location lLoc, float fDir=361.0, int nObjType=OBJECT_TYPE_CREATURE)
{
    object oObj = CreateObject(nObjType, sResRef, lLoc);
    if (fDir != 361.0) 
        DelayCommand(0.1, AssignCommand(oObj, SetFacing(fDir)));

    if (nObjType == OBJECT_TYPE_CREATURE) {
        object oEnemy = GetNearestSeenEnemyForTransform(oObj);
        if (GetIsObjectValid(oEnemy)) { 
            DelayCommand(0.4, AssignCommand(oObj, ClearAllActions()));
            DelayCommand(0.5, AssignCommand(oObj, ActionAttack(oEnemy)));
        }
    }
}


// Transform one object into another, using the specified visual effect
// (if any) at the original object's location.
void TransformObject(object oOrigin, string sNewObjResRef, int nVisualEffect=VFX_NONE, int nNewObjType=OBJECT_TYPE_CREATURE)
{
    if (GetIsObjectValid(oOrigin) && !GetLocalInt(oOrigin, "I_AM_TRANSFORMED") )
    {
        SetLocalInt(oOrigin, "I_AM_TRANSFORMED", TRUE);
            location lLoc = GetLocation(oOrigin);
        if (nVisualEffect != VFX_NONE) {
            effect eVis = EffectVisualEffect(nVisualEffect);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLoc, 2.0);
        }

        // Create the new object, facing the same way as the origin object
        DelayCommand(0.3, 
                     ActionCreateObject(sNewObjResRef, lLoc, 
                                        GetFacing(oOrigin), nNewObjType));

        // Destroy the origin
        SetPlotFlag(oOrigin, FALSE);
        DelayCommand(0.5, DestroyObject(oOrigin));
    }
}

// Transform the given object into the creature of the specified type,
// using the specified visual effect (if any) at the placeable location.
void TransformObjectToCreature(object oOrigin, string sCreature, int nVisualEffect=VFX_NONE)
{
    TransformObject(oOrigin, sCreature, nVisualEffect);
}

// Transform the given object into the placeable of the specified type,
// using the specified visual effect (if any) at the object location.
// Works largely like TransformObjectToCreature, see comments for that.
void TransformObjectToPlaceable(object oOrigin, string sPlaceable, int nVisualEffect=VFX_NONE)
{
    TransformObject(oOrigin, sPlaceable, nVisualEffect, OBJECT_TYPE_PLACEABLE);    
}


// Trigger the nearest object with matching tag to convert.
// This should be called by the trigger object! It ASSUMES
// that GetEnteringObject() will work for OBJECT_SELF here.
void TriggerObjectTransform(string sCreature, int nVisualEffect=VFX_NONE)
{
    object oPC = GetEnteringObject();
    if ( ! GetIsPC(oPC) ) { return; }
    object oOrigin = GetNearestObjectByTag(GetTag(OBJECT_SELF));
    TransformObjectToCreature(oOrigin, sCreature, nVisualEffect);
    DestroyObject(OBJECT_SELF, 5.0);
}


// This causes an object to be transformed into an item in the
// specified inventory.
// This is useful for special placeables, 
// where you want to be able to leave an "item" lying around
// on the ground that doesn't look like a bag but still can be
// picked up (without creating a new base item type).
//
// This function would go in the "OnUsed" script for the
// placeable, like this:
// 
// TransformObjectToItem(OBJECT_SELF, "blueprint of item", GetLastUsedBy());
//
// If you leave the blueprint blank, the function will attempt to
// use a blueprint formed by taking the resref of the origin and 
// tacking on "_i" -- so if you have a placeable called "hobbyhorse",
// and you make an item with a blueprint "hobbyhorse_i", just use the
// script "x0_o2_pickup" as the OnUsed of the hobbyhorse placeable.
// 
void TransformObjectToItem(object oOrigin, string sItem="", object oInventory=OBJECT_INVALID)
{
    if (sItem == "") 
        sItem = GetResRef(oOrigin) + sItemResrefSuffix;

    vector vOrig = GetPosition(oOrigin);

    if (vOrig.z == 0.0) {
        // The placeable is on the ground, bend down to get it
        AssignCommand(oInventory, 
                      ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
                                          1.0,
                                          2.0));
    } else {
        AssignCommand(oInventory, 
                      ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,
                                          1.0,
                                          2.0));
    }

    // Play a small sound for feedback
    PlaySound(sItemPickupSoundResref);
    object oItem = CreateItemOnObject(sItem, oInventory);
    DestroyObject(oOrigin, 0.1);
}


/* 
void main() 
{
}
/* */
