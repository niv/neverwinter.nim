#include "nw_inc_nui"

const string NuiInspectorWindowId = "nw_nui_inspector";

void HandleWindowInspectorEvent()
{
  object oPlayer = NuiGetEventPlayer();

  int nInspectorToken = NuiFindWindow(oPlayer, NuiInspectorWindowId);

  // Do nothing if the inspector isn't open.
  if (!nInspectorToken)
    return;

  int    nToken  = NuiGetEventWindow();
  string sEvent  = NuiGetEventType();
  string sElem   = NuiGetEventElement();
  int    nIdx    = NuiGetEventArrayIndex();
  string sWndId  = NuiGetWindowId(oPlayer, nToken);
  json   jPayld  = NuiGetEventPayload();

  // Debug printing, even if the event is for another window.
  if (JsonGetInt(NuiGetBind(oPlayer, nInspectorToken, "debug_events")))
  {
    string msg = "NuiInspector: Event: " + sEvent +
    " token=" + IntToString(nToken) +
    " windowId=" + sWndId +
    " elemId=" + sElem +
    (nIdx > -1 ? ("[" + IntToString(nIdx) + "]") : "") +
    " payload=" + JsonDump(jPayld);

    if (sEvent == "watch")
      msg = msg + " watchval=" + JsonDump(NuiGetBind(oPlayer, nToken, sElem));
    SendMessageToPC(oPlayer, msg);
  }

  int nTargetToken = JsonGetInt(NuiGetBind(oPlayer, nInspectorToken, "selected_window_token"));

  // Whenever any window opens or closes, re-do the window listing.
  if (sEvent == "open" || (sEvent == "close" && sWndId != NuiInspectorWindowId))
  {
    SendMessageToPC(oPlayer, "NuiInspector: refreshing window data");

    json wndlst = JsonArray();
    int nth = 0;
    int itertoken = NuiGetNthWindow(oPlayer, nth);
    while (itertoken > 0)
    {
      // Don't add the window that was closed just now.
      if (sEvent != "close" || itertoken != nToken)
      {
        string name = NuiGetWindowId(oPlayer, itertoken);
        wndlst = JsonArrayInsert(wndlst, NuiComboEntry(name, itertoken));
      }
      itertoken = NuiGetNthWindow(oPlayer, ++nth);
    }

    NuiSetBind(oPlayer, nInspectorToken, "window_id_list", wndlst);

    // The currently-selected window was closed. Select a different one.
    if (sEvent == "close" && nToken == nTargetToken)
    {
      // TODO
    }
  }

  // All code following only applies to the inspector window.
  if (sWndId != NuiInspectorWindowId)
    return;

  int updateview = 0;

  // New window was selected or button was pressed.
  if (sEvent == "watch" && sElem == "selected_window_token")
  {
    updateview = 1;
  }
  if (sEvent == "click" && sElem == "refresh")
  {
    updateview = 1;
  }

  // Sync all binds over to actual window.
  if (sEvent == "watch" && sElem == "bindvalues_bool")
  {
    json labels = NuiGetBind(oPlayer, nToken, "bindlabels_bool");
    json watchval = NuiGetBind(oPlayer, nToken, sElem);

    int i; for (i = 0; i < JsonGetLength(labels); i++)
    {
      string bind = JsonGetString(JsonArrayGet(labels, i));

      json ourval = JsonArrayGet(watchval, i);
      json theirval = NuiGetBind(oPlayer, nTargetToken, bind);
      if (ourval != theirval)
      {
        SendMessageToPC(oPlayer, "Synchronising bind: " + bind);
        NuiSetBind(oPlayer, nTargetToken, bind, ourval);
      }
    }
  }

  if (updateview)
  {
    // Grab all binds from target window and add to list view.
    json bindlabels_bool = JsonArray();
    json bindvalues_bool = JsonArray();
    json bindlabels_readonly = JsonArray();
    json bindvalues_readonly = JsonArray();

    int nth = 0;
    string bind = NuiGetNthBind(oPlayer, nTargetToken, FALSE, nth);
    while (bind != "")
    {
      // Never show bindlabels or values to avoid recursion terror.
      string prefix = GetSubString(bind, 0, 10);
      if (prefix != "bindlabels" && prefix != "bindvalues")
      {
        json bval = NuiGetBind(oPlayer, nTargetToken, bind);
        if (JsonGetType(bval) == JSON_TYPE_BOOL)
        {
          bindlabels_bool = JsonArrayInsert(bindlabels_bool, JsonString(bind));
          bindvalues_bool = JsonArrayInsert(bindvalues_bool, bval);
        }
        else
        {
          string val = JsonDump(NuiGetBind(oPlayer, nTargetToken, bind));
          bindlabels_readonly = JsonArrayInsert(bindlabels_readonly, JsonString(bind));
          bindvalues_readonly = JsonArrayInsert(bindvalues_readonly, JsonString(val));
        }
      }

      bind = NuiGetNthBind(oPlayer, nTargetToken, FALSE, ++nth);
    }

    NuiSetBind(oPlayer, nInspectorToken, "bindlabels_bool", bindlabels_bool);
    NuiSetBind(oPlayer, nInspectorToken, "bindvalues_bool", bindvalues_bool);
    NuiSetBind(oPlayer, nInspectorToken, "bindlabels_readonly", bindlabels_readonly);
    NuiSetBind(oPlayer, nInspectorToken, "bindvalues_readonly", bindvalues_readonly);
    SendMessageToPC(oPlayer, "NuiInspector: Bind list updated");
  }
}


void MakeWindowInspector(object pc)
{
  // root layout column
  json col;
  col = JsonArray();

  // Window selector
  {
    json row = JsonArray();
    row = JsonArrayInsert(row, NuiSpacer());
    row = JsonArrayInsert(row, NuiCombo(NuiBind("window_id_list"), NuiBind("selected_window_token")));
    row = JsonArrayInsert(row, NuiCheck(JsonString("Print all events"), NuiBind("debug_events")));
    col = JsonArrayInsert(col, NuiRow(row));
  }

  // checkbox template (bools)
  {
    // Template: <key> <jsonvalue>
    json template = JsonArray();

    json value = NuiCheck(NuiBind("bindlabels_bool"), NuiBind("bindvalues_bool"));

    template = JsonArrayInsert(template, NuiListTemplateCell(value, 0.0, TRUE));

    json row = JsonArray();
    row = JsonArrayInsert(row, NuiList(template,
      // Special case handling for convenience:
      // Passing an array into a integer bind when getting a list size
      // will extract the array size as an int.
      NuiBind("bindlabels_bool"),
      25.0
    ));

    col = JsonArrayInsert(col, NuiRow(row));
  }

  // all other/readonly
  {
    // Template: <key> <jsonvalue>
    json template = JsonArray();

    json label = NuiLabel(NuiBind("bindlabels_readonly"), JsonInt(NUI_HALIGN_LEFT), JsonNull());
    label = NuiTooltip(label, NuiBind("bindlabels_readonly"));
    template = JsonArrayInsert(template, NuiListTemplateCell(label, 120.0, FALSE));

    json value = NuiLabel(NuiBind("bindvalues_readonly"), JsonInt(NUI_HALIGN_LEFT), JsonNull());
    value = NuiTooltip(value, NuiBind("bindvalues_readonly"));
    template = JsonArrayInsert(template, NuiListTemplateCell(value, 0.0, TRUE));

    json row = JsonArray();
    row = JsonArrayInsert(row, NuiList(template,
      // Special case handling for convenience:
      // Passing an array into a integer bind when getting a list size
      // will extract the array size as an int.
      NuiBind("bindlabels_readonly"),
      25.0
    ));

    col = JsonArrayInsert(col, NuiRow(row));
  }

  {
    json row = JsonArray();
    row = JsonArrayInsert(row, NuiSpacer());
    json refreshBtn = NuiId(NuiButton(JsonString("Refresh")), "refresh");
    row = JsonArrayInsert(row, refreshBtn);
    row = JsonArrayInsert(row, NuiSpacer());
    col = JsonArrayInsert(col, NuiRow(row));
  }

  json root = NuiCol(col);

  json nui = NuiWindow(root,
    JsonString("Nui Window Inspector"),
    NuiBind("geometry"),
    JsonBool(TRUE),
    JsonBool(FALSE),
    JsonBool(TRUE),
    JsonBool(FALSE),
    JsonBool(TRUE));
  int token = NuiCreate(pc, nui, NuiInspectorWindowId);

  NuiSetBind(pc, token, "geometry", NuiRect(10.0, 10.0, 400.0, 600.0));

  NuiSetBind(pc, token, "debug_events", JsonBool(1));

  NuiSetBindWatch(pc, token, "selected_window_token", 1);

  NuiSetBindWatch(pc, token, "bindvalues_bool", 1);
}
