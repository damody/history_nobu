"use strict";
function OpenWeb(table){
    $.Msg("open web")
}

(function () {
    GameEvents.Subscribe("open_web", OpenWeb );
  })();