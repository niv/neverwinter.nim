/* GESTURE SCRIPT - PC performs gesture and voicechat SELECTED */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_SELECTED, oSource);
}

