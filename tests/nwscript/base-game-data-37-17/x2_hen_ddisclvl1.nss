// Deekin's dragon disciple level is greater than 0 but less than 9

int StartingConditional()
{
    int iResult;

    iResult = ((GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF) > 0) &&
              (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF) < 9));
    return iResult;
}
