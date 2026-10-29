//:://////////////////////////////////////////////////
//:: X0_I0_HIGHLIGHT
/*
Small library to generate highlights on objects. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/12/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Apply a highlight effect to an object. Lasts permanently until
// removed. 
// A few good ones, although any VFX_DUR_ effect can be used:
//   VFX_DUR_ETHEREAL_VISAGE: glowing, purple, transparent
//   VFX_DUR_GHOSTLY_VISAGE: glowing, blue, transparent
//   VFX_DUR_BLUR: alternating blue/white pulsing glow
//   VFX_DUR_PARALYZED: alternating red/white pulsing glow
//   VFX_DUR_PROT_SHADOW_ARMOR: shimmery opaque black glow
//   VFX_DUR_MIND_AFFECTING_DOMINATED: spinning crown of lights
//   VFX_DUR_MIND_AFFECTING_DISABLED: crown of sparkling lights
void AddHighlight(object oTarget, int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE);

// Adds a temporary highlight to an object. 
// See comments to AddHighlight for suggested highlight effects.
void AddTemporaryHighlight(object oTarget, int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE, float fDuration = 10.0f);

// Remove the highlight from an object.
// If not specified, removes the last-added highlight, although
// this default behavior will NOT work twice in a row to remove 
// multiple highlights.
void RemoveHighlight(object oTarget, int nVisualEffect=VFX_NONE);

// THIS FUNCTION INTENDED FOR USE IN OnEntered SCRIPT FOR A TRIGGER.
// Add a highlight to the nearest object with the same tag
// as the trigger when a PC enters the trigger area.
// See comments to AddHighlight for suggested highlight effects.
void TriggerAddHighlight(int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE, int nDurationType=DURATION_TYPE_TEMPORARY, float fDuration=10.0f);

// THIS FUNCTION INTENDED FOR USE IN OnExited SCRIPT FOR A TRIGGER.
// Remove the highlight from the nearest object with the same tag
// as the trigger when a PC exits the trigger area.
void TriggerRemoveHighlight(int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE);



/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/


// Apply a highlight effect to an object. Lasts permanently until
// removed. 
// A few good ones, although any VFX_DUR_ effect can be used:
//   VFX_DUR_ETHEREAL_VISAGE: glowing, purple, transparent
//   VFX_DUR_GHOSTLY_VISAGE: glowing, blue, transparent
//   VFX_DUR_BLUR: alternating blue/white pulsing glow
//   VFX_DUR_PARALYZED: alternating red/white pulsing glow
//   VFX_DUR_PROT_SHADOW_ARMOR: shimmery opaque black glow
//   VFX_DUR_MIND_AFFECTING_DOMINATED: spinning crown of lights
//   VFX_DUR_MIND_AFFECTING_DISABLED: crown of sparkling lights
void AddHighlight(object oTarget, int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE)
{
    effect eVis = EffectVisualEffect(nVisualEffect);
    if (GetIsEffectValid(eVis)) {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
        // Record the last perm effect for easy removal purposes
        SetLocalInt(oTarget, "X0_HIGHLIGHT_EFFECT_LAST", nVisualEffect);
    }
}

// Adds a temporary highlight to an object. 
// See comments to AddHighlight for suggested highlight effects.
void AddTemporaryHighlight(object oTarget, int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE, float fDuration = 10.0f)
{
    effect eVis = EffectVisualEffect(nVisualEffect);
    if (GetIsEffectValid(eVis)) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
    }
}


// Remove the highlight from an object.
// If not specified, removes the last-added highlight, although
// this default behavior will NOT work twice in a row to remove 
// multiple highlights.
void RemoveHighlight(object oTarget, int nVisualEffect=VFX_NONE)
{
    int nEffect = nVisualEffect;
    if (nEffect == VFX_NONE) {
        // If none specified, get the last recorded effect
        nEffect = GetLocalInt(oTarget, "X0_HIGHLIGHT_EFFECT_LAST");
    }
    effect eToRemove = EffectVisualEffect(nEffect);
    int nEffectType = GetEffectType(eToRemove);

    // Cycle through the effects on the target, 
    // looking for a matching one to remove.
    effect eCurrent = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eCurrent)) {
        if (GetEffectType(eCurrent) == nEffectType) {
            RemoveEffect(oTarget, eCurrent);
            return;
        }
        eCurrent = GetNextEffect(oTarget);
    }
}


// THIS FUNCTION INTENDED FOR USE IN OnEntered SCRIPT FOR A TRIGGER.
// Add a highlight to the nearest object with the same tag
// as the trigger when a PC enters the trigger area.
// See comments to AddHighlight for suggested highlight effects.
void TriggerAddHighlight(int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE, int nDurationType=DURATION_TYPE_TEMPORARY, float fDuration=10.0f)
{
    if (!GetIsPC(GetEnteringObject())) {return;}
    object oTarget = GetNearestObjectByTag(GetTag(OBJECT_SELF));
    if (nDurationType == DURATION_TYPE_PERMANENT) {
        AddHighlight(oTarget, nVisualEffect);
    } else {
        AddTemporaryHighlight(oTarget, nVisualEffect, fDuration);
    }
    SetLocalInt(oTarget, "IS_HIGHLIGHTED", TRUE);
}


// THIS FUNCTION INTENDED FOR USE IN OnExited SCRIPT FOR A TRIGGER.
// Remove the highlight from the nearest object with the same tag
// as the trigger when a PC exits the trigger area.
void TriggerRemoveHighlight(int nVisualEffect=VFX_DUR_ETHEREAL_VISAGE)
{
    object oTarget = GetNearestObjectByTag(GetTag(OBJECT_SELF));
    if (!GetLocalInt(oTarget, "IS_HIGHLIGHTED") || !GetIsPC(GetExitingObject())) {
        return;
    }

    RemoveHighlight(oTarget, nVisualEffect);
}


/* 
void main()
{
}
/* */
