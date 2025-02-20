
var slider = $.GetContextPanel().FindChildInLayoutFile("Slider1");
var lastValue = 0;

function OnValueChanged(slider) {
  $.Msg(slider.value);
  GameUI.SetCameraDistance(slider.value);
}

function Check() {
  if (slider.value != lastValue)
    OnValueChanged(slider);
  lastValue = slider.value;
  $.Schedule(0.03, Check);

}

function UpdateDireScore(keys) {
  var y = $.GetContextPanel().GetParent().GetParent().GetParent();
  y = y.FindChildTraverse('HUDElements')
  y = y.FindChildTraverse('topbar')
  var direScore = y.FindChildTraverse('TopBarDireScore')
  if (keys.score) {
    direScore.text = keys.score;
  }
}

(function () {
  GameEvents.Subscribe("UpdateDireScore", UpdateDireScore);
  slider.min = 500;
  slider.max = 1600;
  slider.value = 1100;
  lastValue = slider.value;
  $.Schedule(0.03, Check);
  var y = $.GetContextPanel().GetParent().GetParent().GetParent();
  y = y.FindChildTraverse('HUDElements')
  var inv1 = y.FindChildTraverse('RadarButton')
  // inv1.visible = false
  var inv1 = y.FindChildTraverse('GlyphScanContainer')
  var inv1 = y.FindChildTraverse('glyph')
  inv1.visible = false
  
  y = y.FindChildTraverse('topbar')
  // var dire = y.FindChildTraverse('TopBarDireTeam')
  var direScore = y.FindChildTraverse('TopBarDireScore')
  direScore.text = 0;
  // var radiant = y.FindChildTraverse('TopBarRadiantTeam')
  // var TopBarDirePlayers = dire.FindChildTraverse('TopBarDirePlayers')
  // var TopBarRadiantPlayers = radiant.FindChildTraverse('TopBarRadiantPlayers')
  // TopBarDirePlayers.SetParent('TopBarRadiantTeam')
  // TopBarRadiantPlayers.SetParent('TopBarDireTeam')
  // $.Msg(dire.id);

  // 暫時先讓所有和天賦樹的UI都點不到
  $.Msg("Disable Talent Tree")
  var x = $.GetContextPanel().GetParent().GetParent().GetParent();
  x = x.FindChildTraverse('HUDElements')
  x = x.FindChildTraverse('lower_hud')
  x = x.FindChildTraverse('center_with_stats')
  x = x.FindChildTraverse('center_block')
  var level_stats_frame = x.FindChildTraverse('level_stats_frame')
  level_stats_frame.RemoveClass('CanLevelStats')
  level_stats_frame.hittest = false
  level_stats_frame.hittestchildren = false
  level_stats_frame.FindChildTraverse('LevelUpBurstFX').visible = false
  var LevelUpTab = level_stats_frame.FindChildTraverse('LevelUpTab')
  var LevelUpButton = LevelUpTab.FindChildTraverse('LevelUpButton')
  var LevelUpIcon = LevelUpTab.FindChildTraverse('LevelUpIcon')
  // var LevelUpGlow = LevelUpTab.FindChildTraverse('LevelUpGlow')
  // $.Msg(123123)
  // $.Msg(LevelUpGlow)
  // $.Msg(123123)
  // // LevelUpGlow.background-image = "";
  LevelUpButton.visible = false
  LevelUpIcon.visible = false
  x = x.FindChildTraverse('AbilitiesAndStatBranch')
  x = x.FindChildTraverse('StatBranch')
  x.hittest = false
  x.hittestchildren = false
  // 暫時讓給控制權看不到也點不到
  var y = $.GetContextPanel().GetParent().GetParent().GetParent();
  y = y.FindChildTraverse('HUDElements')
  y = y.FindChildTraverse('scoreboard')
  y = y.FindChildTraverse('Background')
  y = y.FindChildTraverse('NestedMenuButtons')
  y = y.FindChildTraverse('NestContainer')
  var sharedContentButton = y.FindChildTraverse('SharedContentButton')
  var sharedUnitsButton = y.FindChildTraverse('SharedUnitsButton')
  sharedContentButton.visible = false
  sharedContentButton.hittest = false
  sharedContentButton.hittestchildren = false
  sharedUnitsButton.visible = false
  sharedUnitsButton.hittest = false
  sharedUnitsButton.hittestchildren = false
  $.Msg("testsetset")
  // 建立一個panel
  var item_height = "36px"
  var item_width = "36px"
  var HUDElements = $.GetContextPanel().GetParent().GetParent().GetParent()
  // HUDElements = HUDElements.FindChildTraverse('HUDElements')
  // this.panel = $.CreatePanel("Panel", $("#DotaHud_trasform"), "")
  // this.panel.BLoadLayoutSnippet("Shop")
  var largeMainPanelWidth = '450px'
  var largeMainPanelHeight = '1000px'
  var shop = $.GetContextPanel().GetParent().GetParent().GetParent()
  shop = shop.FindChildTraverse('HUDElements')
  shop = shop.FindChildTraverse('shop')
  // if (shop == null) {
  //   shop = this.panel.FindChildTraverse("shop")
  // } else {
  //   shop.SetParent(this.panel.FindChildTraverse("shop_transform"))
  // }
  var shop_main = shop.FindChildTraverse("Main")
  var shop_grid = shop.FindChildTraverse("GridMainShopContents")
  shop.FindChildTraverse("GuideFlyout").visible = false
  // $.Msg(shop.style)
  shop.style.width = largeMainPanelWidth  
  shop.style.height = largeMainPanelHeight
  shop.style.marginTop = "0px"
  // shop.style.marginBottom = "0px"
  shop_main.style.width = largeMainPanelWidth

  // 調整商店物品大小
  for (var i = 0; i < shop_grid.GetChildCount(); i++) {
    var shoptype = shop_grid.GetChild(i)
    $.Msg(shoptype.id)
    for (var j = 0; j < shoptype.GetChildCount(); j++) {
      var items = shoptype.GetChild(j)
      $.Msg(items.id)
      for (var k = 0; k < items.GetChildCount(); k++) {
        var itemsContainer = items.GetChild(k).FindChildTraverse("ShopItemsContainer")
        if (itemsContainer != null) {
          for (var m = 0; m < itemsContainer.GetChildCount(); m++) {
            var item = itemsContainer.GetChild(m)
            var itemOverlay = item.FindChildTraverse("CanPurchaseOverlay")
            item.style.height = item_height
            item.style.width = item_width
            itemOverlay.style.height = item_height
            itemOverlay.style.width = item_width
          }
        }
      }
    }
  }

  var test = HUDElements.FindChildTraverse("combat_events")
  test.backgroundColor = "red"
})();