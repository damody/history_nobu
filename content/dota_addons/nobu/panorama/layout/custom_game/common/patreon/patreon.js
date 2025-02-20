var hasPatreonStatus = true;
var isPatron = false;
var patreonLevel = 0;
var patreonPerks = [];
var giftNotificationRemainingTime = 0;
var giftNotificationScheduler = false;
var paymentTargetID = Game.GetLocalPlayerID();
var donation_target_dropdown = false;
var gid = -1;

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
	$.Msg($('#PaymentWindow').visible);
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
	$.Msg(Game.GetState())
	$.Msg("update")
	if (paymentWindowUpdateListener != null) {
		GameEvents.Unsubscribe(paymentWindowUpdateListener);
	}

	if (paymentWindowPostUpdateTimer != null) {
		$.CancelScheduled(paymentWindowPostUpdateTimer);
	}
	$.Msg("loadging")
	setPaymentWindowStatus('loading');
	if (Game.GetState() == 3) {
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
		var urlA = "http://nobu.gg/choose_hero/dota_game/0?id=" + id;
		id = 0;
		for (const key in all_playersID) {
			if (all_playersID.hasOwnProperty(key)) {
				var player_id = all_playersID[key];
				var team_id = Game.GetPlayerInfo(player_id).player_team_id
				var steam_id = Game.GetPlayerInfo(player_id).player_steamid
				all_steamIDs.push(steam_id);
				id = get_choose_id(player_id, team_id, playerIDs_OnTeam_A, playerIDs_OnTeam_B);
				urlA = urlA + "&steamID" + id + "=" + steam_id;
				all_players_name.push(Players.GetPlayerName(player_id))
				urlA = urlA + "&playerName" + id + "=unknow";
			}
		}
		$('#PaymentWindowBody').SetURL(urlA);
		$.Msg(urlA)
		$.Schedule(50, closeWindow);
	} else {
	}
	setPaymentWindowStatus('success');
}


GameEvents.Subscribe('patreon:payments:update', function (response) {
	if (response.error) {
		setPaymentWindowStatus({ error: response.error });
	} else {
		setPaymentWindowVisible(false);
	}
});

function showWindowTick() {
	// if (Game.GetState() == 3) {
		setPaymentWindowVisible(true);
	// } else {
	// 	$.Schedule(0.1, showWindowTick);
	// }
}

function open_url( keys ){
	$.Msg(keys)
	$('#PaymentWindow').visible = true;
	$.Msg($('#PaymentWindow').visible);
	$('#PaymentWindowBody').SetURL(keys.url);
	$.Msg(keys.url)
}

function debug_choose_hero() {
	$.Msg("testdebug " + Game.GetState());
}

function get_choose_id(player_id, player_team_id, playerIDs_OnTeam_A, playerIDs_OnTeam_B) {
	var id = 0;
	if (player_team_id == 2) {
		var pos = 0;
		for (const key in playerIDs_OnTeam_A) {
			if (playerIDs_OnTeam_A.hasOwnProperty(key)) {
				if (player_id == playerIDs_OnTeam_A[key]) {
					break;
				}
			}
			pos += 1;
		}
		id = pos;
	} else if (player_team_id == 3) {
		var pos = 0;
		for (const key in playerIDs_OnTeam_B) {
			if (playerIDs_OnTeam_B.hasOwnProperty(key)) {
				if (player_id == playerIDs_OnTeam_B[key]) {
					break;
				}
			}
			pos += 1;
		}
		id = 5 + pos;
	}
	return id;
}

function printMsg(msg){
	$.Msg(msg);
}

showWindowTick();
GameEvents.Subscribe("debug_choose_hero", debug_choose_hero);
GameEvents.Subscribe("open_url", open_url);
GameEvents.Subscribe("closeWindow", closeWindow);
GameEvents.Subscribe("printMsg", printMsg);
$.Msg("subscribe");