/* GESTURE SCRIPT - PC performs gesture and voicechat NEARDEATH */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_NEARDEATH, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED));
}

