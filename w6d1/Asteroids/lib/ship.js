// // (function() {
// //   if (typeof Asteroids === 'undefined') {
// //     window.Asteroids = {};
// //   }
// //
// // })();
//
// (function () {
//   if (typeof Asteroids === "undefined") {
//     window.Asteroids = {};
//   }
//
//   function randomColor() {
//     var hexDigits = "0123456789ABCDEF";
//
//     var color = "#";
//     for (var i = 0; i < 3; i ++) {
//       color += hexDigits[Math.floor((Math.random() * 16))];
//     }
//
//     return color;
//   }
//
//   var Ship = Asteroids.Ship = function (options) {
//     options.radius = Ship.RADIUS;
//     options.vel = options.vel || [0, 0];
//     options.color = options.color || randomColor();
//
//     Asteroids.MovingObject.call(this, options)
//   };
//
//   Ship.RADIUS = 15;
//
//   Asteroids.Util.inherits(Ship, Asteroids.MovingObject);
//
//   Ship.prototype.fireBullet = function () {
//     var norm = Asteroids.Util.norm(this.vel);
//
//     if (norm == 0) {
//       // Can't fire unless moving.
//       return;
//     }
//
//     var relVel = Asteroids.Util.scale(
//       Asteroids.Util.dir(this.vel),
//       Asteroids.Bullet.SPEED
//     );
//
//     var bulletVel = [
//       relVel[0] + this.vel[0], relVel[1] + this.vel[1]
//     ];
//
//     var bullet = new Asteroids.Bullet({
//       pos: this.pos,
//       vel: bulletVel,
//       color: this.color,
//       game: this.game
//     });
//
//     this.game.add(bullet);
//   };
//
//   Ship.prototype.power = function (impulse) {
//     this.vel[0] += impulse[0];
//     this.vel[1] += impulse[1];
//   };
//
//   Ship.prototype.relocate = function () {
//     this.pos = this.game.randomPosition();
//     this.vel = [0, 0];
//   };
// })();
