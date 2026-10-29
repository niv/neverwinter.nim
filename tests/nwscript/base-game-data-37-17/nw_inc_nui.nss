const int NUI_DIRECTION_HORIZONTAL         = 0;
const int NUI_DIRECTION_VERTICAL           = 1;

const int NUI_MOUSE_BUTTON_LEFT            = 0;
const int NUI_MOUSE_BUTTON_MIDDLE          = 1;
const int NUI_MOUSE_BUTTON_RIGHT           = 2;

const int NUI_SCROLLBARS_NONE              = 0;
const int NUI_SCROLLBARS_X                 = 1;
const int NUI_SCROLLBARS_Y                 = 2;
const int NUI_SCROLLBARS_BOTH              = 3;
const int NUI_SCROLLBARS_AUTO              = 4;

const int NUI_ASPECT_FIT                   = 0;
const int NUI_ASPECT_FILL                  = 1;
const int NUI_ASPECT_FIT100                = 2;
const int NUI_ASPECT_EXACT                 = 3;
const int NUI_ASPECT_EXACTSCALED           = 4;
const int NUI_ASPECT_STRETCH               = 5;

const int NUI_HALIGN_CENTER                = 0;
const int NUI_HALIGN_LEFT                  = 1;
const int NUI_HALIGN_RIGHT                 = 2;

const int NUI_VALIGN_MIDDLE                = 0;
const int NUI_VALIGN_TOP                   = 1;
const int NUI_VALIGN_BOTTOM                = 2;

// -----------------------
// Style

const float NUI_STYLE_PRIMARY_WIDTH        = 150.0;
const float NUI_STYLE_PRIMARY_HEIGHT       = 50.0;

const float NUI_STYLE_SECONDARY_WIDTH      = 150.0;
const float NUI_STYLE_SECONDARY_HEIGHT     = 35.0;

const float NUI_STYLE_TERTIARY_WIDTH       = 100.0;
const float NUI_STYLE_TERTIARY_HEIGHT      = 30.0;

const float NUI_STYLE_ROW_HEIGHT           = 25.0;

// -----------------------
// Bind params

// These currently only affect presentation and serve as a
// optimisation to let the client do the heavy lifting on this.
// In particular, this enables you to bind an array of values and
// transform them all at once on the client, instead of having to
// have the server transform them before sending.

// NB: These must be OR-ed together into a bitmask.

const int NUI_NUMBER_FLAG_HEX              = 0x001;

// NB: These must be OR-ed together into a bitmask.

const int NUI_TEXT_FLAG_LOWERCASE          = 0x001;
const int NUI_TEXT_FLAG_UPPERCASE          = 0x002;

// -----------------------
// Window

// Special cases:
// * Set the window title to JsonBool(FALSE), Collapse to JsonBool(FALSE) and bClosable to FALSE
//   to hide the title bar.
//   Note: You MUST provide a way to close the window some other way, or the user will be stuck with it.
// * Set a minimum size constraint equal to the maximmum size constraint in the same dimension to prevent
//   a window from being resized in that dimension.
// - jRoot: Layout-ish (NuiRow, NuiCol, NuiGroup)
// - jTitle: Bind:String
// - jGeometry: Bind:Rect
//              Set x and/or y to -1.0 to center the window on that axis.
//              Set x and/or y to -2.0 to position the window's top left at the mouse cursor's position of that axis.
//              Set x and/or y to -3.0 to center the window on the mouse cursor's position of that axis.
// - jResizable: Bind:Bool
//               Set to JsonBool(TRUE) or JsonNull() to let user resize without binding.
// - jCollapsed: Bind:Bool
//               Set to a static value JsonBool(FALSE) to disable collapsing.
//               Set to JsonNull() to let user collapse without binding.
//               For better UX, leave collapsing on.
// - jCloseable: Bind:Bool
//               You provide a way to close the window if you set this to FALSE.
//               For better UX, handle the window "closed" event.
// - jTransparent: Bind:Bool
//                 Do not render background
// - jBorder: Bind:Bool
//            Do not render border
// - jAcceptsInput: Bind:Bool
//                  Set JsonBool(FALSE) to disable all input.
//                  All hover, clicks and keypresses will fall through.
// - jSizeConstraint: Bind:Rect
//                    Constrains minimum and maximum size of window.
//                    Set x to minimum width, y to minimum height, w to maximum width, h to maximum height.
//                    Set any individual constraint to 0.0 to ignore that constraint.
// - jEdgeConstraint: Bind:Rect
//                    Prevents a window from being rendered within the specified margins.
//                    Set x to left margin, y to top margin, w to right margin, h to bottom margin.
//                    Set any individual constraint to 0.0 to ignore that constraint
// - jFont: Bind:String
//          Override font used on window, including decorations. See NuiStyleFont() for details.
json NuiWindow(json jRoot, json jTitle, json jGeometry, json jResizable,json jCollapsed,json jClosable, json jTransparent, json jBorder, json jAcceptsInput = JSON_TRUE, json jSizeConstraint = JSON_NULL, json jEdgeConstraint = JSON_NULL, json jFont = JSON_STRING);

// -----------------------
// Values

// Create a dynamic bind. Unlike static values, these can change at runtime:
//    NuiBind("mybindlabel");
//    NuiSetBind(.., "mybindlabel", JsonString("hi"));
// To create static values, just use the json types directly:
//    JsonString("hi");
//
// You can parametrise this particular bind with the given flags.
// These flags only apply to that particular usage of this bind value.
//
// - sId: string
// - nNumberFlags: bitmask of NUI_NUMBER_FLAG_*
// - nNumberPrecision: Precision to print number with (int or float)
// - nTextFlags: bitmask of NUI_TEXT_FLAG_*
json NuiBind(string sId, int nNumberFlags = 0, int nNumberPrecision = 0, int nTextFlags = 0);

// Tag the given element with a id.
// Only tagged elements will send events to the server.
json NuiId(json jElem, string sId);

// A shim/helper that can be used to render or bind a strref where otherwise
// a string value would go.
json NuiStrRef(int nStrRef);

// -----------------------
// Layout

// A column will auto-space all elements inside of it and advise the parent
// about it's desired size.
// - jList: Layout[] or Element[]
json NuiCol(json jList);

// A row will auto-space all elements inside of it and advise the parent
// about it's desired size.
// - jList: Layout[] or Element[]
json NuiRow(json jList);

// A group, usually with a border and some padding, holding a single element. Can scroll.
// Will not advise parent of size, so you need to let it fill a span (col/row) as if it was
// a element.
// - jChild: Layout or Element
json NuiGroup(json jChild, int bBorder = TRUE, int nScroll = NUI_SCROLLBARS_AUTO);

// Modifiers/Attributes: These are all static and cannot be bound, since the UI system
// cannot easily reflow once the layout is set up. You need to swap the layout if you
// want to change element geometry.

// - jElem: Element
// - fWidth: Float: Element width in pixels (strength=required).
json NuiWidth(json jElem, float fWidth);

// - jElem: Element
// - fHeight: Float: Height in pixels (strength=required).
json NuiHeight(json jElem, float fHeight);

// - jElem: Element
// - fAspect: Float: Ratio of x/y
json NuiAspect(json jElem, float fAspect);

// Set a margin on the widget. The margin is the spacing outside of the widget.
json NuiMargin(json jElem, float fMargin);

// Set padding on the widget. The margin is the spacing inside of the widget.
json NuiPadding(json jElem, float fPadding);

// Disabled elements are non-interactive and greyed out.
// - jElem: Element
// - jEnabled: Bind:Bool
json NuiEnabled(json jElem, json jEnabler);

// Invisible elements do not render at all, but still take up layout space.
// - jElem: Element
// - jVisible: Bind:Bool
json NuiVisible(json jElem, json jVisible);

// Tooltips show on mouse hover.
// - jElem: Element
// - jTooltip: Bind:String
json NuiTooltip(json jElem, json jTooltip);

// Tooltips for disabled elements show on mouse hover.
// - jElem: Element
// - jTooltip: Bind:String
json NuiDisabledTooltip(json jElem, json jTooltip);

// Encouraged elements have a breathing animated glow inside of it.
// - jElem: Element
// - jEncouraged: Bind:Bool
json NuiEncouraged(json jElem, json jEncouraged);

// -----------------------
// Props & Style

json NuiVec(float x, float y);

json NuiRect(float x, float y, float w, float h);

json NuiColor(int r, int g, int b, int a = 255);

// Style the foreground color of a widget or window title. This is dependent on the widget
// in question and only supports solid/full colors right now (no texture skinning).
// For example, labels would style their text color; progress bars would style the bar.
// - jElem: Element
// - jColor: Bind:Color
json NuiStyleForegroundColor(json jElem, json jColor);

// Override the font used for this element. The font and it's properties needs to be listed in
// nui_skin.tml, as all fonts are pre-baked into a texture atlas at content load.
// - jElem: Element
// - jColor: Bind:String ([[fonts]].name in nui_skin.tml)
json NuiStyleFont(json jElem, json jFont);

// -----------------------
// Widgets

// A special widget that just takes up layout space.
// If you add multiple spacers to a span, they will try to size equally.
//  e.g.: [ <spacer> <button|w=50> <spacer> ] will try to center the button.
json NuiSpacer();

// Create a label field. Labels are single-line stylable non-editable text fields.
// - jValue: Bind:String
// - jHAlign: Bind:Int:NUI_HALIGN_*
// - jVAlign: Bind:Int:NUI_VALIGN_*
json NuiLabel(json jValue, json jHAlign, json jVAlign);

// Create a non-editable text field. Note: This text field internally implies a NuiGroup wrapped
// around it, which is providing the optional border and scrollbars.
// - jValue: Bind:String
// - bBorder: Bool
// - nScroll: Int:NUI_SCROLLBARS_*
json NuiText(json jValue, int bBorder = TRUE, int nScroll = NUI_SCROLLBARS_AUTO);

// A clickable button with text as the label.
// Sends "click" events on click.
// - jLabel: Bind:String
json NuiButton(json jLabel);

// A clickable button with an image as the label.
// Sends "click" events on click.
// - jResRef: Bind:String
json NuiButtonImage(json jResRef);

// A clickable button with text as the label.
// Same as the normal button, but this one is a toggle.
// Sends "click" events on click.
// - jLabel: Bind:String
// - jValue: Bind:Bool
json NuiButtonSelect(json jLabel, json jValue);

// A checkbox with a label to the right of it.
// - jLabel: Bind:String
// - jBool: Bind:Bool
json NuiCheck(json jLabel, json jBool);

// A image, with no border or padding.
// - jResRef: Bind:String
// - jAspect: Bind:Int:NUI_ASPECT_*
// - jHAlign: Bind:Int:NUI_HALIGN_*
// - jVAlign: Bind:Int:NUI_VALIGN_*
json NuiImage(json jResRef, json jAspect, json jHAlign, json jVAlign);

// Optionally render only subregion of jImage.  This property can be set on
// NuiImage and NuiButtonImage widgets.
// jRegion is a NuiRect (x, y, w, h) to indicate the render region inside the image.
json NuiImageRegion(json jImage, json jRegion);

// A combobox/dropdown.
// - jElements: Bind:ComboEntry[]
// - jSelected: Bind:Int (index into jElements)
json NuiCombo(json jElements, json jSelected);

json NuiComboEntry(string sLabel, int nValue);

// A floating-point slider. A good step size for normal-sized sliders is 0.01.
// - jValue: Bind:Float
// - jMin: Bind:Float
// - jMax: Bind:Float
// - jStepSize: Bind:Float
json NuiSliderFloat(json jValue, json jMin, json jMax, json jStepSize);

// A integer/discrete slider.
// - jValue: Bind:Int
// - jMin: Bind:Int
// - jMax: Bind:Int
// - jStepSize: Bind:Int
json NuiSlider(json jValue, json jMin, json jMax, json jStepSize);

// A progress bar. Progress is always from 0.0 to 1.0.
// - jValue: Bind:Float (0.0->1.0
json NuiProgress(json jValue);

// A editable text field.
// - jPlaceholder: Bind:String
// - jValue: Bind:String
// - nMaxLength: UInt >= 1, <= 65535
// - bMultiLine: Bool
// - bWordWrap: Bool
json NuiTextEdit(json jPlaceholder, json jValue, int nMaxLength, int bMultiline, int bWordWrap = TRUE);

// Creates a list view of elements.
// jTemplate needs to be an array of NuiListTemplateCell instances.
// All binds referenced in jTemplate should be arrays of rRowCount size;
// e.g. when rendering a NuiLabel(), the bound label String should be an array of strings.
// You can pass in one of the template jRowCount into jSize as a convenience. The array
// size will be uses as the Int bind.
// fRowHeight defines the height of the rendered rows.
// - jTemplate: NuiListTemplateCell[] (max: 16)
// - jRowCount: Bind:Int
// - bBorder: Bool
// - nScroll: Int:NUI_SCROLLBARS_*, Note: Cannot be AUTO
json NuiList(json jTemplate, json jRowCount, float fRowHeight = NUI_STYLE_ROW_HEIGHT, int bBorder = TRUE, int nScroll = NUI_SCROLLBARS_Y);

// - jElem: Element
// - fWidth: Float:0 = auto, >1 = pixel width
// - bVariable: Bool:Cell can grow if space is available; otherwise static
json NuiListTemplateCell(json jElem, float fWidth, int bVariable);

// A simple color picker, with no border or spacing.
// - jColor: Bind:Color
json NuiColorPicker(json jColor);

// A list of options (radio buttons). Only one can be selected
// at a time. jValue is updated every time a different element is
// selected. The special value -1 means "nothing".
// - nDirection: NUI_DIRECTION_*
// - jElements: JsonArray of string labels
// - jValue: Bind:UInt
json NuiOptions(int nDirection, json jElements, json jValue);

// A group of buttons. Only one can be selected at a time. jValue
// is updated every time a different button is selected. The special
// value -1 means "nothing".
// - nDirection: NUI_DIRECTION_*
// - jElements: JsonArray of string labels
// - jValue: Bind:Int
json NuiToggles(int nDirection, json jElements,  json jValue);

const int NUI_CHART_TYPE_LINES                 = 0;
const int NUI_CHART_TYPE_COLUMN                = 1;

// - nType: Int:NUI_CHART_TYPE_*
// - jLegend: Bind:String
// - jColor: Bind:NuiColor
// - jData: Bind:Float[]
json NuiChartSlot(int nType, json jLegend, json jColor, json jData);

// Renders a chart.
// Currently, min and max values are determined automatically and
// cannot be influenced.
// - jSlots: NuiChartSlot[]
json NuiChart( json jSlots);

// -----------------------
// Draw Lists

// Draw lists are raw painting primitives on top of widgets.
// They are anchored to the widget x/y coordinates, and are always
// painted in order of definition, without culling. You cannot bind
// the draw_list itself, but most parameters on individual draw_list
// entries can be bound.

const int NUI_DRAW_LIST_ITEM_TYPE_POLYLINE     = 0;
const int NUI_DRAW_LIST_ITEM_TYPE_CURVE        = 1;
const int NUI_DRAW_LIST_ITEM_TYPE_CIRCLE       = 2;
const int NUI_DRAW_LIST_ITEM_TYPE_ARC          = 3;
const int NUI_DRAW_LIST_ITEM_TYPE_TEXT         = 4;
const int NUI_DRAW_LIST_ITEM_TYPE_IMAGE        = 5;
const int NUI_DRAW_LIST_ITEM_TYPE_LINE         = 6;
const int NUI_DRAW_LIST_ITEM_TYPE_RECT         = 7;

// You can order draw list items to be painted either before, or after the
// builtin render of the widget in question. This enables you to paint "behind"
// a widget.

const int NUI_DRAW_LIST_ITEM_ORDER_BEFORE      = -1;
const int NUI_DRAW_LIST_ITEM_ORDER_AFTER       = 1;

// Always render draw list item (default).
const int NUI_DRAW_LIST_ITEM_RENDER_ALWAYS       = 0;
// Only render when NOT hovering.
const int NUI_DRAW_LIST_ITEM_RENDER_MOUSE_OFF    = 1;
// Only render when mouse is hovering.
const int NUI_DRAW_LIST_ITEM_RENDER_MOUSE_HOVER  = 2;
// Only render while LMB is held down.
const int NUI_DRAW_LIST_ITEM_RENDER_MOUSE_LEFT   = 3;
// Only render while RMB is held down.
const int NUI_DRAW_LIST_ITEM_RENDER_MOUSE_RIGHT  = 4;
// Only render while MMB is held down.
const int NUI_DRAW_LIST_ITEM_RENDER_MOUSE_MIDDLE = 5;

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jFill: Bind:Bool
// - jLineThickness: Bind:Float
// - jPoints: Bind:Float[] Always provide points in pairs
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListPolyLine(json jEnabled, json jColor, json jFill, json jLineThickness, json jPoints, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jLineThickness: Bind:Float
// - jA: Bind:Vec2
// - jB: Bind:Vec2
// - jCtrl0: Bind:Vec2
// - jCtrl1: Bind:Vec2
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListCurve(json jEnabled, json jColor, json jLineThickness, json jA, json jB, json jCtrl0, json jCtrl1, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jFill: Bind:Bool
// - jLineThickness: Bind:Float
// - jRect: Bind:Rect
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListCircle(json jEnabled, json jColor, json jFill, json jLineThickness, json jRect, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jFill: Bind:Bool
// - jLineThickness: Bind:Float
// - jCenter: Bind:Rect
// - jRadius: Bind:Float
// - jAMin: Bind:Float
// - jAMax: Bind:Float
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListArc(json jEnabled, json jColor, json jFill, json jLineThickness, json jCenter, json jRadius, json jAMin, json jAMax, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jRect: Bind:Rect
// - jText: Bind:String
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
// - jFont: Bind:String
json NuiDrawListText(json jEnabled, json jColor, json jRect, json jText, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE, json jFont = JSON_STRING);

// - jEnabled: Bind:Bool
// - jResRef: Bind:String
// - jPos: Bind:Rect
// - jAspect: Bind:Int:NUI_ASPECT_*
// - jHAlign: Bind:Int:NUI_HALIGN_*
// - jVAlign: Bind:Int:NUI_VALIGN_*
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListImage(json jEnabled, json jResRef, json jPos, json jAspect, json jHAlign, json jVAlign, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jDrawListImage: DrawListItemImage
// - jRegion: Bind:NuiRect
json NuiDrawListImageRegion(json jDrawListImage, json jRegion);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jLineThickness: Bind:Float
// - jA: Bind:Vec2
// - jB: Bind:Vec2
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListLine(json jEnabled, json jColor, json jLineThickness, json jA, json jB, int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jEnabled: Bind:Bool
// - jColor: Bind:Color
// - jFill: Bind:Bool
// - jLineThickness: Bind:Float
// - jRext: Bind:Rect
// - nOrder: Int:NUI_DRAW_LIST_ITEM_ORDER_*
// - nRender: Int:NUI_DRAW_LIST_ITEM_RENDER_*
// - nBindArrays: Values in binds are considered arrays-of-values
json NuiDrawListRect(json jEnabled, json jColor, json jFill, json jLineThickness, json jRect, int  nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER, int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS, int nBindArrays = FALSE);

// - jElem: Element
// - jScissor: Bind:Bool, Constrain painted elements to widget bounds.
// - jList: DrawListItem[]
json NuiDrawList(json jElem, json jScissor, json jList);

// -----------------------
// Implementation

json
NuiWindow(
  json jRoot,
  json jTitle,
  json jGeometry,
  json jResizable,
  json jCollapsed,
  json jClosable,
  json jTransparent,
  json jBorder,
  json jAcceptsInput = JSON_TRUE,
  json jWindowConstraint = JSON_NULL,
  json jEdgeConstraint = JSON_NULL,
  json jFont = JSON_STRING
)
{
  json ret = JsonObject();
  // Currently hardcoded and here to catch backwards-incompatible data in the future.
  JsonObjectSetInplace(ret, "version", JsonInt(1));
  JsonObjectSetInplace(ret, "title", jTitle);
  JsonObjectSetInplace(ret, "root", jRoot);
  JsonObjectSetInplace(ret, "geometry", jGeometry);
  JsonObjectSetInplace(ret, "resizable", jResizable);
  JsonObjectSetInplace(ret, "collapsed", jCollapsed);
  JsonObjectSetInplace(ret, "closable", jClosable);
  JsonObjectSetInplace(ret, "transparent", jTransparent);
  JsonObjectSetInplace(ret, "border", jBorder);
  JsonObjectSetInplace(ret, "accepts_input", jAcceptsInput);
  JsonObjectSetInplace(ret, "size_constraint", jWindowConstraint);
  JsonObjectSetInplace(ret, "edge_constraint", jEdgeConstraint);
  JsonObjectSetInplace(ret, "font", jFont);
  return ret;
}

json
NuiElement(
  string sType,
  json jLabel,
  json jValue
)
{
    json ret = JsonObject();
    JsonObjectSetInplace(ret, "type", JsonString(sType));
    JsonObjectSetInplace(ret, "label", jLabel);
    JsonObjectSetInplace(ret, "value", jValue);
    return ret;
}

json
NuiBind(
  string sId,
  int nNumberFlags = 0,
  int nNumberPrecision = 0,
  int nTextFlags = 0
)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "bind", JsonString(sId));
  JsonObjectSetInplace(ret, "number_flags", JsonInt(nNumberFlags));
  JsonObjectSetInplace(ret, "number_precision", JsonInt(nNumberPrecision));
  JsonObjectSetInplace(ret, "text_flags", JsonInt(nTextFlags));
  return ret;
}

json
NuiId(
  json jElem,
  string sId
)
{
  return JsonObjectSet(jElem, "id", JsonString(sId));
}

json
NuiStrRef(
    int nStrRef
)
{
    json ret = JsonObject();
    JsonObjectSetInplace(ret, "strref", JsonInt(nStrRef));
    return ret;
}

json
NuiCol(
  json jList
)
{
  return JsonObjectSet(NuiElement("col", JsonNull(), JsonNull()), "children", jList);
}

json
NuiRow(
  json jList
)
{
  return JsonObjectSet(NuiElement("row", JsonNull(), JsonNull()), "children", jList);
}

json
NuiGroup(
  json jChild,
  int bBorder = TRUE,
  int nScroll = NUI_SCROLLBARS_AUTO
)
{
  json ret = NuiElement("group", JsonNull(), JsonNull());
  JsonObjectSetInplace(ret, "children", JsonArrayInsert(JsonArray(), jChild));
  JsonObjectSetInplace(ret, "border", JsonBool(bBorder));
  JsonObjectSetInplace(ret, "scrollbars", JsonInt(nScroll));
  return ret;
}

json
NuiWidth(json jElem, float fWidth)
{
  return JsonObjectSet(jElem, "width", JsonFloat(fWidth));
}

json
NuiHeight(json jElem, float fHeight)
{
  return JsonObjectSet(jElem, "height", JsonFloat(fHeight));
}

json
NuiAspect(json jElem, float fAspect)
{
  return JsonObjectSet(jElem, "aspect", JsonFloat(fAspect));
}

json
NuiMargin(
  json jElem,
  float fMargin
)
{
  return JsonObjectSet(jElem, "margin", JsonFloat(fMargin));
}

json
NuiPadding(
  json jElem,
  float fPadding
)
{
  return JsonObjectSet(jElem, "padding", JsonFloat(fPadding));
}

json
NuiEnabled(
  json jElem,
  json jEnabler
)
{
  return JsonObjectSet(jElem, "enabled", jEnabler);
}

json
NuiVisible(
  json jElem,
  json jVisible
)
{
  return JsonObjectSet(jElem, "visible", jVisible);
}

json
NuiTooltip(
  json jElem,
  json jTooltip
)
{
  return JsonObjectSet(jElem, "tooltip", jTooltip);
}

json
NuiDisabledTooltip(
  json jElem,
  json jTooltip
)
{
  return JsonObjectSet(jElem, "disabled_tooltip", jTooltip);
}

json
NuiEncouraged(
  json jElem,
  json jEncouraged
)
{
  return JsonObjectSet(jElem, "encouraged", jEncouraged);
}

json
NuiVec(float x, float y)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "x", JsonFloat(x));
  JsonObjectSetInplace(ret, "y", JsonFloat(y));
  return ret;
}

json
NuiRect(float x, float y, float w, float h)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "x", JsonFloat(x));
  JsonObjectSetInplace(ret, "y", JsonFloat(y));
  JsonObjectSetInplace(ret, "w", JsonFloat(w));
  JsonObjectSetInplace(ret, "h", JsonFloat(h));
  return ret;
}

json
NuiColor(int r, int g, int b, int a = 255)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "r", JsonInt(r));
  JsonObjectSetInplace(ret, "g", JsonInt(g));
  JsonObjectSetInplace(ret, "b", JsonInt(b));
  JsonObjectSetInplace(ret, "a", JsonInt(a));
  return ret;
}

json
NuiStyleForegroundColor(
  json jElem,
  json jColor
)
{
  return JsonObjectSet(jElem, "foreground_color", jColor);
}

json
NuiStyleFont(
  json jElem,
  json jFont
)
{
  return JsonObjectSet(jElem, "font", jFont);
}

json
NuiSpacer()
{
  return NuiElement("spacer", JsonNull(), JsonNull());
}

json
NuiLabel(
  json jValue,
  json jHAlign,
  json jVAlign
)
{
  json ret = NuiElement("label", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "text_halign", jHAlign);
  JsonObjectSetInplace(ret, "text_valign", jVAlign);
  return ret;
}

json
NuiText(
  json jValue,
  int bBorder = TRUE,
  int nScroll = NUI_SCROLLBARS_AUTO
)
{
  json ret = NuiElement("text", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "border", JsonBool(bBorder));
  JsonObjectSetInplace(ret, "scrollbars", JsonInt(nScroll));
  return ret;
}

json
NuiButton(
  json jLabel
)
{
  return NuiElement("button", jLabel, JsonNull());
}

json
NuiButtonImage(
  json jResRef
)
{
  return NuiElement("button_image", jResRef, JsonNull());
}

json
NuiButtonSelect(
  json jLabel,
  json jValue
)
{
  return NuiElement("button_select", jLabel, jValue);
}

json
NuiCheck(
  json jLabel,
  json jBool
)
{
  return NuiElement("check", jLabel, jBool);
}

json
NuiImage(
  json jResRef,
  json jAspect,
  json jHAlign,
  json jVAlign
)
{
  json img = NuiElement("image", JsonNull(), jResRef);
  JsonObjectSetInplace(img, "image_aspect", jAspect);
  JsonObjectSetInplace(img, "image_halign", jHAlign);
  JsonObjectSetInplace(img, "image_valign", jVAlign);
  return img;
}

json
NuiImageRegion(
    json jImage,
    json jRegion
)
{
    return JsonObjectSet(jImage, "image_region", jRegion);
}

json
NuiCombo(
  json jElements,
  json jSelected
)
{
  return JsonObjectSet(NuiElement("combo", JsonNull(), jSelected), "elements", jElements);
}

json
NuiComboEntry(
  string sLabel,
  int nValue
)
{
  return JsonArrayInsert(JsonArrayInsert(JsonArray(), JsonString(sLabel)), JsonInt(nValue));
}

json
NuiSliderFloat(
  json jValue,
  json jMin,
  json jMax,
  json jStepSize
)
{
  json ret = NuiElement("sliderf", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "min", jMin);
  JsonObjectSetInplace(ret, "max", jMax);
  JsonObjectSetInplace(ret, "step", jStepSize);
  return ret;
}

json
NuiSlider(
  json jValue,
  json jMin,
  json jMax,
  json jStepSize
)
{
  json ret = NuiElement("slider", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "min", jMin);
  JsonObjectSetInplace(ret, "max", jMax);
  JsonObjectSetInplace(ret, "step", jStepSize);
  return ret;
}

json
NuiProgress(
  json jValue
)
{
  return NuiElement("progress", JsonNull(), jValue);
}

json
NuiTextEdit(
  json jPlaceholder,
  json jValue,
  int nMaxLength,
  int bMultiline,
  int bWordWrap = TRUE
)
{
  json ret = NuiElement("textedit", jPlaceholder, jValue);
  JsonObjectSetInplace(ret, "max", JsonInt(nMaxLength));
  JsonObjectSetInplace(ret, "multiline", JsonBool(bMultiline));
  JsonObjectSetInplace(ret, "wordwrap", JsonBool(bWordWrap));
  return ret;
}

json
NuiList(
  json jTemplate,
  json jRowCount,
  float fRowHeight = NUI_STYLE_ROW_HEIGHT,
  int bBorder = TRUE,
  int nScroll = NUI_SCROLLBARS_Y
)
{
  json ret = NuiElement("list", JsonNull(), JsonNull());
  JsonObjectSetInplace(ret, "row_template", jTemplate);
  JsonObjectSetInplace(ret, "row_count", jRowCount);
  JsonObjectSetInplace(ret, "row_height", JsonFloat(fRowHeight));
  JsonObjectSetInplace(ret, "border", JsonBool(bBorder));
  JsonObjectSetInplace(ret, "scrollbars", JsonInt(nScroll));
  return ret;
}

json
NuiListTemplateCell(
  json jElem,
  float fWidth,
  int bVariable
)
{
  json ret = JsonArray();
  JsonArrayInsertInplace(ret, jElem);
  JsonArrayInsertInplace(ret, JsonFloat(fWidth));
  JsonArrayInsertInplace(ret, JsonBool(bVariable));
  return ret;
}

json
NuiColorPicker(
  json jColor
)
{
  json ret = NuiElement("color_picker", JsonNull(), jColor);
  return ret;
}

json
NuiOptions(
  int nDirection,
  json jElements,
  json jValue
)
{
  json ret = NuiElement("options", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "direction", JsonInt(nDirection));
  JsonObjectSetInplace(ret, "elements", jElements);
  return ret;
}

json
NuiToggles(
  int nDirection,
  json jElements,
  json jValue
)
{
  json ret = NuiElement("tabbar", JsonNull(), jValue);
  JsonObjectSetInplace(ret, "direction", JsonInt(nDirection));
  JsonObjectSetInplace(ret, "elements", jElements);
  return ret;
}

json
NuiChartSlot(
  int nType,
  json jLegend,
  json jColor,
  json jData
)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "type", JsonInt(nType));
  JsonObjectSetInplace(ret, "legend", jLegend);
  JsonObjectSetInplace(ret, "color", jColor);
  JsonObjectSetInplace(ret, "data", jData);
  return ret;
}

json
NuiChart(
  json jSlots
)
{
  json ret = NuiElement("chart", JsonNull(), jSlots);
  return ret;
}

json
NuiDrawListItem(
  int nType,
  json jEnabled,
  json jColor,
  json jFill,
  json jLineThickness,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = JsonObject();
  JsonObjectSetInplace(ret, "type", JsonInt(nType));
  JsonObjectSetInplace(ret, "enabled", jEnabled);
  JsonObjectSetInplace(ret, "color", jColor);
  JsonObjectSetInplace(ret, "fill", jFill);
  JsonObjectSetInplace(ret, "line_thickness", jLineThickness);
  JsonObjectSetInplace(ret, "order", JsonInt(nOrder));
  JsonObjectSetInplace(ret, "render", JsonInt(nRender));
  JsonObjectSetInplace(ret, "arrayBinds", JsonBool(nBindArrays));
  return ret;
}

json
NuiDrawListPolyLine(
  json jEnabled,
  json jColor,
  json jFill,
  json jLineThickness,
  json jPoints,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_POLYLINE, jEnabled, jColor, jFill, jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "points", jPoints);
  return ret;
}

json
NuiDrawListCurve(
  json jEnabled,
  json jColor,
  json jLineThickness,
  json jA,
  json jB,
  json jCtrl0,
  json jCtrl1,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_CURVE, jEnabled, jColor, JsonBool(0), jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "a", jA);
  JsonObjectSetInplace(ret, "b", jB);
  JsonObjectSetInplace(ret, "ctrl0", jCtrl0);
  JsonObjectSetInplace(ret, "ctrl1", jCtrl1);
  return ret;
}

json
NuiDrawListCircle(
  json jEnabled,
  json jColor,
  json jFill,
  json jLineThickness,
  json jRect,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_CIRCLE, jEnabled, jColor, jFill, jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "rect", jRect);
  return ret;
}

json
NuiDrawListArc(
  json jEnabled,
  json jColor,
  json jFill,
  json jLineThickness,
  json jCenter,
  json jRadius,
  json jAMin,
  json jAMax,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_ARC, jEnabled, jColor, jFill, jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "c", jCenter);
  JsonObjectSetInplace(ret, "radius", jRadius);
  JsonObjectSetInplace(ret, "amin", jAMin);
  JsonObjectSetInplace(ret, "amax", jAMax);
  return ret;
}

json
NuiDrawListText(
  json jEnabled,
  json jColor,
  json jRect,
  json jText,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE,
  json jFont = JSON_STRING
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_TEXT, jEnabled, jColor, JsonNull(), JsonNull(), nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "rect", jRect);
  JsonObjectSetInplace(ret, "text", jText);
  ret = NuiStyleFont(ret, jFont);
  return ret;
}

json
NuiDrawListImage(
  json jEnabled,
  json jResRef,
  json jRect,
  json jAspect,
  json jHAlign,
  json jVAlign,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_IMAGE, jEnabled, JsonNull(), JsonNull(), JsonNull(), nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "image", jResRef);
  JsonObjectSetInplace(ret, "rect", jRect);
  JsonObjectSetInplace(ret, "image_aspect", jAspect);
  JsonObjectSetInplace(ret, "image_halign", jHAlign);
  JsonObjectSetInplace(ret, "image_valign", jVAlign);
  return ret;
}

json
NuiDrawListImageRegion(
  json jDrawListImage,
  json jRegion
)
{
    return JsonObjectSet(jDrawListImage, "image_region", jRegion);
}

json
NuiDrawListLine(
  json jEnabled,
  json jColor,
  json jLineThickness,
  json jA,
  json jB,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_LINE, jEnabled, jColor, JsonNull(), jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "a", jA);
  JsonObjectSetInplace(ret, "b", jB);
  return ret;
}

json
NuiDrawListRect(
  json jEnabled,
  json jColor,
  json jFill,
  json jLineThickness,
  json jRect,
  int nOrder = NUI_DRAW_LIST_ITEM_ORDER_AFTER,
  int nRender = NUI_DRAW_LIST_ITEM_RENDER_ALWAYS,
  int nBindArrays = FALSE
)
{
  json ret = NuiDrawListItem(NUI_DRAW_LIST_ITEM_TYPE_RECT, jEnabled, jColor, jFill, jLineThickness, nOrder, nRender, nBindArrays);
  JsonObjectSetInplace(ret, "rect", jRect);
  return ret;
}

json
NuiDrawList(
  json jElem,
  json jScissor,
  json jList
)
{
  json ret = JsonObjectSet(jElem, "draw_list", jList);
  JsonObjectSetInplace(ret, "draw_list_scissor", jScissor);
  return ret;
}

// json
// NuiCanvas(
//   json jList
// )
// {
//   json ret = NuiElement("canvas", JsonNull(), jList);
//   return ret;
// }
