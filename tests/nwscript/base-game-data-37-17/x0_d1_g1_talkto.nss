/* GESTURE SCRIPT - PC performs gesture and voicechat TALKTOME */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_TALKTOME, oSource);
}

