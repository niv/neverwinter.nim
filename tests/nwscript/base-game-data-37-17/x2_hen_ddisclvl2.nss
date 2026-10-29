// Deekin is a level 9 Dragon Disciple or greater

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF) > 8;
    return iResult;
}
