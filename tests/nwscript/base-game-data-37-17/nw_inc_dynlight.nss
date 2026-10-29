// Module variable to set latitude. Zero will use default. If you actually want to use Equator, use 0.001 or similar.
const string    NW_DYNAMIC_LIGHT_MODULE_GLOBAL_LATITUDE = "MODULE_GLOBAL_LATITUDE";
const float     NW_DYNAMIC_LIGHT_MODULE_GLOBAL_LATITUDE_DEFAULT = 45.0;

const float     NW_DYNAMIC_LIGHT_GLOBE_ROTATION_AXIAL_TILT = 23.5;
const float     NW_DYNAMIC_LIGHT_MOON_ROTATION_AXIAL_TILT = 5.1;

const float     NW_DYNAMIC_LIGHT_FADE_TIME = 10.0;
const float     NW_DYNAMIC_LIGHT_FADE_TIME_OVERLAP = 2.0;

const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_RED=1.0;
const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_GREEN=0.8;
const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_BLUE=0.6;

const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_DIFFUSE_MODIFIER=1.0;
const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_AMBIENT_MODIFIER=0.1;
const float NW_DYNAMIC_LIGHT_SUN_REDSHIFT_FOG_MODIFIER=0.75;

const string NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR = "NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR";
const string NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR = "NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR";
const string NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR = "NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR";
const string NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT = "NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT";

const string NW_DYNAMIC_LIGHT_RUNNING = "NW_DYNAMIC_LIGHT_RUNNING";

// Minimum azimuth. Necessary to prevent shadow issues.
const float NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET = 30.0;
// Minimum horizontal offset. Necessary to prevent shadow issues.
const float NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET = 5.0;


float dot(vector a, vector b)
{
    return a.x * b.x + a.y * b.y + a.z *  b.z;
}

float saturate(float value)
{
    if(value > 1.0)
        return 1.0;
    if(value < 0.0)
        return 0.0;
    return value;
}

string VectorToString(vector vVector, int nDecimals=2)
{
    string sReturn="";
    int n=0;
    for(;n<3;n++)
    {
        int nFloatLength = 3 + nDecimals;
        float fCompare=10.0;
        float fCoord=0.0;
        switch(n)
        {
            case 0:
                fCoord = vVector.x;
                break;
            case 1:
                fCoord = vVector.y;
                sReturn+=", ";
                break;
            case 2:
                fCoord = vVector.z;
                sReturn+=", ";
                break;
        }

        while(fCoord >= fCompare)
        {
            fCompare*=10.0;
            nFloatLength++;
        }

        sReturn+=FloatToString(fCoord, nFloatLength, nDecimals);
    }
    return sReturn;
}

// Notice: input vectors must be normalized.
vector SphericalInterpolate(vector v0, vector v1, float alpha)
{
    // Cosine of the angle.
    float fCosDeltaAngle = dot(v0, v1);

    // Check for parallel vectors.
    if(fabs(fCosDeltaAngle) > 0.999) return v0;

    // Make orthonormal basis.
    vector vOrthonormal = VectorNormalize(v1 - v0 * fCosDeltaAngle);

    // Desired angle.
    float fInterpolatedAngle = acos(fCosDeltaAngle) * alpha;
    return v0 * cos(fInterpolatedAngle) + vOrthonormal * sin(fInterpolatedAngle);
}


vector IntRGBToVector(int nRGB)
{
    return Vector(
                IntToFloat((nRGB & 0xFF0000)>>16) / 255.0,
                IntToFloat((nRGB & 0x00FF00)>>8) / 255.0,
                IntToFloat(nRGB & 0x0000FF) / 255.0);

}

int VectorRGBToInt(vector vVector)
{
    return (
                (FloatToInt(vVector.x * 255.0 + 0.499) << 16) |
                (FloatToInt(vVector.y * 255.0 + 0.499) << 8) |
                (FloatToInt(vVector.z * 255.0 + 0.499)));
}

void PrintDebugMessage(string sMsg)
{
    /* DEBUG *///PrintString(sMsg);
    /* DEBUG *///SendMessageToPC(GetFirstPC(),sMsg);
}

vector GetSunlightDirectionFromTime(float fLatitude, float fTimeOffset)
{
    float fRelativeTimeOfYear = (HoursToSeconds(((GetCalendarMonth()-1)*28 + (GetCalendarDay()-1)) * 24 + GetTimeHour()) + IntToFloat(GetTimeMinute() * 60 + GetTimeSecond()) + fTimeOffset) /  HoursToSeconds(12 * 28 * 24);
    float fSunVerticalPeakAngle = fLatitude + cos(fRelativeTimeOfYear * 360.0) * NW_DYNAMIC_LIGHT_GLOBE_ROTATION_AXIAL_TILT;

    // Since we have static day/night times, dawn and dusk is always east and west respectively.
    // Apply a small offset to reduce shadow flickering caused by shadows being projected in parallel with geometry.
    vector vSunrise = Vector(cos(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET) * cos(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET), 
                            ( fSunVerticalPeakAngle > 0.0 ? -sin(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET) : sin(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET)) * cos(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET), sin(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET));
    vector vSunset = vSunrise;
    vSunset.x = -vSunset.x;

    vector vNoon = Vector(0.0, -sin(fSunVerticalPeakAngle), cos(fSunVerticalPeakAngle));

    PrintDebugMessage("Sun vertical peak angle: "+FloatToString(fSunVerticalPeakAngle));
    PrintDebugMessage("Sunrise direction: "+VectorToString(vSunrise));
    PrintDebugMessage("Sunset direction: "+VectorToString(vSunset));
    PrintDebugMessage("Sun noon direction: "+VectorToString(vNoon));

    float fRelativeTime = (HoursToSeconds(GetTimeHour()) + IntToFloat( GetTimeMinute() * 60 + GetTimeSecond())+fTimeOffset) / (HoursToSeconds(24));

    fRelativeTime = saturate((fRelativeTime - 0.25) * 2.0);

    if(fRelativeTime>0.5)
    {
        return SphericalInterpolate(vNoon, vSunset, fRelativeTime * 2.0 - 1.0);
    }
    else
    {
        return SphericalInterpolate(vSunrise, vNoon, fRelativeTime * 2.0);
    }
}

// Note: since skyboxes always have a moon, this is intentionally naive.
vector GetMoonlightDirectionFromTime(float fLatitude, float fTimeOffset)
{
    float fRelativeTimeOfYear = (HoursToSeconds(((GetCalendarMonth()-1)*28 + (GetCalendarDay()-1)) * 24 + GetTimeHour()) + IntToFloat(GetTimeMinute() * 60 + GetTimeSecond()) + fTimeOffset) /  HoursToSeconds(12 * 28 * 24);

    float fRelativeTimeOfMonth = (HoursToSeconds(((GetCalendarDay()-1)) * 24 + GetTimeHour()) + IntToFloat(GetTimeMinute() * 60 + GetTimeSecond()) + fTimeOffset) /  HoursToSeconds(12 * 24);

    float fMoonVerticalPeakAngle = fLatitude + cos(fRelativeTimeOfYear * 360.0) * NW_DYNAMIC_LIGHT_GLOBE_ROTATION_AXIAL_TILT + cos(fRelativeTimeOfMonth * 360.0) * NW_DYNAMIC_LIGHT_MOON_ROTATION_AXIAL_TILT;

    // Since we have static day/night times, dawn and dusk is always east and west respectively.
    // Apply a small offset to reduce shadow flickering caused by shadows being projected in parallel with geometry.
    vector vMoonrise = Vector(cos(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET) * cos(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET), 
                            ( fMoonVerticalPeakAngle > 0.0 ? -sin(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET) : sin(NW_DYNAMIC_LIGHT_HORIZONTAL_OFFSET)) * cos(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET), sin(NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET));

    vector vMoonset = vMoonrise;
    vMoonset.x = -vMoonset.x;

    vector vPeak = Vector(0.0, -sin(fMoonVerticalPeakAngle), cos(fMoonVerticalPeakAngle));

    PrintDebugMessage("Moon vertical peak angle: "+FloatToString(fMoonVerticalPeakAngle));
    PrintDebugMessage("Moonrise direction: "+VectorToString(vMoonrise));
    PrintDebugMessage("Moonset direction: "+VectorToString(vMoonset));
    PrintDebugMessage("Moon azimuth peak direction: "+VectorToString(vPeak));

    float fRelativeTime = (HoursToSeconds(GetTimeHour()) + IntToFloat( GetTimeMinute() * 60 + GetTimeSecond())+fTimeOffset) / (HoursToSeconds(24));

    fRelativeTime = saturate((fRelativeTime > 0.5 ? (fRelativeTime - 0.75) : (fRelativeTime+0.25) ) * 2.0);

    PrintDebugMessage("Moonset relative time: "+FloatToString(fRelativeTime));

    // Shift based on time of month for some variation.
    fRelativeTime = 0.5 * fRelativeTime + (0.25 * cos(fRelativeTimeOfMonth*360.0) + 0.5);

    PrintDebugMessage("Moonset relative time shifted: "+FloatToString(fRelativeTime));
    if(fRelativeTime>0.5)
    {
        return SphericalInterpolate(vPeak, vMoonset, fRelativeTime * 2.0 - 1.0);
    }
    else
    {
        return SphericalInterpolate(vMoonrise, vPeak, fRelativeTime * 2.0);
    }
}

vector ApplyRedshiftToColor(vector vColor, float fRedshift)
{
    float fBrightness = (vColor.x + vColor.y + vColor.z) / 3.0;
    if(fBrightness > 0.01)
    {
        vColor = Vector(vColor.x*(NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_RED*fRedshift+(1.0-fRedshift)),vColor.y*(NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_GREEN*fRedshift+(1.0-fRedshift)), vColor.z*(NW_DYNAMIC_LIGHT_SUN_REDSHIFT_COLOR_BLUE*fRedshift+(1.0-fRedshift)));
        // Preserve brightness.
        vColor *= fBrightness / ((vColor.x + vColor.y + vColor.z) / 3.0);

        float fMax = 1.0;
        if(vColor.x > fMax)
            fMax = vColor.x;
        if(vColor.y > fMax)
            fMax = vColor.y;
        if(vColor.z > fMax)
            fMax = vColor.z;

        vColor /= fMax;
    }

    return vColor;
}

void ApplyRedshift(object oArea, float fSunAzimuth, float fFadeTime)
{
    float fRedshift = cos((fSunAzimuth-NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET) / (1.0 - NW_DYNAMIC_LIGHT_AZIMUTH_OFFSET / 90.0)) * 6.0 - 5.0;
    if(fRedshift < 0.0)
        fRedshift = 0.0;

    vector vColorFog = ApplyRedshiftToColor(IntRGBToVector(GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR)),fRedshift * NW_DYNAMIC_LIGHT_SUN_REDSHIFT_FOG_MODIFIER);
    vector vColorAmbient = ApplyRedshiftToColor(IntRGBToVector(GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR)),fRedshift * NW_DYNAMIC_LIGHT_SUN_REDSHIFT_AMBIENT_MODIFIER);
    vector vColorDiffuse = ApplyRedshiftToColor(IntRGBToVector(GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR)),fRedshift * NW_DYNAMIC_LIGHT_SUN_REDSHIFT_DIFFUSE_MODIFIER);

    PrintDebugMessage("Sun dynamic fog color: "+VectorToString(vColorFog));
    PrintDebugMessage("Sun dynamic ambient color: "+VectorToString(vColorAmbient));
    PrintDebugMessage("Sun dynamic diffuse color: "+VectorToString(vColorDiffuse));

    SetFogColor(FOG_TYPE_SUN, VectorRGBToInt(vColorFog), oArea, fFadeTime);
    SetAreaLightColor(AREA_LIGHT_COLOR_SUN_AMBIENT, VectorRGBToInt(vColorAmbient), oArea, fFadeTime);
    SetAreaLightColor(AREA_LIGHT_COLOR_SUN_DIFFUSE, VectorRGBToInt(vColorDiffuse), oArea, fFadeTime);
}

void AutoUpdateLight(int bRecursive)
{
    float fFadeTime = 0.0;
    if(bRecursive)
    {
        if(!GetLocalInt(GetModule(), NW_DYNAMIC_LIGHT_RUNNING))
            return;

        fFadeTime = NW_DYNAMIC_LIGHT_FADE_TIME + NW_DYNAMIC_LIGHT_FADE_TIME_OVERLAP;
    }

    float fGlobalLatitude = GetLocalFloat(GetModule(), NW_DYNAMIC_LIGHT_MODULE_GLOBAL_LATITUDE);

    if(fGlobalLatitude == 0.0)
        fGlobalLatitude = NW_DYNAMIC_LIGHT_MODULE_GLOBAL_LATITUDE_DEFAULT;

    vector vSunDirection = GetSunlightDirectionFromTime(fGlobalLatitude, fFadeTime);
    vector vMoonDirection = GetMoonlightDirectionFromTime(fGlobalLatitude, fFadeTime);

    PrintDebugMessage("Sun direction: "+VectorToString(vSunDirection));
    PrintDebugMessage("Moon direction: "+VectorToString(vMoonDirection));

    object oArea = OBJECT_SELF;
    if(bRecursive)
    {
        oArea = GetArea(GetFirstPC());
    }

    while(oArea != OBJECT_INVALID)
    {
        if(!GetIsAreaInterior(oArea) && GetIsAreaAboveGround(oArea))
        {
            SetAreaLightDirection(AREA_LIGHT_DIRECTION_SUN, vSunDirection, oArea, fFadeTime);
            SetAreaLightDirection(AREA_LIGHT_DIRECTION_MOON, vMoonDirection, oArea, fFadeTime);
            ApplyRedshift(oArea, asin(vSunDirection.z), fFadeTime);
        }
        if(bRecursive)
        {
            oArea = GetArea(GetNextPC());
        }
        else
        {
            oArea = OBJECT_INVALID;
        }
    }
    if(bRecursive)
    {
        DelayCommand(NW_DYNAMIC_LIGHT_FADE_TIME, ExecuteScript("nw_dynlight_recu"));
    }
}

void InitializeAllAreas()
{
    WriteTimestampedLogEntry("Auto area light manager is initializing areas...");
    object oArea = GetFirstArea();
    while(oArea != OBJECT_INVALID)
    {
        if(!GetIsAreaInterior(oArea) && GetIsAreaAboveGround(oArea))
        {
            int nFogColor = GetFogColor(FOG_TYPE_SUN, oArea);
            SetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR, nFogColor);
            int nAmbientColor = GetAreaLightColor(AREA_LIGHT_COLOR_SUN_AMBIENT, oArea);
            SetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR, nAmbientColor);
            int nDiffuseColor = GetAreaLightColor(AREA_LIGHT_COLOR_SUN_DIFFUSE, oArea);
            SetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR, nDiffuseColor);
            string sEventScript = GetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER);
            SetLocalString(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT, sEventScript);
            SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "nw_dynlight_ae");
        }
        oArea = GetNextArea();
    }
}

void ResetAllAreas()
{
    WriteTimestampedLogEntry("Auto area light manager is resetting all areas to initital values...");
    object oArea = GetFirstArea();
    while(oArea != OBJECT_INVALID)
    {
        if(!GetIsAreaInterior(oArea) && GetIsAreaAboveGround(oArea))
        {
            int nFogColor = GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR);
            SetFogColor(FOG_TYPE_SUN, nFogColor, oArea);
            DeleteLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_FOG_COLOR);
            int nAmbientColor = GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR);
            SetAreaLightColor(AREA_LIGHT_COLOR_SUN_AMBIENT, nAmbientColor, oArea);
            DeleteLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_AMBIENT_COLOR);
            int nDiffuseColor = GetLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR);
            SetAreaLightColor(AREA_LIGHT_COLOR_SUN_DIFFUSE, nDiffuseColor, oArea);
            DeleteLocalInt(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_DIFFUSE_COLOR);
            string sEventScript = GetLocalString(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT);
            SetEventScript(oArea,EVENT_SCRIPT_AREA_ON_ENTER, sEventScript);
            DeleteLocalString(oArea, NW_DYNAMIC_LIGHT_ORIGINAL_AREA_ENTER_SCRIPT);
        }
        oArea = GetNextArea();
    }
}


