/* GESTURE SCRIPT - PC performs gesture and voicechat FLEE */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_FLEE, oSource);
}

