//:://////////////////////////////////////////////////
//:: X0_I0_DESTROY
/*
Small include library to handle destroying multiple objects
with the same tag. Also has some utility functions for
handling multiple objects with the same tag.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/11/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

string INVISIBLE_OBJECT_RESREF = "plc_invisobj";

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Count all objects in the area with a matching tag
int CountAllObjectsInAreaByTag(string sTag, object oSource=OBJECT_SELF);

// Destroy the nearest object in the source's area by tag
void DestroyNearestObjectByTag(string sTag, object oSource=OBJECT_SELF, float fDelay=0.1);

// Destroy all the objects in the area with a given tag.
// If nLimit is > 0, this will be the maximum number of things
// destroyed with the given tag.
void DestroyObjectsInAreaByTag(string sTag, object oCenter=OBJECT_SELF, int nLimit=0);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Count all objects in the area with a matching tag
int CountAllObjectsInAreaByTag(string sTag, object oSource=OBJECT_SELF)
{
    int nObjects = 0;
    object oObj = GetNearestObjectByTag(sTag, oSource);
    object oSourceArea = GetArea(oSource);
    while (GetIsObjectValid(oObj) && GetArea(oObj) == oSourceArea) {
        nObjects++;
        oObj = GetNearestObjectByTag(sTag, oSource, nObjects+1);
    }
    return nObjects;
}

// Destroy the nearest object in this area by tag
void DestroyNearestObjectByTag(string sTag, object oSource=OBJECT_SELF, float fDelay=0.1)
{
    object oObj = GetNearestObjectByTag(sTag, oSource);
    object oSourceArea = GetArea(oSource);
    if (GetIsObjectValid(oObj) && GetArea(oObj) == oSourceArea)
        DestroyObject(oObj, fDelay);
}

// Destroy all the objects in the area with a given tag.
// If nLimit is > 0, this will be the maximum number of things
// destroyed with the given tag.
void DestroyObjectsInAreaByTag(string sTag, object oCenter=OBJECT_SELF, int nLimit=0)
{
    object oDestroyer = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     INVISIBLE_OBJECT_RESREF,
                                     GetLocation(oCenter));

    int nObjects = CountAllObjectsInAreaByTag(sTag, oDestroyer);
    if (nLimit == 0) {
        nLimit == nObjects;
    }
    int i=0;
    float fDelay=0.0;
    for (i=0; i < nObjects && i < nLimit; i++) {
        fDelay += 0.2;
        AssignCommand(oDestroyer,
                      DestroyNearestObjectByTag(sTag, oDestroyer, fDelay));
    }

    fDelay = 1.0 * nObjects;
    AssignCommand(oDestroyer, DestroyObject(oDestroyer, fDelay));

}


/*
void main() {}
/* */
