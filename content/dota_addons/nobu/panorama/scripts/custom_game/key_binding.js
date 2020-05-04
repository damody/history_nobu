function OnExecuteAbility1ButtonPressed()
{
	GameEvents.SendCustomGameEventToServer("nobu_player_execute_ability1", {})
}

(function() {
    Game.AddCommand( "+CustomGameExecuteAbility1", OnExecuteAbility1ButtonPressed, "", 0 );
)();



