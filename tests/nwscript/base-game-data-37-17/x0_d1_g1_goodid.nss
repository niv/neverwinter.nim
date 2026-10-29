/* GESTURE SCRIPT - PC performs gesture and voicechat GOODIDEA */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_GOODIDEA, oSource);
}

