/* Caryatid OnSpawn script -- come in petrified.
   This must be used with x0_percep_caryatd as the OnPerception handler
   or else the caryatid will never un-petrify!
*/


#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"
#include "x0_i0_petrify"

void main()
{
    SetListeningPatterns(); 
    WalkWayPoints();
    GenerateNPCTreasure();

    // Come in petrified 
    Petrify(OBJECT_SELF);
}

