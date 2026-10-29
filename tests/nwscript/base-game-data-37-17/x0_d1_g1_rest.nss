/* GESTURE SCRIPT - PC performs gesture and voicechat REST */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_REST, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED));
}

