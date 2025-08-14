var drainAmount:Float = 0;
var healthLimit:Float = 0.2;
function onEvent(n, v1, v2)
{
    if (n == 'Health Drain')
    {
      drainAmount = v1;
      healthLimit = v2;
    }
}
function opponentNoteHit(n)
{
    game.health -= drainAmount;
}
function onUpdatePost(elapsed:Float) 
if(game.health <= 0.2)  game.health = 0.2;