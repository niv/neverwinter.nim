/* GESTURE SCRIPT - PC performs gesture and voicechat CANDO */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_CANDO, oSource);
}

