/* GESTURE SCRIPT - PC performs gesture and voicechat THREATEN */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_THREATEN, oSource);
}

