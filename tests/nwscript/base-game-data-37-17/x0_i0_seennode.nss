//::///////////////////////////////////////////////
//:: Seen Conversation Node include file
//:: x0_i0_seennode
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    Helper function for creating the local variable
    name used in the seennodeX scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 10/11/02 @ 21:20
//:://////////////////////////////////////////////

// Returns a string, the variable name for determining if this
// 'conversation node' has been seen in script.
string SeenNodeVarName( int nNode );


string SeenNodeVarName( int nNode )
{
    return GetTag(OBJECT_SELF) + "_bSeenNode_" + IntToString(nNode);
}
