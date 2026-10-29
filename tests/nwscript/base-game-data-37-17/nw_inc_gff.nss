// This is a helper library for advanced use: It allows constructing arbitrary gff data.
// You can then spawn your object via JsonToObject().
//
// The data format is the same as https://github.com/niv/neverwinter.nim@1.4.3+.
//
// Example:
//
// json j = GffCreateObject(OBJECT_TYPE_ITEM);
// j = GffAddInt(j, "BaseItem", BASE_ITEM_BELT);
// j = GffAddInt(j, "ModelPart1", 12);
// j = GffAddLocString(j, "LocalizedName", "hi!");
// object belt = JsonToObject(j, GetLocation(OBJECT_SELF));


const string GFF_FIELD_TYPE_STRUCT      = "struct";
const string GFF_FIELD_TYPE_LIST        = "list";
const string GFF_FIELD_TYPE_BYTE        = "byte";
const string GFF_FIELD_TYPE_CHAR        = "char";
const string GFF_FIELD_TYPE_WORD        = "word";
const string GFF_FIELD_TYPE_SHORT       = "short";
const string GFF_FIELD_TYPE_DWORD       = "dword";
const string GFF_FIELD_TYPE_INT         = "int";
const string GFF_FIELD_TYPE_DWORD64     = "dword64";
const string GFF_FIELD_TYPE_INT64       = "int64";
const string GFF_FIELD_TYPE_FLOAT       = "float";
const string GFF_FIELD_TYPE_DOUBLE      = "double";
const string GFF_FIELD_TYPE_RESREF      = "resref";
const string GFF_FIELD_TYPE_STRING      = "cexostring";
const string GFF_FIELD_TYPE_LOC_STRING  = "cexolocstring";


// Create a empty object of the given type. You need to manually fill in all
// GFF data with GffAddXXX. This will require understanding of the GFF file format
// and what data fields each object type requires.
json GffCreateObject(int nObjectType);
// Create a combined area format(CAF) object. You need to manually create the ARE and GIT objects with their required data fields.
json GffCreateArea(json jARE, json jGIT);

// Returns the OBJECT_TYPE_* of jGff.
// Note: Will return 0 for invalid object types, including areas.
int GffGetObjectType(json jGff);
// Returns TRUE if jGff is a combined area format(CAF) object.
int GffGetIsArea(json jGff);

// Returns TRUE if a field named sLabel of sType exists in jGff.
// * sLabel: Can be a json pointer(path) without the starting /, see the documentation of JsonPointer() for details.
// * sType: An optional GFF_FIELD_TYPE_*, leave empty to check if sLabel exists regardless of type.
int GffGetFieldExists(json jGff, string sLabel, string sType = "");


// Add a new field, will overwrite any existing fields with the same label even if the type is different.
// Returns a json null value on error with GetJsonError() filled in.
//
// sLabel can be a json pointer(path) without the starting /, see the documentation of JsonPointer() for details.
// For example, to add the tag of an area to an empty combined area format(CAF) object you can do the following:
//   json jArea = GffCreateArea(JsonObject(), JsonObject());
//   jArea = GffAddString(jArea, "ARE/value/Tag", "AREA_TAG");

json GffAddStruct(json jGff, string sLabel, json jStruct, int nType = -1);
json GffAddList(json jGff, string sLabel, json jList);
json GffAddByte(json jGff, string sLabel, int v);
json GffAddChar(json jGff, string sLabel, int v);
json GffAddWord(json jGff, string sLabel, int v);
json GffAddShort(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffAddDword(json jGff, string sLabel, int v);
json GffAddInt(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffAddDword64(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffAddInt64(json jGff, string sLabel, int v);
json GffAddFloat(json jGff, string sLabel, float v);
// Note: Only data of type float will fit, because that's all that NWScript supports.
json GffAddDouble(json jGff, string sLabel, float v);
json GffAddResRef(json jGff, string sLabel, string v);
json GffAddString(json jGff, string sLabel, string v);
json GffAddLocString(json jGff, string sLabel, string v, int nStrRef = -1);


// Replace a field, the type must match and the field must exist.
// Returns a json null value on error with GetJsonError() filled in.
//
// sLabel can be a json pointer(path) without the starting /, see the documentation of JsonPointer() for details.
// For example, to replace the name of an area in a combined area format(CAF) object you can do the following:
//   json jArea = ObjectToStruct(GetFirstArea());
//   jArea = GffReplaceLocString(jArea, "ARE/value/Name", "New Area Name");

json GffReplaceStruct(json jGff, string sLabel, json jStruct);
json GffReplaceList(json jGff, string sLabel, json jList);
json GffReplaceByte(json jGff, string sLabel, int v);
json GffReplaceChar(json jGff, string sLabel, int v);
json GffReplaceWord(json jGff, string sLabel, int v);
json GffReplaceShort(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffReplaceDword(json jGff, string sLabel, int v);
json GffReplaceInt(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffReplaceDword64(json jGff, string sLabel, int v);
// Note: Only data of type int32 will fit, because that's all that NWScript supports.
json GffReplaceInt64(json jGff, string sLabel, int v);
json GffReplaceFloat(json jGff, string sLabel, float v);
// Note: Only data of type float will fit, because that's all that NWScript supports.
json GffReplaceDouble(json jGff, string sLabel, float v);
json GffReplaceResRef(json jGff, string sLabel, string v);
json GffReplaceString(json jGff, string sLabel, string v);
json GffReplaceLocString(json jGff, string sLabel, string v, int nStrRef = -1);


// Remove a field, the type must match and the field must exist.
// Returns a json null value on error with GetJsonError() filled in.
//
// sLabel can be a json pointer(path) without the starting /, see the documentation of JsonPointer() for details.
// For example, to remove all placeables from an area in a combined area format(CAF) object you can do the following:
//   json jArea = ObjectToStruct(GetFirstArea());
//   jArea = GffRemoveList(jArea, "GIT/value/Placeable List");

json GffRemoveStruct(json jGff, string sLabel);
json GffRemoveList(json jGff, string sLabel);
json GffRemoveByte(json jGff, string sLabel);
json GffRemoveChar(json jGff, string sLabel);
json GffRemoveWord(json jGff, string sLabel);
json GffRemoveShort(json jGff, string sLabel);
json GffRemoveDword(json jGff, string sLabel);
json GffRemoveInt(json jGff, string sLabel);
json GffRemoveDword64(json jGff, string sLabel);
json GffRemoveInt64(json jGff, string sLabel);
json GffRemoveFloat(json jGff, string sLabel);
json GffRemoveDouble(json jGff, string sLabel);
json GffRemoveResRef(json jGff, string sLabel);
json GffRemoveString(json jGff, string sLabel);
json GffRemoveLocString(json jGff, string sLabel);


// Get a field's value as json object.
// Returns a json null value on error with GetJsonError() filled in.
//
// Note: Json types do not implicitly convert between types, this means you cannot convert a JsonInt to a string with JsonGetString(), etc.
//       You may need to check the type with JsonGetType() and then do the appropriate cast yourself.
//       For GffGet*() functions the json type returned is noted in the function description.
//
//       Example:
//         INCORRECT: string s = JsonGetString(GffGetInt());
//         CORRECT:   string s = IntToString(JsonGetInt(GffGetInt()));
//
// sLabel can be a json pointer(path) without the starting /, see the documentation of JsonPointer() for details.
// For example, to get the resref of an area in a combined area format(CAF) object you can do the following:
//   json jResRef = GffGetResRef(ObjectToStruct(GetFirstArea()), "ARE/value/ResRef");
//   if (jResRef != JsonNull())
//   {
//       string sResRef = JsonGetString(jResRef);
//   }
//   else
//       WriteTimestampedLogEntry("Failed to get area ResRef: " + JsonGetError(jResRef));

// Returns the struct as JsonObject() on success.
json GffGetStruct(json jGff, string sLabel);
// Returns a JsonArray() with all the list elements on success.
json GffGetList(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetByte(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetChar(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetWord(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetShort(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetDword(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetInt(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetDword64(json jGff, string sLabel);
// Returns a JsonInt() on success.
json GffGetInt64(json jGff, string sLabel);
// Returns a JsonFloat() on success.
json GffGetFloat(json jGff, string sLabel);
// Returns a JsonFloat() on success.
json GffGetDouble(json jGff, string sLabel);
// Returns a JsonString() on success.
json GffGetResRef(json jGff, string sLabel);
// Returns a JsonString() on success.
json GffGetString(json jGff, string sLabel);
// Returns a JsonObject() on success.
//   Key "0" will have a JsonString() with the string, if set.
//   Key "id" will have a JsonInt() with the strref, if set.
json GffGetLocString(json jGff, string sLabel);


// *** Internal Helper Functions
json AddPatchOperation(json jPatchArray, string sOp, string sPath, json jValue)
{
    json jOperation = JsonObject();
    jOperation = JsonObjectSet(jOperation, "op", JsonString(sOp));
    jOperation = JsonObjectSet(jOperation, "path", JsonString(sPath));
    jOperation = JsonObjectSet(jOperation, "value", jValue);
    return JsonArrayInsert(jPatchArray, jOperation);
}

json GffAddField(json jGff, string sLabel, string sType, json jValue, int nType = -1)
{
    json jField = JsonObject();
    jField = JsonObjectSet(jField, "type", JsonString(sType));
    jField = JsonObjectSet(jField, "value", jValue);
    if (sType == GFF_FIELD_TYPE_STRUCT && nType != -1)
        jField = JsonObjectSet(jField, "__struct_id", JsonInt(nType));

    return JsonPatch(jGff, AddPatchOperation(JsonArray(), "add", "/" + sLabel, jField));
}

json GffReplaceField(json jGff, string sLabel, string sType, json jValue)
{
    json jPatch = JsonArray();
    jPatch = AddPatchOperation(jPatch, "test", "/" + sLabel + "/type", JsonString(sType));
    jPatch = AddPatchOperation(jPatch, "replace", "/" + sLabel + "/value", jValue);
    return JsonPatch(jGff, jPatch);
}

json GffRemoveField(json jGff, string sLabel, string sType)
{
    json jPatch = JsonArray();
    jPatch = AddPatchOperation(jPatch, "test", "/" + sLabel + "/type", JsonString(sType));
    jPatch = AddPatchOperation(jPatch, "remove", "/" + sLabel, JsonNull());
    return JsonPatch(jGff, jPatch);
}

json GffGetFieldType(json jGff, string sLabel)
{
    return JsonPointer(jGff, "/" + sLabel + "/type");
}

json GffGetFieldValue(json jGff, string sLabel)
{
    return JsonPointer(jGff, "/" + sLabel + "/value");
}

json GffGetField(json jGff, string sLabel, string sType)
{
    json jType = GffGetFieldType(jGff, sLabel);
    if (jType == JsonNull())
        return jType;
    else if (jType != JsonString(sType))
        return JsonNull("field type does not match");
    else
        return GffGetFieldValue(jGff, sLabel);
}

json GffLocString(string v, int nStrRef = -1)
{
    json jLocString = JsonObject();
    if (v != "")
        jLocString = JsonObjectSet(jLocString, "0", JsonString(v)); // english/any
    if (nStrRef != -1)
        jLocString = JsonObjectSet(jLocString, "id", JsonInt(nStrRef));

    return jLocString;
}
//***

json GffCreateObject(int nObjectType)
{
    string ot;
    if (nObjectType == OBJECT_TYPE_CREATURE) ot = "UTC ";
    else if (nObjectType == OBJECT_TYPE_ITEM) ot = "UTI ";
    else if (nObjectType == OBJECT_TYPE_TRIGGER) ot = "UTT ";
    else if (nObjectType == OBJECT_TYPE_DOOR) ot = "UTD ";
    else if (nObjectType == OBJECT_TYPE_WAYPOINT) ot = "UTW ";
    else if (nObjectType == OBJECT_TYPE_PLACEABLE) ot = "UTP ";
    else if (nObjectType == OBJECT_TYPE_STORE) ot = "UTM ";
    else if (nObjectType == OBJECT_TYPE_ENCOUNTER) ot = "UTE ";

    if (ot == "") return JsonNull("invalid object type");

    json ret = JsonObject();
    ret = JsonObjectSet(ret, "__data_type", JsonString(ot));
    return ret;
}

json GffCreateArea(json jARE, json jGIT)
{
    json jCAF = JsonObject();
    jCAF = JsonObjectSet(jCAF, "__data_type", JsonString("CAF "));
    jCAF = GffAddStruct(jCAF, "ARE", jARE, 0);
    jCAF = GffAddStruct(jCAF, "GIT", jGIT, 1);
    return jCAF;
}


int GffGetObjectType(json jGff)
{
    json jDataType = JsonObjectGet(jGff, "__data_type");
    if (jDataType == JsonNull())
        return 0;
    else
    {
        string sObjectType = JsonGetString(jDataType);

        if (sObjectType == "UTC ") return OBJECT_TYPE_CREATURE;
        else if (sObjectType == "UTI ") return OBJECT_TYPE_ITEM;
        else if (sObjectType == "UTT ") return OBJECT_TYPE_TRIGGER;
        else if (sObjectType == "UTD ") return OBJECT_TYPE_DOOR;
        else if (sObjectType == "UTW ") return OBJECT_TYPE_WAYPOINT;
        else if (sObjectType == "UTP ") return OBJECT_TYPE_PLACEABLE;
        else if (sObjectType == "UTM ") return OBJECT_TYPE_STORE;
        else if (sObjectType == "UTE ") return OBJECT_TYPE_ENCOUNTER;
    }

    return 0;
}

int GffGetIsArea(json jGff)
{
    return JsonObjectGet(jGff, "__data_type") == JsonString("CAF ");
}

int GffGetFieldExists(json jGff, string sLabel, string sType = "")
{
    json jFieldType = GffGetFieldType(jGff, sLabel);
    return sType == "" ? jFieldType != JsonNull() : jFieldType == JsonString(sType);
}


json GffAddStruct(json jGff, string sLabel, json jStruct, int nType = -1)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_STRUCT, jStruct, nType);
}

json GffAddList(json jGff, string sLabel, json jList)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_LIST, jList);
}

json GffAddByte(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_BYTE, JsonInt(v));
}

json GffAddChar(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_CHAR, JsonInt(v));
}

json GffAddWord(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_WORD, JsonInt(v));
}

json GffAddShort(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_SHORT, JsonInt(v));
}

json GffAddDword(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_DWORD, JsonInt(v));
}

json GffAddInt(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_INT, JsonInt(v));
}

json GffAddDword64(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_DWORD64, JsonInt(v));
}

json GffAddInt64(json jGff, string sLabel, int v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_INT64, JsonInt(v));
}

json GffAddFloat(json jGff, string sLabel, float v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_FLOAT, JsonFloat(v));
}

json GffAddDouble(json jGff, string sLabel, float v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_DOUBLE, JsonFloat(v));
}

json GffAddResRef(json jGff, string sLabel, string v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_RESREF, JsonString(v));
}

json GffAddString(json jGff, string sLabel, string v)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_STRING, JsonString(v));
}

json GffAddLocString(json jGff, string sLabel, string v, int nStrRef = -1)
{
    return GffAddField(jGff, sLabel, GFF_FIELD_TYPE_LOC_STRING, GffLocString(v, nStrRef));
}


json GffReplaceStruct(json jGff, string sLabel, json jStruct)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_STRUCT, jStruct);
}

json GffReplaceList(json jGff, string sLabel, json jList)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_LIST, jList);
}

json GffReplaceByte(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_BYTE, JsonInt(v));
}

json GffReplaceChar(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_CHAR, JsonInt(v));
}

json GffReplaceWord(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_WORD, JsonInt(v));
}

json GffReplaceShort(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_SHORT, JsonInt(v));
}

json GffReplaceDword(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_DWORD, JsonInt(v));
}

json GffReplaceInt(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_INT, JsonInt(v));
}

json GffReplaceDword64(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_DWORD64, JsonInt(v));
}

json GffReplaceInt64(json jGff, string sLabel, int v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_INT64, JsonInt(v));
}

json GffReplaceFloat(json jGff, string sLabel, float v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_FLOAT, JsonFloat(v));
}

json GffReplaceDouble(json jGff, string sLabel, float v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_DOUBLE, JsonFloat(v));
}

json GffReplaceResRef(json jGff, string sLabel, string v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_RESREF, JsonString(v));
}

json GffReplaceString(json jGff, string sLabel, string v)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_STRING, JsonString(v));
}

json GffReplaceLocString(json jGff, string sLabel, string v, int nStrRef = -1)
{
    return GffReplaceField(jGff, sLabel, GFF_FIELD_TYPE_LOC_STRING, GffLocString(v, nStrRef));
}


json GffRemoveStruct(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_STRUCT);
}

json GffRemoveList(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_LIST);
}

json GffRemoveByte(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_BYTE);
}

json GffRemoveChar(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_CHAR);
}

json GffRemoveWord(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_WORD);
}

json GffRemoveShort(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_SHORT);
}

json GffRemoveDword(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_DWORD);
}

json GffRemoveInt(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_INT);
}

json GffRemoveDword64(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_DWORD64);
}

json GffRemoveInt64(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_INT64);
}

json GffRemoveFloat(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_FLOAT);
}

json GffRemoveDouble(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_DOUBLE);
}

json GffRemoveResRef(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_RESREF);
}

json GffRemoveString(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_STRING);
}

json GffRemoveLocString(json jGff, string sLabel)
{
    return GffRemoveField(jGff, sLabel, GFF_FIELD_TYPE_LOC_STRING);
}


json GffGetStruct(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_STRUCT);
}

json GffGetList(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_LIST);
}

json GffGetByte(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_BYTE);
}

json GffGetChar(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_CHAR);
}

json GffGetWord(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_WORD);
}

json GffGetShort(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_SHORT);
}

json GffGetDword(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_DWORD);
}

json GffGetInt(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_INT);
}

json GffGetDword64(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_DWORD64);
}

json GffGetInt64(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_INT64);
}

json GffGetFloat(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_FLOAT);
}

json GffGetDouble(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_DOUBLE);
}

json GffGetResRef(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_RESREF);
}

json GffGetString(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_STRING);
}

json GffGetLocString(json jGff, string sLabel)
{
    return GffGetField(jGff, sLabel, GFF_FIELD_TYPE_LOC_STRING);
}
