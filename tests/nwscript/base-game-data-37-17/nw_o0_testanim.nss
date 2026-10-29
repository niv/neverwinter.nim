///////////////////////////////////////////////////////////////////////////////
//:: [Test Animations]
//::
//:: [NW_O0_TestAnim.nss]
//::
//:: Copyright (c) 2000 Bioware Corp.
///////////////////////////////////////////////////////////////////////////////
/*   Runs the calling creature through the animations 0 through 51 (this range
     comes from the animation constant list)
*/
///////////////////////////////////////////////////////////////////////////////
//:: Created By: Aidan Scanlan   On: May30, 2001
///////////////////////////////////////////////////////////////////////////////
void main()
{
    int nIdx = 0;
    float fDelay = 0.0f;
    for (nIdx = 0; nIdx <= 51; nIdx++)
    {
        fDelay = IntToFloat(nIdx) * 5.0f;
        DelayCommand(fDelay,SpeakString("Animation: " + IntToString(nIdx)));
        DelayCommand(fDelay,ActionPlayAnimation(nIdx));
    }
    DelayCommand(fDelay + 5.0f,SpeakString("Done"));
    
}
