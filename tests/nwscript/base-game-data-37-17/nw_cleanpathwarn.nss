void main()
{
    int nCount = 0;
    object o = GetObjectByTag("TilePathfindWarning");
    
    while ( GetIsObjectValid(o) )
    {
        DestroyObject(o);
        nCount++;
        o = GetObjectByTag("TilePathfindWarning", nCount);
    }
}
