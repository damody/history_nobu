var hasPatreonStatus = true;
var isPatron = false;
var patreonLevel = 0;
var patreonPerks = [];
var giftNotificationRemainingTime = 0;
var giftNotificationScheduler = false;
var paymentTargetID = Game.GetLocalPlayerID();
var donation_target_dropdown = false;

function setPaymentWindowVisible(visible) {
	// GameEvents.SendCustomGameEventToServer('patreon:payments:window', { visible: visible });
	$('#PaymentWindow').visible = visible;
	$.Msg($('#PaymentWindow').visible);
	// $('#SupportButtonPaymentWindow').checked = visible;
	if (visible) {
		$.Schedule(0, updatePaymentWindow);
	}
}

function closeWindow() {
	$('#PaymentWindow').visible = false;
}

/** @param {'success' | 'loading' | { error: string }} status */
function setPaymentWindowStatus(status) {
	var isError = typeof status === 'object';
	$('#PaymentWindowBody').visible = status === 'success';
	if (isError) {
		$('#PaymentWindowErrorMessage').text = status.error;
	}
}

var createPaymentRequest = createEventRequestCreator('patreon:payments:create');

var paymentWindowUpdateListener;
var paymentWindowPostUpdateTimer;
function updatePaymentWindow() {
	$.Msg("update")
	if (paymentWindowUpdateListener != null) {
		GameEvents.Unsubscribe(paymentWindowUpdateListener);
	}

	if (paymentWindowPostUpdateTimer != null) {
		$.CancelScheduled(paymentWindowPostUpdateTimer);
	}
	$.Msg("loadging")
	setPaymentWindowStatus('loading');
	var player_id = Game.GetLocalPlayerID();
	var all_playersID = Game.GetAllPlayerIDs();
	var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID())
	var player_team_id = playerInfo.player_team_id;
	var all_steamIDs = [];
	var all_players_name = [];
	//2織田軍 3聯合軍
	var playerIDs_OnTeam_A = Game.GetPlayerIDsOnTeam(2);
	var playerIDs_OnTeam_B = Game.GetPlayerIDsOnTeam(3);
	var id = get_choose_id(player_id, player_team_id, playerIDs_OnTeam_A, playerIDs_OnTeam_B);
	var url = "http://103.29.70.64:88/game/123?id=" + id;
	for (const key in all_playersID) {
		if (all_playersID.hasOwnProperty(key)) {
			var player_id = all_playersID[key];
			var team_id = Game.GetPlayerInfo(player_id).player_team_id
			var steam_id = Game.GetPlayerInfo(player_id).player_steamid
			var steam_id_num = 0;
			var multi = 1000000000000;
			for (i = 4; i < steam_id.length; i++) {
				steam_id_num += steam_id[i] * multi;
				multi /= 10;
			}
			steam_id_num -= 1197960265728;
			all_steamIDs.push(steam_id_num);
			var id = get_choose_id(player_id, team_id, playerIDs_OnTeam_A, playerIDs_OnTeam_B);
			url = url + "&steamID" + id + "=" + steam_id_num;
			all_players_name.push(Players.GetPlayerName(player_id))
			url = url + "&playerName" + id + "=" + Players.GetPlayerName(all_playersID[key]);
		}
	}
	$.Msg(url)
	$('#PaymentWindowBody').SetURL(url);
	setPaymentWindowStatus('success');
	$.Schedule(35, closeWindow);
}

GameEvents.Subscribe('patreon:payments:update', function (response) {
	if (response.error) {
		setPaymentWindowStatus({ error: response.error });
	} else {
		setPaymentWindowVisible(false);
	}
});

function showWindowTick() {
	if (Game.GetState() == 3) {
		setPaymentWindowVisible(true);
	} else {
		$.Schedule(0.1, showWindowTick);
	}
}

function debug_choose_hero() {
	$.Msg(Game.GetState());
}

function get_choose_id(player_id, player_team_id, playerIDs_OnTeam_A, playerIDs_OnTeam_B) {
	var id = 0;
	if (player_team_id == 2) {
		var pos = 0;
		for (const key in playerIDs_OnTeam_A) {
			if (playerIDs_OnTeam_A.hasOwnProperty(key)) {
				if (player_id == playerIDs_OnTeam_A[key]) {
					pos = key;
					break;
				}
			}
		}
		id += pos * 1;
	} else if (player_team_id == 3) {
		var pos = 0;
		for (const key in playerIDs_OnTeam_B) {
			if (playerIDs_OnTeam_B.hasOwnProperty(key)) {
				if (player_id == playerIDs_OnTeam_B[key]) {
					pos = key;
					break;
				}
			}
		}
		id += pos * 1 + 5;
	}
	return id;
}

showWindowTick();
GameEvents.Subscribe("debug_choose_hero", debug_choose_hero);