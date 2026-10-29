/* GESTURE SCRIPT - PC performs gesture and voicechat STOP */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_STOP, oSource);
}

