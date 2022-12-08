// ROTATE AN AI SPRITE TO PLAYER
// Code within 'void update()':

//What is the difference in position?
// 'targetPosition' is the position (Vector2) of the player.
Vector2 diff = targetPosition - (Vector2)(this.transform.position);

//We use Atan2 since it handles negative numbers and division by zero errors.
float angle = Mathf.Atan2(diff.y, diff.x);

//Now we set our new rotation.
this.transform.rotation = Quaternion.Euler(0f, 0f, angle * Mathf.Rad2Deg);
