#include "nw_inc_nui"
#include "nw_inc_nui_insp"

void main()
{
  // Let the inspector handle what it wants.
  HandleWindowInspectorEvent();

  // The rest of this file is for the demo panels.
  object oPlayer = NuiGetEventPlayer();
  int    nToken  = NuiGetEventWindow();
  string sEvent  = NuiGetEventType();
  string sElem   = NuiGetEventElement();
  int    nIdx    = NuiGetEventArrayIndex();
  string sWndId  = NuiGetWindowId(oPlayer, nToken);

  if (sWndId == "spreadsheet")
  {
    int colcount = JsonGetInt(NuiGetBind(oPlayer, nToken, "colcount"));

    if (sEvent == "click" && (sElem == "btn-" || sElem == "btn+"))
    {
      int col; for (col = 0; col < colcount; col++)
      {
        string dataLabel = "data" + IntToString(col);
        string visiLabel = "visible" + IntToString(col);

        json jdata = NuiGetBind(oPlayer, nToken, dataLabel);
        json jvisi = NuiGetBind(oPlayer, nToken, visiLabel);

        int rowcount = JsonGetLength(jdata);

        if (sElem == "btn+")
        {
          int newidx = (nIdx == rowcount-1) ? -1 : nIdx + 1;
          jdata = JsonArrayInsert(jdata, JsonString(""), newidx);
          jvisi = JsonArrayInsert(jvisi, JsonBool(1), newidx);
        }
        else
        {
          // Never allow deleting the last row, no way to get the buttons back.
          if (rowcount > 1)
          {
            jdata = JsonArrayDel(jdata, nIdx);
            jvisi = JsonArrayDel(jvisi, nIdx);
          }
        }

        NuiSetBind(oPlayer, nToken, dataLabel, jdata);
        NuiSetBind(oPlayer, nToken, visiLabel, jvisi);
      }
    }
    if (sEvent == "watch" && GetSubString(sElem, 0, 4) == "data")
    {
      int sum = 0;
      int colcount = JsonGetInt(NuiGetBind(oPlayer, nToken, "colcount"));
      int col; for (col = 0; col < colcount; col++)
      {
        json jdata = NuiGetBind(oPlayer, nToken, "data" + IntToString(col));
        int rowcount = JsonGetLength(jdata);
        int row; for (row = 0; row < rowcount; row++)
        {
          int val = StringToInt(JsonGetString(JsonArrayGet(jdata, row)));
          sum = sum + val;
        }
      }
      NuiSetBind(oPlayer, nToken, "label", JsonString(IntToString(sum)));
    }
  }

  if (sWndId == "poviewer")
  {
    int po_category = JsonGetInt(NuiGetBind(oPlayer, nToken, "po_category"));
    int MIN = 0;
    int MAX = 1;

    if (po_category == 0)
    {
      MIN = 164;
      MAX = 167;
    }
    if (po_category == 1)
    {
      MIN = 191;
      MAX = 200;
    }

    int update_values = 0;

    int po_id = JsonGetInt(NuiGetBind(oPlayer, nToken, "po_id"));

    if (sEvent == "watch" && sElem == "po_category")
    {
        po_id = MIN;
        update_values = 1;
    }

    if (sEvent == "click" && (sElem == "btnnext" || sElem == "btnprev"))
    {
      po_id += sElem == "btnnext" ? 1 : -1;
      update_values = 1;
    }

    if (update_values)
    {
      if (po_id > MAX) po_id = MAX;
      if (po_id < MIN) po_id = MIN;

      string ref = "po_" + Get2DAString("portraits", "BaseResRef", po_id) + "h";
      NuiSetBind(oPlayer, nToken, "po_id", JsonInt(po_id));
      NuiSetBind(oPlayer, nToken, "po_resref", JsonString(ref));
      NuiSetBind(oPlayer, nToken, "btnpreve", JsonBool(po_id > MIN));
      NuiSetBind(oPlayer, nToken, "btnnexte", JsonBool(po_id < MAX));
      NuiSetBind(oPlayer, nToken, "btnoke", JsonBool(1));
    }

    if (sEvent == "click" && sElem == "btnok")
    {
      int id = JsonGetInt(NuiGetBind(oPlayer, nToken, "po_id"));
      SetPortraitId(oPlayer, id);
      NuiDestroy(oPlayer, nToken);
    }
  }
}
