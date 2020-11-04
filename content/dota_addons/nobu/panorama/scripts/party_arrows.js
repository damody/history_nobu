"use strict";

function test() {
  $.Msg("123");
  var arrowsContainer = $("#DonateImages");
  $.Msg(arrowsContainer);
  var localPlayerInfo = Game.GetLocalPlayerInfo();
  var players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);

  var screenWidth = arrowsContainer.actuallayoutwidth;
  var screenHeight = arrowsContainer.actuallayoutheight;
  $.Msg(screenWidth);
  $.Msg(screenHeight);
  var screenXMid = screenWidth / 2;
  var screenYMid = screenHeight / 2;

  for (var i in players) {
    var playerID = players[i];
    var donatePanelName = "DonateImage" + playerID;
    var playerHeroEntIndex = Players.GetPlayerHeroEntityIndex(playerID);
    var donatePanel = arrowsContainer.FindChild(donatePanelName);
    // $.Msg(donatePanel);
    if (donatePanel === null) {
      if (playerHeroEntIndex === -1) continue;
      $.Msg("Creating a player arrow");
      donatePanel = $.CreatePanel("Panel", arrowsContainer, donatePanelName);
      donatePanel.SetAttributeInt("player_id", playerID);
      donatePanel.BLoadLayoutSnippet("DonateImage");
    }
    var objectSize = 300;

    var vPos = Entities.GetAbsOrigin(playerHeroEntIndex);
    var screenX = screenWidth - objectSize;
    var screenY = screenHeight - objectSize;

    var posOut = GameUI.WorldToScreenXYClamped(vPos);
    $.Msg(posOut);
    var posX = posOut[0] * screenWidth;
    var posY = posOut[1] * screenHeight;

    //adjust the position by the image size
    posX = posX - screenX / 2;
    posX -= objectSize / 2;
    posY -= objectSize / 2;
    $.Msg("posX : " + posX);
    $.Msg("screenX : " + screenX);
    $.Msg("posY : " + posY);
    $.Msg("screenY : " + screenY);

    var bOffscreen = false;
    if (posX > screenX/2 || posX < -1*screenX/2) {
      posX = screenX;
      bOffscreen = true;
    }

    if (posY > screenY || posY < 0) {
      posY = screenY;
      bOffscreen = true;
	}
	$.Msg(bOffscreen);
	donatePanel.SetHasClass("Hidden", bOffscreen);
	if (!bOffscreen) {
		donatePanel.style.x = posX + "px";
		donatePanel.style.y = posY + "px";
	}
  }
  $.Schedule(1.0 / 60.0, test);
}

GameEvents.Subscribe("test", test);
