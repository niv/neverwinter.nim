// Deekin has gained at least 1 level in Dragon Disciple

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF) > 0;
    return iResult;
}
