//::///////////////////////////////////////////////
//:: Georg's VFX Tool library
//:: x2_inc_toollib
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Advanced VFX functions for XP2 Chapter 3
    and global use


    GZ@2006-02-01: Update to patch 1.67

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-Aug-02
//:://////////////////////////////////////////////

//* ***************************** INTERFACE  *************************************

const int X2_TL_GROUNDTILE_ICE = 426;
const int X2_TL_GROUNDTILE_WATER = 401;
const int X2_TL_GROUNDTILE_GRASS = 402;
const int X2_TL_GROUNDTILE_LAVA_FOUNTAIN = 349; // ugly
const int X2_TL_GROUNDTILE_LAVA = 350;
const int X2_TL_GROUNDTILE_CAVEFLOOR = 406;
const int X2_TL_GROUNDTILE_SEWER_WATER = 461;

// Create a rising or falling pillar with a certain visual effect. Looks cool
// but quite expensive on the graphics engine, so don't get too mad with it
void TLVFXPillar(int nVFX, location lStart, int nIterations=3, float fDelay=0.1f, float fZOffset= 6.0f, float fStepSize = -2.0f );

// change the type of the ground or (by default) sub ground tiles (i.e. water) to the specified type
// Valid values are
// const int X2_TL_GROUNDTILE_ICE = 426;
// const int X2_TL_GROUNDTILE_WATER = 401;
// const int X2_TL_GROUNDTILE_GRASS = 402;
// const int X2_TL_GROUNDTILE_LAVA_FOUNTAIN = 349; // ugly
// const int X2_TL_GROUNDTILE_LAVA = 350;
// const int X2_TL_GROUNDTILE_CAVEFLOOR = 406;
// const int X2_TL_GROUNDTILE_SEWER_WATER = 461;
void TLChangeAreaGroundTiles(object oArea, int nGroundTileConst, int nColumns, int nRows, float fZOffset = -0.4f );
// remove any ground area tiles created with TLChangeAreaGroundTiles in current area
void TLResetAreaGroundTiles(object oArea, int nColumns, int nRows);

// patch 1.67 version of TLResetAreaGroundTiles, auto determines height and width of the area
void TLResetAreaGroundTilesEx(object oArea);

// patch 1.67 version of TLChangeAreaGroundTiles, auto determines height and width of the area
void TLChangeAreaGroundTilesEx(object oArea, int nGroundTileConst, float fZOffset = -0.4f );
//* ***************************** IMPLEMENTATION  *************************************



void TLResetAreaGroundTilesEx(object oArea)
{
    TLResetAreaGroundTiles(oArea, GetAreaSize(AREA_WIDTH), GetAreaSize(AREA_HEIGHT));
}



void TLResetAreaGroundTiles(object oArea, int nColumns, int nRows)
{
    object oTile = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oTile))
    {
        if (GetObjectType(oTile) == OBJECT_TYPE_PLACEABLE && GetTag(oTile) == "x2_tmp_tile")
        {
            SetPlotFlag(oTile,FALSE);
            DestroyObject (oTile);
        }
        oTile = GetNextObjectInArea(oArea);
    }

}

void TLChangeAreaGroundTilesEx(object oArea, int nGroundTileConst, float fZOffset = -0.4f )
{
    TLChangeAreaGroundTiles(oArea, nGroundTileConst, GetAreaSize(AREA_WIDTH), GetAreaSize(AREA_HEIGHT), fZOffset );
}

void TLChangeAreaGroundTiles(object oArea, int nGroundTileConst, int nColumns, int nRows, float fZOffset = -0.4f )
{
    // Author: Brad "Cutscene" Prince
    // * flood area with tiles
    object oTile;
    // * put ice everywhere
    vector vPos;
    vPos.x = 5.0;
    vPos.y = 0.0;
    vPos.z = fZOffset;
    float fFace = 0.0;
    location lLoc;

    // * fill x axis
    int i, j;
    for (i=0 ; i <= nColumns; i++)
    {
        vPos.y = -5.0;
        // fill y
        for (j=0; j <= nRows; j++)
        {
            vPos.y = vPos.y + 10.0;
            lLoc = Location(oArea, vPos, fFace);
            // Ice tile (even though it says water).
            oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc,FALSE, "x2_tmp_tile");
            SetPlotFlag(oTile,TRUE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nGroundTileConst), oTile);
        }
        vPos.x = vPos.x + 10.0;
    }

}

void TLVFXPillar(int nVFX, location lStart, int nIterations=3, float fDelay=0.1f, float fZOffset= 6.0f, float fStepSize = -2.0f )
{
     vector vLoc = GetPositionFromLocation(lStart);
     vector vNew = vLoc;
     vNew.z += fZOffset;
     location lNew;
     int nCount;

     for (nCount=0; nCount < nIterations ; nCount ++)
     {
          lNew = Location(GetAreaFromLocation(lStart),vNew,0.0f);
          if (fDelay > 0.0f)
          {
              DelayCommand(fDelay*nCount, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(nVFX),lNew));
          }
          else
          {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(nVFX),lNew);
          }
          vNew.z += fStepSize;
     }
}




